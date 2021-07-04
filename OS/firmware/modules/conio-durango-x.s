; firmware module for minimOS
; Durango-X firmware console 0.9.6a1
; 16x16 text 16 colour _or_ 32x32 text b&w
; (c) 2021 Carlos J. Santisteban
; last modified 20210705-0032

; ****************************************
; CONIO, simple console driver in firmware
; ****************************************
; template with temporary IO9 input support (no handshake!)
;	INPUT
; Y <-	char to be printed (1...255)
;	supported control codes in this version
;		0	= ask for one character (non-locking)
;		1	= start of line (CR withput LF, eg. set Y to one so DEY sets Z and skips LF routine)
;		2	= cursor left
;		6	= cursor right
;		7	= beep
;		8	= backspace
;		9	= TAB (x+8 AND 248 in any case)
;		10	= line feed (cursor down, direct jump needs no Y set)
;		11	= cursor up
;		12	= clear screen AND initialise device
;		13	= newline (actually LF after CR, eg. set Y to two or more so DEY clears Z and does LF)
;		14	= inverse video
;		15	= true video
;		16	= DLE, do not execute next control char
;		18	= set ink colour (MOD 16 in colour mode, MOD 2 in hires)\*
;		20	= set paper colour (ditto)\*
;		21	= home without clear
;		31	= back to text mode (simply IGNORED)
; commands marked \* will take a second char as parameter
; *** NOT YET supported (will show glyph like after DLE) ***
;		3	= TERM (?)
;		4	= end of screen
;		5	= end of line
;		17	= cursor on (no cursor yet?) _might show current position for a split second_
;		19	= cursor off (no cursor yet?)
;		22	= page down (?)
;		23	= set cursor position (!!!)
;		24	= backtab
;		25	= page up (?)
;		26	= switch focus (?)
;		27	= escape (?)
;		28...30	= Tektronix graphic commands
;	OUTPUT
; C ->	no available char (if Y was 0)

#include "../../usual.h"

#define	IOSCREEN	_IOSCREEN


