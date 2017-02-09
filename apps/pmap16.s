; memory map for minimOS! KLUDGE
; v0.5.1b4
; last modified 20170209-1438
; (c) 2016-2017 Carlos J. Santisteban

#include "usual.h"
.(
; *** declare zeropage variables ***
; ##### uz is first available zeropage byte #####
	page	= uz		; start of current block
	current	= page+2	; index storage

; ...some stuff goes here, update final label!!!
	__last	= current+1	; ##### just for easier size check #####

; ##### include minimOS headers and some other stuff #####
#ifndef	NOHEAD
	.dsb	$100*((* & $FF) <> 0) - (* & $FF), $FF	; page alignment!!! eeeeek
pmapHead:
; *** header identification ***
	BRK						; do not enter here! NUL marks beginning of header
	.asc	"mV", CPU_TYPE	; minimOS app! 65c816 only
	.asc	"****", 13		; some flags TBD

; *** filename and optional comment ***
	.asc	"pmap16", 0		; file name (mandatory)
	.asc	"Display memory map", CR			; comment
	.asc	"16-bit minimOS 0.5.1 only!!!", 0

; advance to end of header
	.dsb	pmapHead + $F8 - *, $FF	; for ready-to-blow ROM, advance to time/date field

; *** date & time in MS-DOS format at byte 248 ($F8) ***
	.word	$6000			; time, 12.00
	.word	$4A49			; date, 2017/2/09

pmap16Size	=	pmapEnd - pmapHead -256	; compute size NOT including header!

; filesize in top 32 bits NOT including header, new 20161216
	.word	pmap16Size		; filesize
	.word	0				; 64K space does not use upper 16-bit
#endif
; ##### end of minimOS executable header #####

; ************************
; *** initialise stuff ***
; ************************

; ##### minimOS specific stuff #####
	LDA #__last-uz		; zeropage space needed
; check whether has enough zeropage space
#ifdef	SAFE
	CMP z_used			; check available zeropage space
	BCC go_pmap			; enough space
	BEQ go_pmap			; just enough!
		_ABORT(FULL)		; not enough memory otherwise (rare) new interface
go_pmap:
#endif
	STA z_used			; set needed ZP space as required by minimOS
; will not use iodev as will work on default device
; ##### end of minimOS specific stuff #####
	.al: REP #$20		; *** 16-bit memory ***
	
	LDA #splash			; address of splash message (plus column header)
	JSR prnStrW			; print the string!

; ********************
; *** begin things ***
; ********************

	LDY #0				; reset index
	STY current			; avoid 16-bit STZ
pmap_loop:
		LDX #'$'			; print hex radix
		JSR prnCharW
		LDY current			; retrieve index
		LDA ram_pos, Y		; get this block address
		STA page			; store for further size computation
		XBA					; let us look the bank address before
		JSR byte2hex		; print bank...
		XBA					; ...and switch to page address
		JSR byte2hex
		LDA #pmt_lsb		; string for trailing zeroes
		JSR prnStrW
		LDY current			; index again, needed?
		LDX ram_stat, Y		; check status of this, use as index
		JMP (pmap_tab, X)	; process as appropriate

; * print suffix in X, new line and complete loop *
pmap_next:
		JSR prnCharW		; print suffix
pmap_cr:
		LDX #CR				; new line
		JSR prnCharW
		BRA pmap_loop		; and go for next entry

; manage used block
pmap_used:
	LDA #pmt_pid		; string for PID prefix
	JSR prnStrW
	LDY current			; restore index
	LDA ram_pid, Y		; get corresponding PID
	JSR byte2hex		; print it
; ...and finish line with block size

; * common ending with printed size, pages or KB *
pmap_size:
	LDX #' '			; print leading space
	JSR prnCharW
	LDY current			; get old index
	INY					; check next block!
	INY					; 16 bit entries!!!!
	STY current			; update byte
	LDA ram_pos, Y		; get next block position
	SEC
	SBC page			; subtract start of block
	CMP #4				; check whether below 1k
	BCS pmap_kb
		INC					; round up pages!
		JSR b2h_num			; will not be over 4
		LDX #'p'			; page suffix
		BRA pmap_next		; print suffix, CR and go for next
pmap_kb:
	LSR					; divide by 4
	LSR
		BCC pm_nround	; if C, round up!
			INC
pm_nround:
; print A in decimal and continue! *******REVISE
/* have a look at this
unsigned divu10(unsigned n) {
    unsigned q, r;
    q = (n >> 1) + (n >> 2);
    q = q + (q >> 4);
    q = q + (q >> 8);
    q = q + (q >> 16);
    q = q >> 3;
    r = n - (((q << 2) + q) << 1);
    return q + (r > 9);
}
*/
	LDX #0				; decade counter
pkb_div10:
		CMP #10				; something to count?
			BCC pkb_unit		; less than 10
		SBC #10				; otherwise subtract 10 (carry was set)
		INX					; and increase decade
		BRA pkb_div10		; until exit above
pkb_unit:
	PHA					; save units
	TXA					; decades will not be over 6*****
	JSR b2h_num			; print ASCII
	PLA					; retrieve units
	JSR b2h_ascii		; convert & print
	LDX #'K'
	BRA pmap_next		; print suffix, CR and go for next

; manage locked list
pmap_lock:
	LDA #pmt_lock		; string for locked label
	JSR prnStrW
	BRA pmap_size		; finish line with block size

; manage free block
pmap_free:
	LDY #<pmt_free		; string for free label
	LDA #>pmt_free
	JSR prnStr
	BRA pmap_size		; finish line with block size

; manage end of list
pmap_end:
	LDA #pmt_end		; string for end label
	JSR prnStrW
	_FINISH				; *** all done ***


; *** table for routine pounters, as defined in abi.h ***
pmap_tab:
	.word	pmap_free
	.word	pmap_used
	.word	pmap_end
	.word	pmap_lock

; *** useful routines ***

; ** these will go into a pseudolibrary **
; * print binary in A as two hex ciphers *
byte2hex:
	PHA			; keep whole value
	LSR			; shift right four times (just the MSN)
	LSR
	LSR
	LSR
	JSR b2h_ascii	; convert and print this cipher
	PLA			; retrieve full value
	AND #$000F	; keep just the LSN... and repeat procedure
b2h_ascii:
	CMP #10		; will be a letter?
	BCC b2h_num	; just a number
		ADC #6			; convert to letter (plus carry)
b2h_num:
	ADC #'0'	; convert to ASCII (carry is clear)
; ...and print it (will return somewhere)
	TAX			; where the following function expects it

; * print a character in A *
prnCharW:
	STX io_c			; store character
	LDY #0				; use default device
	_KERNEL(COUT)		; output it ##### minimOS #####
; ignoring possible I/O errors
	RTS

; * print a NULL-terminated string pointed by $AAYY *
prnStrW:
	STA str_pt			; store full pointer
	LDY #0				; standard device
	_KERNEL(STRING)		; print it! ##### minimOS #####
; currently ignoring any errors...
	RTS


; *** strings and other data ***
splash:
	.asc	"pmap16 0.5.1", CR
	.asc	"(c) 2016-2017 Carlos J. Santisteban", CR
	.asc	" Addr.  PID  Size", CR, 0		; header

; format as follows
; 0123456789012345-789 (16 & 20 char)
;  Addr.  PID  Size
; $001200 #$07 3p
; $005600 FREE 15K
; $000400 LOCK 31K
; $008000 [  END  ]

pmt_free:
	.asc	"Free", 0

pmt_lock:
	.asc	"LOCK", 0

pmt_end:
	.asc	"[  END  ]", CR, 0

pmt_lsb:
	.asc	"00 ", 0

pmt_pid:
	.asc	"#$", 0

; ***** end of stuff *****
pmapEnd:				; ### for easy size computation ###
.)