.(
pvdu	= $6000				; base address
IO9di	= $9FFF				; data input (TBD)
IO8attr	= $8000				; compatible IO8lh for setting attributes (d7=HIRES, d6=INVERSE)
IOBeep	= $BFF0				; canonical buzzer address (d0)

	TYA						; is going to be needed here anyway
	LDX fw_cbin				; check whether in binary mode (must be reset on FF)
	BNE cio_dle				; if not, check whether command (including INPUT) or glyph
		CMP #32				; printable anyway?
		BCS cio_prn			; go for it, flag known to be clear
;			AND #31			; if arrived here, it MUST be below 32!
			ASL				; two times
			TAX				; use as index
			CLC				; will simplify most returns as DR_OK becomes just RTS
			_JMPX(cio_ctl)	; execute from table
cio_dle:
	_STZY fw_cbin			; clear flag!
cio_prn:
; ***********************************
; *** output character (now in A) ***
; ***********************************
			ASL				; times eight
			ROL cio_src+1	; M=???????7, A=6543210·
			ASL
			ROL cio_src+1	; M=??????76, A=543210··
			ASL
			ROL cio_src+1	; M=?????765, A=43210···
			CLC
			ADC #<font		; add font base
			STA cio_src
			LDA cio_src+1	; A=?????765
			AND #7			; A=·····765
			ADC #>font
;			DEC				; or add >font -1 if no glyphs for control characters
			STA cio_src+1	; pointer to glyph is ready
			LDA fw_ciop		; get current address
			LDX fw_ciop+1
			STA cio_pt		; set pointer
			STX cio_pt+1
			LDY #0			; reset offset
cp_loop:
				_LDAX(cio_src)	; glyph pattern
				STA (cio_pt), Y
				INC cio_src	; advance raster in font data, single byte
				BNE cp_nras
					INC cio_src
cp_nras:
				TYA			; advance offset to next raster
				CLC
				ADC #16
				TAY
				BPL cp_loop	; offset always below 128 (8x16)
; advance screen pointer before exit
			INC fw_ciop
			LDA fw_ciop
#ifndef	NMOS
			BIT #%01110000	; check possible linewrap (CMOS, may use AND plus LDA afterwards)
#else
			AND #%01110000
#endif
			BEQ cn_newl
cn_end:
				_DR_OK		; make sure C is clear
cn_newl:
#ifdef	NMOS
			DEC fw_ciop		; eeeeeek
#else
			DEC
#endif
			BNE cn_cr		; code shared with CR
; anything else, or must be BRA?






;		AND #$7F			; in order to strip extended ASCII
; no longer checks control chars here, just glyph!
/*		CMP #FORMFEED		; reset device?
		BNE cn_nff			; no, just print it
; * clear screen, not much to be inited *
			LDY #<pvdu		; initial address
			LDX #>pvdu		; valid MSB for IOSCREEN, black-on-white mode (%01111xxx) instead of inverse for Pacman (%00001xxx)
			STY cio_pt		; set ZP pointer
			STX cio_pt+1
			STY fw_ciop		; worth resetting global pointer (cursor) here (conio.h?)
			STX fw_ciop+1
;			LDY #0			; no need to reset index
			TYA				; clear accumulator
cls_p:
cls_l:
					STA (cio_pt), Y	; clear screen byte
					INY
					BNE cls_l		; continue within page
				INC cio_pt+1
				BPL cls_p	; same as cls_l if not using IOSCREEN
			_DR_OK
; continue evaluating control codes
cn_nff:
		CMP #BS				; backspace?
		BNE cn_nbs
; * clear previous char *
; coordinates are stored 01111yyy y000xxxx
; y will remain constant, xxxx may go down to zero
; if xxxx is zero, do nothing... but better clear first char in line
; will never cross page!
; with no cursor, best to clear current char after backing
			LDA fw_ciop		; get LSB (yrrrxxxx)
			AND #$F			; check xxxx
			BEQ bs_clr		; already at line start
				DEC fw_ciop	; back one character (cannot be xxxx=0 as already checked for that)
bs_clr:
			LDA fw_ciop		; get current address (perhaps after backing)
			LDX fw_ciop+1
			STA cio_pt		; set pointer
			STX cio_pt+1
			LDY #0			; reset offset
bs_loop:
				LDA #0		; clear value
				STA (cio_pt), Y
				TYA			; advance offset to next raster
				CLC
				ADC #16
				TAY
				BPL bs_loop	; offset always below 128 (8x16)
			_DR_OK
cn_nbs:
		CMP #CR				; new line?
		BNE cn_ncr
#ifdef	NMOS
cn_cr:						; NMOS version needs this extra LDA for linewrap
#endif
			LDA fw_ciop		; current position (LSB)
; *** common code with line wrap ***
#ifndef	NMOS
cn_cr:
#endif
			AND #$80		; the actual CR eeeeeeeek
			CLC
			ADC #$80		; then LF
			STA fw_ciop
			BCC cn_cre		; check carry
				INC fw_ciop+1
				BPL cn_cre
; ** this far, no scrolling, just wrap **
					LDA #>pvdu
					STA fw_ciop+1
cn_cre:
			_DR_OK
cn_ncr:
		CMP #DLE			; check for DLE
		BNE cn_ndle
; *** set binary mode ***
			INC fw_cbin		; set binary mode, safe enough if reset with STZ
cn_ndle:
; anything else?
*/

; **********************
; *** keyboard input ***
; **********************
; IO9 port is read, normally 0
; any non-zero value is stored and returned the first time, otherwise returns empty (C set)
; any repeated characters must have a zero inbetween, 10 ms would suffice (perhaps as low as 5 ms)
cn_in:
	LDY IO9di				; get current data at port
	BEQ cn_empty			; no transfer is in the making
		CPY fw_io9			; otherwise compare with last received
	BEQ cn_ack				; same as last, keep trying
		STY fw_io9			; this is received and different
		_DR_OK				; send received
cn_empty:
	STY fw_io9				; keep clear
cn_ack:
	_DR_ERR(EMPTY)			; set C instead eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeek

; ************************
; *** control routines ***
; ************************
cn_cr:
; this is the CR without LF
	LDY #1					; will skip LF routine
	BNE cn_begin

cn_newl:
; CR, but will do LF afterwards by setting Y appropriately
		TAY					; Y=13, thus allows full newline
cn_begin:
; ** do CR... but keep Y
; make LSB AND %11100000 (hires) / %11000000 (colour)
	LDA #%11100000			; base mask for hires
	LDX fw_hires			; was it in hires mode?
	BNE cn_lmok
		LDA #%11000000		; otherwise, set colour mode mask
cn_lmok:
	AND cio_pt				; mask bits from LSB
	STA cio_pt
; check whether LF is to be done
	DEY						; LF needed?
	BEQ cn_ok				; not if Y was 1 (use BMI if Y was zeroed for LF)

cn_lf:
; ** do LF, adds 1 (hires) or 2 (colour) to MSB
	LDA #1					; similarly, set base increase for hires and shift it left for colour
	LDX fw_hires			; was it in hires mode?
	BNE cn_hmok
		ASL					; otherwise, set colour mode increase, keeps C clear
cn_hmok:
	ADC cio_pt+1			; increment MSB accordingly, C should remain clear!
	STA cio_pt+1
; *** not so fast, must check for possible scrolling!!!
cn_ok:
	RTS

cn_tab:
; advance column to the next 8x position (all modes)
	LDA cio_pt				; this is LSB, contains X
	ADC #8					; advance...
	AND #%11111000			; ...but round down position
	STA cio_pt
; *** not so fast, must check for possible line wrap... and even scrolling!
	_DR_OK					; might set C, but could be removed if reuses the last check after LF

cn_dle:
; DLE, set binary mode
;	LDX #1					; perhaps anything not zero is OK
	STX fw_cbin				; set binary mode and we are done
	RTS

; SO, set inverse mode
cn_so:
	LDA #$FF				; OK for all modes?
	STA cp_mask				; set value to be EORed
	RTS

; SI, set inverse mode
cn_si:
	_STZA cp_mask			; clear value to be EORed
	RTS

cn_dle:
; DLE, set binary mode
;	LDX #1					; perhaps anything not zero is OK
	STX fw_cbin				; set binary mode and we are done
	RTS



; *** table of pointers to control char routines ***
cio_ctl:
	.word	cn_in			; 0, INPUT mode
	.word	cn_cr			; 1, CR
	.word	; 2, cursor left
	.word	cio_prn			; 3 ***
	.word	cio_prn			; 4 ***
	.word	cio_prn			; 5 ***
	.word	; 6, cursor right
	.word	; 7, beep
	.word	; 8, backspace
	.word	cn_tab			; 9, tab
	.word	cn_lf			; 10, LF
	.word	; 11, cursor up
	.word	; 12, FF clears screen and resets modes
	.word	cn_newl			; 13, newline
	.word	cn_so			; 14, inverse
	.word	cn_si			; 15, true video
	.word	cn_dle			; 16, DLE, set flag
	.word	cio_prn			; 17 ***
	.word	; 18, set ink from next char...
	.word	cio_prn			; 19 ***
	.word	; 20, set paper from next char...
	.word	cio_home		; 21, home (what is done after CLS)
	.word	cio_prn			; 22 ***
	.word	cio_prn			; 23, should I implement it?
	.word	cio_prn			; 24 ***
	.word	cio_prn			; 25 ***
	.word	cio_prn			; 26 ***
	.word	cio_prn			; 27 ***
	.word	cio_prn			; 28 ***
	.word	cio_prn			; 29 ***
	.word	cio_prn			; 30 ***
	.word	cn_end			; 31, IGNORE back to text mode

font:
#include "../../drivers/fonts/8x8.s"
.)
