; Monitor-debugger-assembler shell for minimOS·16!
; v0.6rc3
; last modified 20200221-1441
; (c) 2016-2020 Carlos J. Santisteban

; ##### minimOS stuff but check macros.h for CMOS opcode compatibility #####

#ifndef		HEADERS
#ifdef			TESTING
; ** special include set to be assembled via... **
; xa -wM shell/miniMoDA16.s -I shell/ -DTESTING=1
#include "options.h"
#include "macros.h"
#include "abi.h"
user_ram = $400
.zero
#include "zeropage.h"
#else
; ** regular assembly **
#include "../usual.h"
#endif
; no specific header for this
.text
#endif

.as:.xs

.(
; *** uncomment for wide (80-char?) displays ***
#define	WIDE	_WIDE

; *** constant definitions ***
#define	BUFSIZ		80

; bytes per line in dumps 4 or 8/16
#ifdef	WIDE
#define		PERLINE		16
#else
#define		PERLINE		8
#endif

; ##### include minimOS headers and some other stuff #####
#ifndef	NOHEAD
	.dsb	$100*((* & $FF) <> 0) - (* & $FF), $FF	; page alignment!!! eeeeek
mmd_head:
; *** header identification ***
	BRK						; don't enter here! NUL marks beginning of header
	.asc	"mV"			; minimOS 65816 app!
	.asc	"****", 13		; some flags TBD
; *** filename and optional comment ***
title:
	.asc	"miniMoDA", 0	; file name (mandatory)
	.asc	"Monitor/Debugger/Assembler, "	; comments
	.asc	"65816 version", 0

; advance to end of header
	.dsb	mmd_head + $F8 - *, $FF	; for ready-to-blow ROM, advance to time/date field

; *** date & time in MS-DOS format at byte 248 ($F8) ***
	.word	$4DA0		; time, 9.45
	.word	$4E2F		; date, 2019/1/15

	mmdsize	=	mmd_end - mmd_head - 256	; compute size NOT including header!

; filesize in top 32 bits NOT including header, new 20161216
	.word	mmdsize		; filesize
	.word	0			; 64K space does not use upper 16-bit
#endif
; ##### end of minimOS executable header #####

; *** declare zeropage variables ***
; ##### uz is first available zeropage byte #####
	ptr		= uz		; PC & current 24b address pointer, would be filled by NMI/BRK handler
	_a		= ptr+3		; A register, these are 16-bit ready
	_x		= _a+2		; X register
	_y		= _x+2		; Y register
	_sp		= _y+2		; stack pointer, these are 16-bit too
	_dp		= _sp+2		; direct page register
; remaining registers are 8-bit only
	_dbr	= _dp+2		; data bank register
	_psr	= _dbr+1	; status register
	sflags	= _psr+1	; current status of M & X bits ***
	siz		= sflags+1	; number of bytes to copy or transfer ('n')
	lines	= siz+2		; lines to dump ('u')
	cursor	= lines+1	; storage for cursor offset, now on Y
	buffer	= cursor+1	; storage for direct input line (BUFSIZ chars)
	value	= buffer+BUFSIZ	; fetched values, now 24b ready
	oper	= value+3	; operand storage, now 24b ready
	temp	= oper+3	; temporary storage, also for indexes
	scan	= temp+1	; pointer to opcode list, size is architecture dependent!
	bufpt	= scan+3	; NEW pointer to variable buffer, scan is 24-bit, maybe this one too!
	count	= bufpt+3	; char count for screen formatting, also opcode count
	bytes	= count+1	; bytes per instruction
	iodev	= bytes+1	; standard I/O ##### minimOS specific #####

	__last	= iodev+1	; ##### just for easier size check #####

; *** initialise the monitor ***

; ##### minimOS specific stuff #####
; **apparently will not use B as all pointers are 24b now!

; standard minimOS initialisation
	LDA #__last-uz		; zeropage space needed
; check whether has enough zeropage space
#ifdef	SAFE
	CMP z_used			; check available zeropage space
	BCC go_da			; enough space
	BEQ go_da			; just enough!
		_ABORT(FULL)		; not enough memory otherwise (rare) new interface
go_da:
#endif
	STA z_used			; set needed ZP space as required by minimOS
	STZ w_rect			; no screen size required
	STZ w_rect+1		; neither MSB
	LDY #<title			; LSB of window title
	LDA #>title			; MSB of window title
	STY str_pt			; set parameter
	STA str_pt+1
	PHK					; get current bank for string...
	PLA					; ...into A...
	STA str_pt+2		; ...and set parameter
	_KERNEL(OPEN_W)		; ask for a character I/O device
	BCC open_da			; no errors
		_ABORT(NO_RSRC)		; abort otherwise! proper error code
open_da:
	STY iodev			; store device!!!
; ##### end of minimOS specific stuff #####

; splash message just shown once
	LDA #>splash		; address of splash message
	LDY #<splash
	JSR $FFFF &  prnStr			; print the string!

; *** store current stack pointer as it will be restored upon JSR/JMP ***
; hopefully the remaining registers will be stored by NMI/BRK handler, especially PC!
	LDA #%00110000		; 8-bit sizes eeeeeeeek
	STA _psr			; *** essential, at least while not previously set ***
	STA sflags			; also initial (dis)assembler status!
; first time will pick up DP & DBR values, not via get_sp eeeeeek
; might go 16-bit for this...
	PHD					; check direct page register
	PLY					; retrieve 16-bit value!
	PLX					; MSB too
	STY _dp				; store current value
	STX _dp+1
	PHB					; data bank register is 8-bit only, but worth doing here
	PLA					; get 8 bits only
	STA _dbr			; store current, no need to reset it!
; while a proper debugger interface is done, better preset ptr to a safe area
	LDX #>user_ram		; beginning of available ram, as defined... in rom.s
	LDY #<user_ram		; LSB misaligned?
	BEQ ptr_init		; nothing to align
		INX					; otherwise start at next page
ptr_init:
	STX ptr+1			; set MSB
	STZ ptr+2			; and bank!
	STZ ptr				; page aligned
; specially tailored code for 816-savvy version!
; this is the return point after a call!
get_sp:
	.xl: REP #$10		; *** 16-bit index ***
	TSX					; get current stack pointer
	STX _sp				; store original value
	.xs: .as: SEP #$30	; *** regular size ***
; these ought to be initialised after calling a routine!
	LDA #__last-uz		; zeropage space needed (again)
	STA z_used			; set needed ZP space as required by minimOS ####
; global variables
	LDA #16				; standard number of lines, bigger value
	STA lines			; set variable
	STA siz				; also default transfer size
	STZ siz+1			; clear copy/transfer size MSB

; *** begin things ***
main_loop:
		STZ cursor			; eeeeeeeeeek... but really needed?
; *** NEW variable buffer setting ***
		TDC					; get direct page pointer!
		LDY #<buffer		; *** assume D is page-aligned
		XBA					; now A holds MSB
		STY bufpt			; set new movable pointer
		STA bufpt+1
		STZ bufpt+2			; this is a 24b pointer from zeropage, thus always in bank zero
; put current address before prompt
		LDA ptr+2			; BANK goes first
		JSR $FFFF &  prnHex			; print it
		LDA ptr+1			; then MSB goes
		JSR $FFFF &  prnHex			; print it
		LDA ptr				; same for LSB
		JSR $FFFF &  prnHex
		LDA #'>'			; prompt character
		JSR $FFFF &  prnChar			; print it
		JSR $FFFF &  getLine			; input a line
; execute single command (or assemble opcode) from buffer
cli_loop:
		LDY #$FF			; getNextChar will advance it to zero!
		JSR $FFFF &  gnc_do			; get first character on string, without the variable
		TAX					; set status for A
			BEQ main_loop		; ignore blank lines!
		CMP #COLON			; end of instruction?
			BEQ cli_chk			; advance to next valid char
		CMP #CR				; ** newline is the same as colon **
			BEQ cli_chk
		CMP #'.'			; command introducer (not used nor accepted if monitor only)
			BNE not_mcmd		; not a monitor command
		JSR $FFFF &  gnc_do			; get into command byte otherwise
		CMP #'Z'+1			; past last command?
			BCS bad_cmd			; unrecognised
		SBC #'?'-1			; first available command (had borrow)
			BCC bad_cmd			; cannot be lower
		ASL					; times two to make it index
		TAX					; use as index
		JSR $FFFF &  call_mcmd		; call monitor command
		JSR $FFFF &  getNextChar		; should be done but check whether in direct mode
		BCC cmd_term		; no more commands in line (or directly to main loop?)
cli_chk:
			TYA					; otherwise advance pointer
			SEC					; set carry in case the BCC is skipped! eeeek
			ADC bufpt			; carry was set, so the colon/newline is skipped
			STA bufpt			; update pointer
			BCC cli_loop		; MSB OK means try another right now
				INC bufpt+1			; otherwise wrap!
; assembly from text might cross bank boundaries (sources over 64K)!
			BNE cli_loop		; try another if no crossing
				INC bufpt+2			; otherwise set 24b pointer
			BRA cli_loop		; and try another
cmd_term:
		BEQ main_loop		; no more on buffer, restore direct mode
	BNE bad_cmd			; otherwise has garbage! No need for BRA

; *** this entry point has to discard return address as will be issued as command ***
_unrecognised:
;bad_opr:
		PLA
		PLA
; *** standard entry point for syntax error (within monitor commands) ***
bad_cmd:
	LDA #>err_bad		; address of error message
	LDY #<err_bad
d_error:
	JSR $FFFF &  prnStr			; display error
		BRA main_loop		; restore

; ***** ASSEMBLER MODULE *****
not_mcmd:
; ** try to assemble the opcode! **
	STZ count			; reset opcode counter
	STZ bytes			; eeeeeeeeek
	LDY #<da_oclist-1	; get list address, notice trick
	LDA #>da_oclist-1
	STY scan			; store pointer from Y eeeeeeeeeeek
	STA scan+1
; to be bank-agnostic, should set this 24-bit pointer
	PHK					; current execution bank
	PLA					; get value
	STA scan+2			; and use it as opcode list bank pointer
; proceed normally, but 65816 must use long addressing for scan pointer
sc_in:
		DEC cursor			; every single option will do it anyway
		JSR $FFFF &  getListChar		; will return NEXT c in A and x as carry bit, notice trick above for first time!
; ...but C will be lost upon further comparisons!
; manage new 65816 operand formats
		JSR $FFFF & adrmodes			; check NEW addressing modes in list, return with standard marker in A
		CMP #CARET			; 24-bit addressing?
		BNE sc_nlong
; *** get a long-sized operand! ***
; no need to pick a word (BANK+MSB) first, then a byte!
			JSR $FFFF &  fetch_long		; get three bytes in a row
			BCC sc_long
				JMP sc_skip  & $FFFF				; no such operand eeeeeeeek
sc_long:
			LDY value			; get computed value
			LDA value+1
			STY oper			; store in safer place, no need to make room for LSB!
			STA oper+1
			LDA value+2			; third byte in a row
			STA oper+2
; report operand size
			INC bytes			; three operand bytes were detected
			INC bytes
			INC bytes
			JMP sc_adv & $FFFF			; continue decoding

; ** some room here for the overflow error handling! **
overflow:
		LDA #>err_ovf		; address of overflow message
		LDY #<err_ovf
		BRA d_error			; display and restore

; continue with classic operand formats (but add 16-bit relative!)
sc_nlong:
		CMP #'}'			; long relative?
		BNE sc_nrlong		; check also short relative
			LDX #2				; 16-bit relative
			BRA sc_relat		; continue unified relative processing
sc_nrlong:
		CMP #'%'			; relative addressing?
		BNE sc_nrel
			LDX #1				; 8-bit relative operand
; *** try to get a relative operand ***
; --- X will be loaded with 1 for short rel, 2 for long rel (BRL, PER)
sc_relat:
			JSR $FFFF &  fetch_value		; will pick up some bytes, as this is an address
			LDA temp			; how many chars?
				BEQ sc_skip			; no address, not OK
; --- at this point, (ptr)+X+1 is the address of next instruction (+2 or +3)
; --- should offset be zero, the branch will just arrive there
; --- (value) holds the desired address
; --- (value) minus that previously computed address is the proper offset
; --- alternatively, (ptr)+X - (value), then invert all bits!
			.al: REP #$20		; *** 16-bit memory ***
			TXA					; get operand size and clear MSB!
			CLC					; eeeeeek
			ADC ptr				; add base word
; note that I totally ignored bank!!! otherwise try something like this
			LDY ptr+2			; get base bank
			BCC sc_rbnk			; experimental bank address operation
				INY					; propagate carry
sc_rbnk:
; now Y holds the third byte of accumulator!
			SEC					; now for the subtraction
			SBC value			; one's complement of result!
; extra code if bank boundary check is needed
			PHA					; save this poorly
			TYA					; operate on third byte
			SBC value+2			; continue long subtraction propagating carry
			EOR #$FF			; this needs to be inverted for two's complement!
			STA oper+2			; keep high result... will destroy temp
			PLA					; one's complement is ready!
; standard code, no matter if banks were checked
			EOR #$FFFF			; the actual 16-bit offset
; will poke offset first, then check bounds
			STA oper			; storage at standard location (could be 8 or 16-bit)
; --- overflow should be checked properly, as will be computed in 16-bit mode (24, actually)
; --- how to check bounds then? same sign on MSB & LSB! (make that 3rd/2nd byte on 16-bit size)
; --- but MSB (aka 3rd byte) can ONLY be 0 or $FF!
; X holds MSB offset, could be used as index
			.as: SEP #$20		; *** back to 8-bit mode ***
			LDA oper, X			; get value and sign of MSB!!!
			BMI srel_back		; was backwards
					BNE overflow		; extra byte on forward branches must be zero!
				LDA oper-1, X		; check LSB sign (must be plus)
					BMI overflow		; no way
				BRA srel_done
srel_back:
			CMP #$FF			; only valid extra byte on backwards branches!
				BNE overflow
			LDA oper-1, X		; check LSB sign (this time must be minus)
				BPL overflow		; no way
; common ending for all relative modes
srel_done:
			TXA					; detect operand bytes! 1 or 2
			CLC
			ADC bytes			; count them
			STA bytes			; and update value
			BRA sc_adv			; continue decoding
sc_nrel:
		CMP #'@'			; single byte operand?
		BNE sc_nsbyt
; *** try to get a single byte operand ***
; this needs to check for MVN/MVP woth double operand!!!
; new generic approach, what was I thinking!
			JSR $FFFF &  fetch_byte		; currently it is a single byte...
				BCS sc_skip			; could not get operand eeeeeeeek
			LDX bytes			; operands detected this far
			STA oper, X			; will poke it where appropriated!
			INC bytes			; one operand was detected
			BRA sc_adv			; continue decoding
sc_nsbyt:
		CMP #'&'			; word-sized operand? hope it is OK
		BNE sc_nwrd
; *** try to get a word-sized operand ***
			JSR $FFFF &  fetch_word		; will pick up a couple of bytes
				BCS sc_skip			; not if no number found eeeeeeeek
			LDY value			; get computed value
			LDA value+1
			STY oper			; store in safer place, endianness was ok
			STA oper+1
			INC bytes			; two operands were detected
			INC bytes
			BRA sc_adv			; continue decoding
sc_nwrd:
; regular char in list, compare with input
		STA temp			; store list contents eeeeeeeek!
		JSR $FFFF &  getNextChar		; reload char from buffer eeeeeeeek^2
		CMP temp			; list coincides with input?
		BEQ sc_adv			; if so, continue scanning input
sc_skip:
			LDY #$FF			; otherwise seek end of current opcode
sc_seek:
				INY					; advance in list (optimised)
				LDA [scan], Y		; look at opcode list, 24b
				BPL sc_seek			; until the end
			TYA					; get offset
			CLC					; stay at the end
			ADC scan			; add to current pointer
			STA scan			; update LSB
			BCC no_match		; and try another opcode
				INC scan+1			; in case of page crossing
			BNE no_match		; there was no bank crossing either! probably not needed
				INC scan+2			; otherwise proceed as expected
no_match:
			STZ cursor			; back to beginning of instruction
			STZ bytes			; also no operands detected! eeeeek
			INC count			; try next opcode
			BEQ bad_opc			; no more to try!
				JMP $FFFF &  sc_in			; there is another opcode to try
bad_opc:
			LDA #>err_opc		; address of wrong opcode message
			LDY #<err_opc
			JMP $FFFF &  d_error			; display and restore
sc_adv:
		JSR $FFFF &  getNextChar		; get another valid char, in case it has ended
		TAX					; check A flags... X will not last!
		BNE sc_nterm		; if end of buffer, sentence ends too
			SEC					; just like a colon, instruction ended
sc_nterm:
		XBA					; store old A value into the other accumulator!
		LDA [scan]			; what is being pointed in list? 24b
		BPL sc_rem			; opcode not complete
			BCS valid_oc		; both opcode and instruction ended
			BRA no_match		; only opcode complete, keep trying! eeeeek
sc_rem:
		BCS sc_skip			; instruction is shorter, usually non-indexed indirect eeeeeeek^3
		JMP $FFFF &  sc_in			; neither opcode nor instruction ended, continue matching
valid_oc:
; opcode successfully recognised, let us poke it in memory
		LDY bytes			; set pointer to last argument
		TYX					; to be 816-savvy...
		BEQ poke_opc		; no operands
poke_loop:
			LDA oper-1, X		; get argument, note trick, 816-savvy
			STA [ptr], Y		; store in RAM *** check out bank!
			DEY					; next byte
			DEX
			BNE poke_loop		; could start on zero
poke_opc:
		LDA count			; matching opcode as computed
		STA [ptr]			; poke it without offset
; should check here for REP/SEP in order to update status flags...
; ..but since we have a command for that, this code is no longer needed!
; enable this if deemed necessary
;		LDX oper			; get operand just in case
;		JSR sflag_chk  & $FFFF		; possible flag update!
; now it is time to print the opcode and hex dump! make sure 'bytes' is preserved!!!
; **** to do above ****
; advance pointer and continue execution
		LDA bytes			; add number of operands...
		SEC					; ...plus opcode itself...
		ADC ptr				; ...to current address
		STA ptr				; update LSB
		BCC main_nw			; check for wrap
			INC ptr+1			; in case of page crossing
main_nw:
		BNE main_nbb		; check for bank boundary
			INC ptr+2			; in case of bank crossing
main_nbb:
		XBA					; what was NEXT in buffer, X was NOT respected eeeeeeek^4
		BNE main_nnul		; termination will return to exterior main loop
			JMP $FFFF &  main_loop		; and continue forever
main_nnul:
		LDY cursor			; eeeeeeeeek
		JMP $FFFF &  cli_chk			; otherwise continue parsing line eeeeeeeeeek
; *** this is the end of main loop ***

; *** call command routine ***
call_mcmd:
	JMP (cmd_ptr & $FFFF, X)	; indexed jump macro, bank agnostic!

; ****************************************************
; *** command routines, named as per pointer table ***
; ****************************************************

; ** .? = show commands **
help:
	LDA #>help_str		; help string
	LDY #<help_str
	JMP $FFFF &  prnStr			; print it, and return to main loop


; ** .@ = set Data Bank register *
set_DBR:
	JSR $FFFF &  fetch_byte		; get operand in A
; no need to complain if zero, pretty reasonable
	STA _dbr			; set register
	RTS


; ** .A = set accumulator **
set_A:
	JSR $FFFF &  fetch_value		; get operand
	LDA value			; needs to pick LSB!
	LDX value+1			; pick MSB up
	STA _a				; set 16b accumulator
	STX _a+1
	RTS


; ** .B = store byte **
store_byte:
	JSR $FFFF &  fetch_byte		; get operand in A
	STA [ptr]			; set byte in memory *** check bank
	.al: REP #$20		; *** 16-bit memory ***
	INC ptr				; advance pointer (+MSB)
	.as: SEP #$20		; *** back to 8-bit ***
	BNE sb_end			; all done if no BANK wrap
		INC ptr+2			; increase K otherwise
sb_end:
	RTS


; ** .C = call address **
call_address:
	JSR $FFFF &  fetch_value		; get operand address
	LDA temp			; was it able to pick at least one hex char?
	BNE ca_ok		; do not jump to zero!
;		JMP bad_opr
		JMP $FFFF &  _unrecognised	; reject zero loudly
ca_ok:
; setting SP upon call makes little sense...
	LDA iodev			; *** must push default device for later ***
	PHA
	PHD					; ** needs to push DP or might be lost! **
	JSR @do_call		; *** actually JSL, must end in RTL!!! ***
	PHP					; get current status BEFORE switching sizes!
	.xl: .al: REP #$38	; *** store full size registers AND clear decimal, just in case ***
	PHA					; need to save this first in order to get DP deep from the stack!!!
	PHD					; this is the value of DP upon exit!!!
; ** first of all, try to restore original DP!!! **
	LDA 6, S			; depth of orginally stored DP, new offset
	TCD					; now it is safe for zeropage accesses!
	PLA					; get 'current' DP value, now that it can be saved!
	STA _dp				; can store this right now
	PLA					; retrieve A value upon return
; ** should record actual registers here **
	STA _a
	STX _x
	STY _y
	.xs: .as: SEP #$30	; *** back to standard size ***
	PHB					; ...and actual DBR
	PLA
	STA _dbr			; this is an 8-bit value
	PLA					; this was previous PSR, A was already saved
	STA _psr
; ** needs to discard deeply stored DP **
	PLA					; discard a 16-bit value over stored iodev
	PLA
; hopefully no stack imbalance was caused, otherwise will not resume monitor!
	PLA					; this (eeeeek) will take previously saved default device
	STA iodev			; store device!!!
	PLA					; must discard previous return address, as will reinitialise stuff!
	PLA
	JMP $FFFF &  get_sp			; hopefully context is OK, will restore as needed


; ** .J = jump to an address **
jump_address:
	JSR $FFFF &  fetch_value		; get operand address
	LDA temp			; was it able to pick at least one hex char?
	BNE jm_ok
;		JMP bad_opr
		JMP $FFFF &  _unrecognised	; reject zero loudly
jm_ok:
; restore stack pointer...
	.xl: REP #$10		; *** essential 16-bit index ***
	LDX _sp				; get stored value (word)
	TXS					; set new pointer...
; SP restored
; restore registers and jump
do_call:
	LDA _psr			; status is different
	PHA					; will be set via PLP
	LDA _dbr			; preset B
	PHA					; push it for a moment...
	PLB					; ...as will be set now
	.xl: .al: REP #$30	; *** set registers in full size ***
	LDA _dp				; ** get 16-bit value **
	PHA					; ** into stack to be taken later **
	LDX _x				; retrieve registers
	LDY _y
	LDA _a				; lastly retrieve accumulator
	PLD					; ** must set DP after all readings **
.as:.xs					; most likely values... needed for the remaining code!
	PLP					; restore status
	JMP [value]			; eeeeeeeeek


; ** .D = disassemble 'u' lines **
disassemble:
	JSR $FFFF &  fetch_value		; get address
; ignoring operand error...
	LDY value			; save value elsewhere
	LDA value+1
	LDX value+2
	STY oper
	STA oper+1
	STX oper+2			; 24b addresses
	LDX lines			; get counter
das_l:
		PHX					; save counters
; time to show the opcode and trailing spaces until 20* chars
		JSR $FFFF &  disOpcode		; dissassemble one opcode @oper (will print it)
		PLX					; retrieve counter
		DEX					; one line less
		BNE das_l			; continue until done
	RTS

; disassemble one opcode and print it
disOpcode:
	LDA [oper]			; check pointed opcode
	STA count			; keep for comparisons
	LDY #<da_oclist		; get address of opcode list
	LDA #>da_oclist
	STZ scan			; indirect-indexed pointer
	STA scan+1
; to be bank-agnostic, should set this 24-bit pointer
	PHK					; current execution bank
	PLA					; get value
	STA scan+2			; and use it as opcode list bank pointer
; proceed normally, but 65816 must use long addressing for scan pointer
	LDX #0				; counter of skipped opcodes
do_chkopc:
		CPX count			; check if desired opcode already pointed
			BEQ do_found		; no more to skip
do_skip:
			LDA [scan], Y		; get char in list, 24b
			BMI do_other		; found end-of-opcode mark (bit 7)
			INY
			BNE do_skip			; next char in list if not crossed
				INC scan+1			; otherwise correct MSB
;			BNE do_skip			; if bank boundary was crossed... (probably NOT needed)
;				INC scan+2			; ...correct 24b pointer
			BRA do_skip
do_other:
		INY					; needs to point to actual opcode, not previous end eeeeeek!
		BNE do_set			; if not crossed
			INC scan+1			; otherwise correct MSB
;		BNE do_set			; if bank boundary was crossed... (probably NOT needed)
;			INC scan+2			; ...correct 24b pointer
do_set:
		INX					; yet another opcode skipped
		BNE do_chkopc		; until list is done ***should not arrive here***
do_found:
	STY scan			; restore pointer
; this is a fully defined opcode, when symbolic assembler is available!
;	JMP $FFFF &  prnOpcode		; show all and return

; decode opcode and print hex dump
prnOpcode:
; first goes the current address in label style
	LDA #'_'			; make it self-hosting
	JSR $FFFF &  prnChar
; lighter 24b printing loop
	LDX #3				; number of bytes of a 24b address
po_adlab:
		LDA oper-1, X		; one address byte, note offset
		PHX					; keep index
		JSR $FFFF &  prnHex			; print it
		PLX					; restore index
		DEX					; next byte
		BNE po_adlab
	LDA #COLON			; code of the colon character
	JSR $FFFF &  prnChar
	LDA #' '			; leading space, might use string
	JSR $FFFF &  prnChar
; then extract the opcode string from scan
	LDY #0				; scan increase, temporarily stored in temp
	STY bytes			; number of bytes to be dumped (-1)
	STY count			; printed chars for proper formatting
	STY value+1			; for double operand MVN/MVP
po_loop:
		LDA [scan], Y		; get char in opcode list, 24b
		STY temp			; keep index as will be destroyed
		AND #$7F			; filter out possible end mark
; *** check special flag-dependent markers ***
		JSR $FFFF & adrmodes		; in case a flag-dependent size is found
; continue with regular markers (but include lond relative addressing)
		CMP #'*'			; LONG relative operand
		BNE po_nlrel		; not quite, check for 8-bit relative
			PER po_16rel-1		; push corrected address of specific 16-bit ending
			BRA po_xrel			; common processing code
po_nlrel:
		CMP #'%'			; relative addressing
		BNE po_nrel			; no longer the same as single byte!
; put here specific code for 8-bit relative arguments!
			PER po_8rel-1		; push corrected address
; generic relative operand management
po_xrel:
			LDA #'$'			; hex radix
			JSR $FFFF &  prnChar
			LDX #0				; reset offset sign extention
			LDY bytes			; retrieve instruction index
			INY					; point to operand!
; Y is offset pointing to operand (LSB), still unknown if will read a byte or a word from it
			RTS					; will actually JUMP to specific routine!!!
; specific part for 8-bit relative operands
po_8rel:
			LDA [oper], Y		; get offset byte!
			STY bytes			; correct index, generic is OK???
			BPL po_fwd8			; forward jump does not extend sign
				DEX					; puts $FF otherwise
po_fwd8:
			XBA					; switch to MSB
			TXA					; store extention
			XBA					; 16-bit offset!
			.al: REP #$20		; *** 16-bit memory ***
			SEC					; plus opcode...
			INC					; ...and displacement...
				BRA po_xtnd			; proceed with sign properly extended
; specific part for 16-bit relative operands
po_16rel:
			.al: REP #$20		; *** 16-bit accumulator ***
			LDA [oper], Y		; get offset WORD!
			BPL po_fwd16		; forward jump does not extend sign
				DEX					; puts $FF otherwise
po_fwd16:
			INY					; skip another byte?
			STY bytes			; correct index, generic is OK???
			SEC					; plus opcode...
			INC					; ...and displacement...
			INC
; common ending for 8 & 16 bit relative operands
po_xtnd:
			ADC oper			; ...from current position
			XBA					; notice trick...
			PHA					; ...will push LSB first!!!
			.as: SEP #$20		; *** back to 8-bit ***
			TXA					; another extention
			ADC oper+2			; also with bank address
; will arrive with bank in A, and in stack previously pushed LSB, then MSB
			JSR $FFFF &  prnHex			; show as two ciphers, initially BANK
			PLA					; previously computed MSB!
			JSR $FFFF &  prnHex			; another two
			PLA					; previously computed LSB!
			JSR $FFFF &  prnHex			; and another two
; opcode showing done, signal character count and proceed with hex dump
			LDA #7				; five more chars
			BRA po_done			; update and continue
po_nrel:
		CMP #'@'			; single byte operand
		BNE po_nbyt			; otherwise check word-sized operand
; *** unified 1, 2 and 3-byte operand management ***
			LDY #1				; number of bytes minus one
			LDX #3				; number of chars to add
			BRA po_disp			; display value
po_nbyt:
		CMP #'&'			; word operand
		BNE po_nwd			; otherwise check new long operand
			LDY #2				; number of bytes minus one
			LDX #5				; number of chars to add
			BRA po_disp			; display value
po_nwd:
		CMP #'='			; long operand
		BNE po_nlong		; otherwise regular char
			LDY #3				; number of bytes minus one
			LDX #7				; number of chars to add
po_disp:
; could check also for undefined references!!!
			PHX					; save values
			PHY
			STY bytes			; set counter
			LDA #'$'			; hex radix
			JSR $FFFF &  prnChar
			LDY bytes			; retrieve original value eeeeeeeeeek
			LDX value+1			; check for double-operand opcodes
			BEQ po_dloop		; proceed normally if first or only
				INY					; or point to second one otherwise!
po_dloop:
				PHY					; save current index!
				LDA [oper], Y		; get whatever byte
				JSR $FFFF &  prnHex			; show in hex
				PLY					; restore index
				DEY					; might go into LSB, or end
				DEC bytes			; go back one byte
				BNE po_dloop
			INC value+1			; operand count
			BRA po_adv			; update count and continue
po_nlong:
		JSR $FFFF &  prnChar			; just print it
		INC count			; yet another char
			BRA po_char			; eeeeeeeeek but why was it BNE?
po_adv:
		PLY					; restore original operand size
		STY bytes
		PLA					; number of chars to add
po_done:
		CLC
		ADC count			; add to previous value
		STA count			; update value
po_char:
		LDY temp			; get scan index
		LDA [scan], Y		; get current char again, 24b
			BMI po_end			; opcode ended, no more to show
		INY					; go for next char otherwise
		JMP $FFFF &  po_loop			; BNE would work as no opcode string near 256 bytes long, but too far...
po_end:
; add spaces until 23 chars!
		LDA #14				; number of chars after the initial 9
		CMP count			; already done?
	BCC po_dump			; go for dump then, even if over
		LDA #' '			; otherwise print a space
		JSR $FFFF &  prnChar
		INC count			; eeeeeeeeeeeek
		BNE po_end			; until complete, again no need for BRA
po_dump:
; print hex dump, ** but check for MVP/MVN extra operands first **
	LDX value+1			; was it a move instruction?
	CPX #2				; *** special operand count ***
	BNE po_dnmv			; nope, nothing to correct
		INC bytes			; otherwise there is one more operand
po_dnmv:
; ** check also if a REP/SEP was issued ** makes sense as no source directives to be found!
	LDY #1				; byte operand offset
	LDA [oper], Y		; get operand...
	TAX					; ...in X
	LDA [oper]			; and opcode in A
	JSR $FFFF &  sflag_chk		; check if sflags are to be updated
; now print hex dump as a comment!
	LDA #';'			; semicolon as comment introducer
	JSR $FFFF &  prnChar
	LDY #0				; reset index
	STY temp			; save index (no longer scan)
po_dbyt:
		LDA #' '			; leading space
		JSR $FFFF &  prnChar
		LDY temp			; retrieve index
		LDA [oper], Y		; get current byte in instruction
		JSR $FFFF &  prnHex			; show as hex
		INC temp			; next
		LDX bytes			; get limit (-1)
		INX					; correct for post-increased
		CPX temp			; compare current count
		BNE po_dbyt			; loop until done
; skip all bytes and point to next opcode
	LDA oper			; address LSB
	SEC					; skip current opcode...
	ADC bytes			; ...plus number of operands
	STA oper
	BCC po_nowr			; in case of page crossing
		INC oper+1
po_nowr:
	BNE po_cr			; in case of bank boundary crossing
		INC oper+2
po_cr:
	LDA #CR				; final newline
	JMP $FFFF &  prnChar			; print it and return


; ** .E = examine 'u' lines of memory **
examine:
	JSR $FFFF &  fetch_value		; get address
; ignoring operand error...
	LDY value			; save value elsewhere
	LDA value+1
	LDX value+2
	STY oper
	STA oper+1
	STX oper+2
	LDX lines			; get counter
ex_l:
		PHX					; save counters
		LDA oper+2			; address BANK
		JSR $FFFF &  prnHex			; print it
		LDA oper+1			; address MSB
		JSR $FFFF &  prnHex			; print it
		LDA oper			; same for LSB
		JSR $FFFF &  prnHex
		LDA #>dump_in		; address of separator
		LDY #<dump_in
		JSR $FFFF &  prnStr			; print it
		; loop for 8/16 hex bytes
		LDY #0				; reset offset
ex_h:
			PHY					; save offset
			BEQ ex_ns			; no space if the first one
				PHY					; please keep Y!
				LDA #' '			; print space
				JSR $FFFF &  prnChar
				PLY					; retrieve Y!
ex_ns:
			LDA [oper], Y		; get byte
			JSR $FFFF &  prnHex			; print it in hex
			PLY					; retrieve index
			INY					; next byte
			CPY #PERLINE		; bytes per line (8 if not wide)
			BNE ex_h			; continue line
		LDA #>dump_out		; address of separator
		LDY #<dump_out
		JSR $FFFF &  prnStr			; print it
		; loop for 8/16 ASCII
		LDY #0				; reset offset
ex_a:
			PHY					; save offset BEFORE!
			LDA [oper], Y		; get byte
			CMP #127			; check whether printable
				BCS ex_np
			CMP #' '
				BCC ex_np
			BRA ex_pr			; it is printable
ex_np:
				LDA #'.'			; substitute
ex_pr:		JSR $FFFF &  prnChar			; print it
			PLY					; retrieve index
			INY					; next byte
			CPY #PERLINE		; bytes per line
			BNE ex_a			; continue line
		JSR $FFFF &  po_cr			; print GENERIC newline
		LDA oper			; get pointer LSB
		CLC
		ADC #PERLINE		; add shown bytes
		STA oper			; update pointer
		BCC ex_npb			; skip if within same page
			INC oper+1			; next page
ex_npb:
		PLX					; retrieve counter!!!!
		DEX					; one line less
		BNE ex_l			; continue until done
	RTS


; ** .F = invoke text editor? ***
; ***** TO DO ****** TO DO ******


; ** .G = set stack pointer **
set_SP:
	JSR $FFFF &  fetch_word		; get 16b operand
	STA _sp				; set stack pointer
	LDA value+1			; MSB too!
	STA _sp+1
	RTS


; ** .H = RESERVED ***
; ***** TO DO ****** TO DO ******


; ** .I = show symbol table ***
; ***** TO DO ****** TO DO ******


; ** .K = keep (load or save) **
; ### highly system dependent ###
; placeholder will send/read raw data to/from indicated I/O device
ext_bytes:
	JSR $FFFF &  getNextChar		; check for subcommand
	BCC ex_noni			; no need to ask user
; might turn into interactive mode here
		RTS					; fail silently
ex_noni:
; subcommand is OK, let us check target device ###placeholder
	STA count			; first save the subcommand!
	JSR $FFFF &  fetch_byte		; read desired device
		BCS ex_abort		; could not get it
	STA temp			; set as I/O channel
	LDA siz				; get desired transfer size
	LDX siz+1
	STA oper			; store temporarily
	STX oper+1
	LDY #0				; reset counter!
; decide what to do
	LDA count			; restore subcommand
	CMP #'-'			; is it save? (MARATHON MAN)
		BEQ ex_save			; OK to continue
	CMP #'+'			; load otherwise?
		BEQ ex_load			; OK then
ex_abort:
	JMP $FFFF &  _unrecognised	; else I do not know what to do
ex_save:
; save raw bytes
		LDA [ptr], Y		; get source data
		STA io_c			; set parameter
		PHY					; save index
		LDY temp			; get target device
		_KERNEL(COUT)		; send raw byte!
		PLY					; restore index eeeeeeeeeek
			BCS ex_err			; aborted!
		INY					; go for next
		BNE esl_nw			; no wrap
			INC ptr+1
		BNE esl_nw			; no bank boundary
			INC ptr+2
esl_nw:
		.al: REP #$20		; *** worth 16-bit ***
		DEC oper			; one less to go
		.as: SEP #$20		; *** OK here? ***
		BNE ex_save			; continue until done
	BRA ex_ok			; done!
ex_load:
; load raw bytes
		PHY					; save index
		LDY temp			; get target device
		_KERNEL(CIN)		; get raw byte!
		PLY					; restore index
			BCS ex_err			; aborted!
		LDA io_c			; get parameter
		STA [ptr], Y		; write destination data
		INY					; go for next
		BNE ell_nw			; no wrap
			INC ptr+1
		BNE ell_nw			; no bank boundary
			INC ptr+2
ell_nw:
		.al: REP #$20		; *** worth 16-bit ***
		DEC oper			; one less to go
		.as: SEP #$20		; *** OK here? ***
		BNE ex_load			; continue until done
	BRA ex_ok			; done!
ex_err:
; an I/O error occurred during transfer!
	LDA #>io_err		; set message pointer
	LDY #<io_err
	JSR $FFFF &  prnStr			; print it and finish function
ex_ok:
; transfer ended, show results
	LDA #'$'			; print hex radix
	JSR $FFFF &  prnChar
	.al: REP #$20		; *** 16-bit for a moment ***
	LDA siz				; desired size...
	SEC
	SBC oper			; ...minus remaining bytes...
	STA value			; ...are the actually transferred bytes!
	.as: SEP #$20		; *** back to 8-bit ***
	LDA value+1			; get MSB
	JSR $FFFF &  prnHex			; and show it in hex
	LDA value			; same for LSB
	JSR $FFFF &  prnHex
	LDA #>ex_trok		; get pointer to string
	LDY #<ex_trok
	JMP $FFFF &  prnStr			; and print it! eeeeeek return also


; ** .L = set register sizes *** new
set_siz:
; prepare bit mask
	LDA #$22			; preset mask for M bit... plus C sentinel!
	STA temp			; mask storage
; loop for trying to get a char for setting/resetting the bit
ss_cmd:
		JSR $FFFF &  getNextChar		; is there an extra character?
			BCS ss_exit			; end of command, no more to do
		TAX					; check whether end of buffer
			BEQ ss_exit			; ibidem
; check required size change, first for M, then for X
		CMP #'+'			; asking for 16-bit size?
		BNE ss_notw
			LDA temp			; mask for corresponding bit
			EOR #$FF			; inverted! could use $30 as well
			AND sflags			; remove bit...
			BRA ss_next			; in case another bit remains
ss_notw:
		CMP #'-'			; asking for 18-bit size?
		BNE ss_not8
			LDA temp			; mask for corresponding bit
			AND #$30			; remove sentinel bit for security!
			ORA sflags			; set bit...
;			BRA ss_next
ss_not8:
; if not '+' neither '-', we may safely assume it will not change that size, will not check for '='
; ...or complain if we are very picky!
ss_next:
		STA sflags			; ...and finally update flags
		LSR temp			; next bit
		BCC ss_cmd			; one bit still remains
ss_exit:
	RTS


; ** .M = move (copy) 'n' bytes of memory **
move:
	JSR $FFFF &  fetch_value		; get operand address
	LDA temp			; at least one?
	BNE mv_ok
;		JMP bad_opr
		JMP $FFFF &  _unrecognised	; reject zero loudly
mv_ok:
; destination address is now @value.l
	.al: REP #$20		; *** 16-bit memory, for now ***
	LDA ptr			; this is the origin address (minus bank)
	CMP value			; compare against destination
	BCS mv_up			; avoid overwriting!
		LDY #$44			; otherwise get MVP opcode!
		BRA mv_smc			; poke all that
mv_up:
		LDY #$54			; opcode for MVN
mv_smc:
	STY locals			; supposedly safe place for self-modifying code
	LDX ptr+2			; origin bank
	STX locals+1
	LDX value+2			; destination bank
	STX locals+2
	LDX #$6B			; opcode for RTL
	STX locals+3			; place it
	.xl: REP #$10		; *** now use 16-bit indexes too ***
	CPY #$54			; check opcode again (16-bit)
	BEQ mv_n			; was MVN, do not recompute indexes
		CLC					; A had the origin address...
		ADC siz				; ...plus size...
		DEC					; ...and convert it to last address in block!
		TAX					; this is origin
		LDA value			; now get destination address...
		CLC
		ADC siz				; ...plus size...
		DEC					; ...and convert it to last address in block!
		TAY					; this is destination
	BRA mv_do			; go for it
mv_n:
		TAX					; source address, unmodified
		LDY value			; destination address
mv_do:
	LDA siz				; get total size...
	DEC					; ...minus one
	JSR @locals			; execute! JSL, alas...
	.as: .xs: SEP #$30	; *** regular sizes ***
	RTS


; ** .N = set 'n' value **
set_count:
	JSR $FFFF &  fetch_value		; get operand
	LDA value			; check preset value
	ORA value+1			; was it zero?
	BEQ nn_end			; quietly abort operation
		LDY value			; copy LSB
		LDA value+1			; and MSB
		STY siz				; into destination variable
		STA siz+1			; only 16b are taken
nn_end:
	LDA #'N'			; let us print some message
	JSR $FFFF &  prnChar		; print variable name
	LDA #>set_str		; pointer to rest of message
	LDY #<set_str
	JSR $FFFF &  prnStr			; print that
	LDA siz+1			; check current or updated value MSB
	JSR $FFFF &  prnHex			; show in hex
	LDA siz				; same for LSB
	JSR $FFFF &  prnHex			; show in hex
	JMP $FFFF &  po_cr			; print trailing newline and return!


; ** .O = set origin **
origin:
	JSR $FFFF &  fetch_value		; get up to 3 bytes, unchecked
; ignore error as will show up in prompt
	LDY value			; copy LSB
	LDA value+1			; and MSB
	LDX value+2			; and BANK!!!
	STY ptr				; into destination variable
	STA ptr+1
	STX ptr+2
	RTS


; ** .P = set status register **
set_PSR:
	JSR $FFFF &  fetch_byte		; get operand in A
	STA _psr			; set status
	RTS


; ** .Q = standard quit **
quit:
; will not check any pending issues
	PLA					; discard main loop return address
	PLA
	_FINISH				; exit to minimOS, proper error code, new interface


; ** .R = reboot or shutdown **
reboot:
; might try to get an extra char for non-interactive function selection
	JSR $FFFF &  getNextChar		; is there an extra character?
		BCS rb_ask			; end of sentence, needs to ask user!
	TAX					; check whether end of buffer
		BNE rb_cmd			; no need to ask!
rb_ask:
	LDA #>shut_str		; asking string
	LDY #<shut_str
	JSR $FFFF &  prnStr			; print it
; ### minimOS specific non-locking key check ###
rb_chk:
		LDY iodev			; get device
		_KERNEL(CIN)		; get char ##### minimOS #####
			BCC rb_key			; char is available
		CPY #EMPTY			; still waiting for a key?
		BEQ rb_chk
	RTS					; fail quietly in case of I/O error...
rb_key:
	LDA io_c			; get pressed key ### minimOS ###
	AND #%11011111		; as uppercase
rb_cmd:
	CMP #'W'			; asking for warm boot?
	BNE rb_notw
		LDY #PW_WARM		; warm boot request ## minimOS specific ##
		BRA fw_shut			; call firmware
rb_notw:
	CMP #'C'			; asking for cold boot?
	BNE rb_notc
		LDY #PW_COLD		; cold boot request ## minimOS specific ##
		BRA fw_shut			; call firmware
rb_notc:
	CMP #'S'			; asking for shutdown?
	BNE rb_exit			; otherwise abort quietly
		LDY #PW_OFF			; poweroff request ## minimOS specific ##
fw_shut:
		_KERNEL(SHUTDOWN)	; unified firmware call
rb_exit:
	RTS					; needs to return and wait for the complete shutdown!


; ** .S = store raw string **
store_str:
	LDY cursor			; allows NMOS macro!
sst_loop:
		INY					; skip the S and increase
		LDA [bufpt], Y		; get raw character
		STA [ptr]			; store in place
			BEQ sstr_end		; until terminator, will be stored anyway
		CMP #CR				; newline also accepted, just in case
			BEQ sstr_cr			; terminate and exit
		CMP #COLON			; that marks end of sentence, thus not accepted in string!
			BEQ sstr_cr
		CMP #';'			; comments neither included
			BEQ sstr_com		; skip until colon, newline or nul
		INC ptr				; advance destination
		BNE sst_loop		; boundary not crossed
	INC ptr+1			; next page otherwise
	BRA sst_loop		; continue, might use BNE
sstr_com:
	LDA #0				; no STZ indirect
	STA [ptr]			; terminate string in memory Eeeeeeeeek
sstr_cloop:
		INY					; advance
		LDA [bufpt], Y		; check whatever
			BEQ sstr_end		; terminator ends
		CMP #CR				; newline ends too
			BEQ sstr_end
		CMP #COLON			; and also does colon
			BEQ sstr_end
		BNE sstr_cloop		; otherwise continue discarding, no need for BRA
sstr_cr:
	LDA #0				; no STZ indirect
	STA [ptr]			; terminate string in memory Eeeeeeeeek
sstr_end:
	DEY					; will call getNextChar afterwards eeeeeeeeek
	STY cursor			; update optimised index!
	RTS


; ** .T = assemble from source **
asm_source:
	PLA					; discard return address as will jump inside cli_loop
	PLA
	JSR $FFFF &  fetch_value		; get desired address
	LDA temp			; at least one?
	BNE ta_ok
;		JMP bad_opr
		JMP $FFFF &  _unrecognised	; reject zero loudly
ta_ok:
	LDY value			; fetch result
	LDA value+1
	LDX value+2
	STY bufpt			; this will be new buffer
	STA bufpt+1
	STX bufpt+2
	JMP $FFFF &  cli_loop		; execute as commands!


; ** .U = set 'u' number of lines/instructions **
; might replace this for an autoscroll feature
set_lines:
	JSR $FFFF &  fetch_byte		; get operand in A
	TAX					; anything set?
	BEQ sl_show			; fail quietly if zero
		STA lines			; set number of lines
sl_show:
	LDA #'U'			; let us print some message
	JSR $FFFF &  prnChar		; print variable name
	LDA #>set_str		; pointer to rest of message
	LDY #<set_str
	JSR $FFFF &  prnStr			; print that
	LDA lines			; check current or updated value
	JSR $FFFF &  prnHex			; show in hex
	JMP $FFFF &  po_cr			; print trailing newline and return!


; ** .V = view register values **
view_regs:
	LDA #>regs_head		; print header
	LDY #<regs_head
	JSR $FFFF &  prnStr
; since _pc and ptr are the same, no need to print it!
	LDX #0				; reset counter
vr_l:
		PHX					; save index!
		LDA _a+1, X			; get MSB value from regs
		JSR $FFFF &  prnHex			; show value in hex
		PLX
vr_l8:
		PHX
		LDA _a, X			; get LSB value from regs
		JSR $FFFF &  prnHex			; show value in hex
		LDA #' '			; space
		JSR $FFFF &  prnChar			; print it
		PLX					; restore index
		INX					; next reg, note they are 16b
		INX
		CPX #10				; all 16-bit regs done?
		BCC vr_l			; continue otherwise
		BEQ vr_l8			; ...or print last 8-bit reg
	LDX #8				; number of bits
	STX value			; temp counter
	LDA _psr			; copy original value
	STA value+1			; temp storage
vr_sb:
		ASL value+1			; get highest bit
		LDA #' '			; default is off (space)
		BCC vr_off			; was off
			INC					; otherwise turns into '!'
vr_off:
		JSR $FFFF &  prnChar			; prints bit
		DEC value			; one less
		BNE vr_sb			; until done
	JMP $FFFF &  po_cr	; print trailing newline and return!


; ** .W = store word **
store_word:
	JSR $FFFF &  fetch_value		; get operand, do not force 3-4 hex chars
; 8-bit code minus RTS was 16/20b, 29-33/32-40
; 16-bit code is 12/16b, 30/33-37t
	.al: REP #$20		; *** worth going 16-bit memory ***
	LDA value			; get 16b word
	STA [ptr]			; store in full eeeeeeeeeek
	INC ptr				; advance two bytes!
	INC ptr				; MSB will be OK anyway
	.as: SEP #$20		; *** back to 8-bit ***
;	BNE sw_nw			; any bank boundary?
;		INC ptr+2			; wrap it
	RTS


; ** .X = set X register **
set_X:
	JSR $FFFF &  fetch_value		; get operand
	LDA value			; needs to pick LSB!
	LDX value+1			; pick MSB up
	STA _x				; set X
	STX _x+1
	RTS


; ** .Y = set Y register **
set_Y:
	JSR $FFFF &  fetch_value		; get operand
	LDA value			; needs to pick LSB!
	LDX value+1			; pick MSB up
	STA _y				; set Y
	STX _y+1
	RTS


; ** .Z = set DP (new) **
set_DP:
	JSR $FFFF &  fetch_value		; get operand
; no need to complain if zero, pretty reasonable
	LDA value			; needs to pick LSB!
	LDX value+1			; pick MSB up
	STA _dp				; set DP
	STX _dp+1
	RTS


; *** useful routines ***
; ** basic output and hexadecimal handling **

; might include this library when a portable, properly interfaced one is available!
;#include "libs/hexio.s"
; in the meanwhile, it takes these subroutines

; * print a byte in A as two hex ciphers *
prnHex:
	PHA					; keep whole value
	LSR					; shift right four times (just the MSB)
	LSR
	LSR
	LSR
	JSR $FFFF &  ph_b2a			; convert and print this cipher
	PLA					; retrieve full value
	AND #$0F			; keep just the LSB... and repeat procedure
ph_b2a:
	CMP #10				; will be a letter?
	BCC ph_n			; just a number
		ADC #6				; convert to letter (plus carry)
ph_n:
	ADC #'0'			; convert to ASCII (carry is clear)
; ...and print it (will return somewhere)

; * print a character in A *
prnChar:
	STA io_c			; store character
	LDY iodev			; get device
	_KERNEL(COUT)		; output it ##### minimOS #####
; ignoring possible I/O errors
	RTS

; * print a NULL-terminated string pointed by $AAYY *
prnStr:
	STA str_pt+1		; store MSB
	STY str_pt			; LSB
; 16-bit version should set bank!
	PHK					; get current bank, much better this way!
	PLA					; into A
	STA str_pt+2		; set bank
	LDY iodev			; standard device
	_KERNEL(STRING)		; print it! ##### minimOS #####
; currently ignoring any errors...
	RTS

; * new approach for hex conversion *
; add one nibble from hex in current char!
; A is current char, returns result in value[0...2]
; does NOT advance any cursor (neither reads char from nowhere)
; MUST reset value previously!
hex2nib:
	SEC					; prepare for subtract
	SBC #'0'			; convert from ASCII
		BCC h2n_err			; below number!
	CMP #10				; already OK?
	BCC h2n_num			; do not convert from letter
		CMP #23				; otherwise should be a valid hex
			BCS h2n_rts			; or not! exits with C set
		SBC #6				; convert from hex (C is clear!)
h2n_num:
	LDY #4				; shifts counter, no longer X in order to save some pushing!
h2n_loop:
		ASL value			; current value will be times 16
		ROL value+1
		ROL value+2			; including bank!
		DEY					; next iteration
		BNE h2n_loop
	ORA value			; combine with older value
	STA value
	CLC					; all done without error
h2n_rts:
	RTS					; usual exit
h2n_err:
	SEC					; notify error!
	RTS

; ** end of inline library **

; * check whether opcode is REP/SEP in order to update size flags *** NO LONGER NEEDED but useful for disassembly
; A=opcode, X=operand, destroys Y
sflag_chk:
	TAY					; keep for later
	AND #%11011111		; filter out differences
	CMP #$C2			; is it REP/SEP?
	BNE schk_done		; no flags to correct
		TYA					; recheck opcode
		AND #%00100000		; one for SEP, zero for REP
		BEQ schk_rep
			TXA					; get operand to be set...
			ORA sflags			; ...onto current status
			STA sflags			; updated!
			RTS
schk_rep:
		TXA					; get operand to REset...
		EOR #$FF			; ...generating a mask...
		AND sflags			; ...applied to current status
		STA sflags			; updated!
schk_done:
	RTS

; * convert flag-dependent size markers to standard ones *
; A=operand marker, will return standard type
adrmodes:
	CMP #'!'			; depending on X flag?
	BNE sc_nxflag
		LDA #$10			; mask for X flag
		BRA sc_flchk		; check appropriate flag
sc_nxflag:
	CMP #'?'			; depending on M flag?
	BNE sc_stdm			; if not, nothing more to check
		LDA #$20			; mask for M flag
sc_flchk:
		AND sflags			; get special site for flags!!!
		BEQ sc_fl0			; if zero, 16-bit mode!
			LDA #'@'			; otherwise is an 8-bit amount
			RTS					; proceed as usual
sc_fl0:
		LDA #'&'			; expecting word size
sc_stdm:
		RTS			; as usual

; * get input line from device at fixed-address buffer *
; new movable buffer!
getLine:
	LDY bufpt			; get buffer address
	LDA bufpt+1			; likely 0 for the direct buffer
	LDX bufpt+2			; could assemble text from anywhere!
	STY str_pt			; set parameter
	STA str_pt+1
; 16-bit version should set bank!
	STX str_pt+2		; set bank, .t could assemble from anywhere
	LDX #BUFSIZ-1		; max index
	STX ln_siz			; set value
	LDY iodev			; use device
	_KERNEL(READLN)		; get line
	RTS					; and all done!

; * get clean character from NEW buffer in A, (return) offset at Y *
getNextChar:
	LDY cursor			; retrieve index
gnc_do:
	INY					; advance!
	LDA [bufpt], Y		; get raw character
		BEQ gn_ok			; go away if ended
	CMP #' '			; white space?
		BEQ gnc_do			; skip it!
	CMP #HTAB			; tabulations will be skipped too
		BEQ gnc_do
	CMP #'$'			; ignored radix?
		BEQ gnc_do			; skip it!
	CMP #COLON			; end of sentence?
		BEQ gn_exit			; command is done but not the whole buffer!
	CMP #CR				; newline?
		BEQ gn_exit			; go for next too
	CMP #';'			; is it a comment?
		BEQ gn_fin			; forget until the end
	CMP #'_'			; is it a label? Not yet supported!!!
		BEQ gn_fin			; treat it as a comment!
gnc_low:
	CMP #'a'			; not lowercase?
		BCC gn_ok			; all done!
	CMP #'z'+1			; still within lowercase?
		BCS gn_ok			; otherwise do not correct!
	AND #%11011111		; remove bit 5 to uppercase
gn_ok:
	CLC					; new, will signal buffer is done
	BRA gn_end			; save and exit
gn_fin:
		INY				; skip another character in comment
		LDA [bufpt], Y	; get pointed char
			BEQ gn_ok		; completely finish if already at terminator
		CMP #COLON		; colon ends just this sentence
			BEQ gn_exit
		CMP #CR			; newline ends too
			BNE gn_fin
gn_exit:
	SEC					; new, indicates command has ended but not the last in input buffer
gn_end:
	STY cursor			; worth updating here!
	RTS

; * back off one character, skipping whitespace, use instead of DEC cursor! *
backChar:
	LDY cursor			; get current position
bc_loop:
		DEY					; back once
		LDA [bufpt], Y		; check what is pointed
		CMP #' '			; blank?
			BEQ bc_loop			; once more
		CMP #HTAB			; tabulation?
			BEQ bc_loop			; ignore
		CMP #'$'			; ignored radix?
			BEQ bc_loop			; also ignore
	STY cursor				; otherwise we are done
	RTS

; * get clean NEXT character from opcode list *
; no point on setting Carry if last one!
getListChar:
		INC scan			; try next
		BNE glc_do			; if did not wrap
			INC scan+1			; otherwise carry on
;		BNE glc_do			; if bank boundary was crossed...
;			INC scan+2			; ...correct 24b pointer
glc_do:
		LDA [scan]			; get current, 24b
		CMP #' '			; is it blank? will never end an opcode, though
		BEQ getListChar		; nothing interesting yet
	AND #$7F			; most convenient!
	RTS

; * fetch one byte from buffer, value in A and @value.b *
; newest approach as interface for fetch_value
fetch_byte:
	JSR $FFFF &  fetch_value		; get whatever
	LDA temp			; how many bytes will fit?
	INC					; round up chars...
	LSR					; ...and convert to bytes
	CMP #1				; strictly one?
	BRA ft_check		; common check

; * fetch two bytes from hex input buffer, value @value.w *
fetch_word:
; another approach using fetch_value
	JSR $FFFF &  fetch_value		; get whatever
	LDA temp			; how many bytes will fit?
	INC					; round up chars...
	LSR					; ...and convert to bytes
	CMP #2				; strictly two?
; common fetch error check
ft_check:
	BNE ft_err
		CLC					; if so, all OK
		LDA value			; convenient!!!
		RTS
; common fetch error discard routine
ft_err:
	LDA temp			; check how many chars were processed eeeeeeek
	BEQ ft_clean		; nothing to discard eeeeeeeeek
ft_disc:
		JSR $FFFF &  backChar		; should discard previous char!
		DEC temp			; one less to go
		BNE ft_disc			; continue until all was discarded
ft_clean:
	SEC					; there was an error
	RTS

; * fetch three bytes from hex input buffer, value @value.l *
;	newest approach
fetch_long:
	JSR $FFFF &  fetch_value		; get whatever
	LDA temp			; how many bytes will fit?
	INC					; round up chars...
	LSR					; ...and convert to bytes
	CMP #3				; strictly three?
	BRA ft_check		; common check

; * fetch typed value, no matter the number of chars *
fetch_value:
	STZ value			; clear full result
	STZ value+1
	STZ value+2
	STZ temp			; no chars processed yet
; could check here for symbolic references...
ftv_loop:
		JSR $FFFF &  getNextChar		; go to operand first cipher!
		JSR $FFFF &  hex2nib			; process one char
			BCS ftv_bad			; no more valid chars
		INC temp			; otherwise count one
		BRA ftv_loop		; until no more valid
ftv_bad:
	JSR $FFFF &  backChar		; should discard very last char! eeeeeeeek
	CLC					; always check temp=0 for errors!
	RTS

; *** pointers to command routines (? to Z) ***
cmd_ptr:
	.word	help			; .?
	.word	set_DBR			; .@
	.word	set_A			; .A
	.word	store_byte		; .B
	.word	call_address	; .C
	.word	disassemble		; .D
	.word	examine			; .E
	.word		_unrecognised	; .F will invoke line editor
	.word	set_SP			; .G
	.word		_unrecognised	; .H is RESERVED this far
	.word		_unrecognised	; .I will be symbol_table
	.word	jump_address	; .J
	.word	ext_bytes		; .K
	.word	set_siz			; .L
	.word	move			; .M
	.word	set_count		; .N
	.word	origin			; .O
	.word	set_PSR			; .P
	.word	quit			; .Q
	.word	reboot			; .R
	.word	store_str		; .S
	.word	asm_source		; .T
	.word	set_lines		; .U
	.word	view_regs		; .V
	.word	store_word		; .W
	.word	set_X			; .X
	.word	set_Y			; .Y
	.word	set_DP			; .Z

; *** strings and other data ***
splash:
	.asc	"minimOS 0.6 monitor/debugger/assembler", CR
	.asc	"(c) 2016-2019 Carlos Santisteban", CR
#ifdef	SAFE
	.asc	"Type opcodes or .command, .? for help", CR
#endif
	.asc	0

err_bad:
	.asc	"*** Bad command ***", CR, 0

err_opc:
	.asc	"*** Bad opcode ***", CR, 0

err_ovf:
	.asc	"*** Out of range ***", CR, 0

regs_head:
	.asc	"A:   X:   Y:   SP:  DP:  B: NVmxDIZC", CR, 0

dump_in:
	.asc	" [", 0

dump_out:
	.asc	"] ", 0

shut_str:
	.asc	"Cold, Warm, Shutdown?", CR, 0

io_err:
	.asc	"*** I/O error ***", CR, 0

set_str:
	.asc	" = $", 0

ex_trok:
	.asc	" bytes transferred", CR, 0

; online help only available under the SAFE option!
help_str:
#ifdef	SAFE
	.asc	"(d, a, l => 2, 4, 6 hex chars)", CR
	.asc	"(* => up to 6 hex chars)", CR
	.asc	"(s => raw string, ends on C", "R)", CR
	.asc	"(r => M/X register size,", CR, " +/-/= => 16/8/no change", CR
	.asc	"---Command list---", CR
	.asc	".?   = show this list", CR
	.asc	".@d  = set Data Bank reg.", CR
	.asc	".A*  = set A reg. (16-bit)", CR
	.asc	".Bd  = store byte", CR
	.asc	".C*  = call subroutine", CR
	.asc	".D*  = disassemble 'u' opcodes", CR
	.asc	".E*  = dump 'u' lines", CR
;	.asc	".F*  = edit text on memory", CR
	.asc	".Ga  = set SP reg.", CR
;	.asc	".H   = RESERVED?", CR
;	.asc	".I   = show symbol table", CR
	.asc	".J*  = jump to address", CR
	.asc	".K+d = load n bytes from dev. d", CR
	.asc	".K-d = save n bytes to device d", CR
	.asc	".Lrr = set M & X register sizes", CR
	.asc	".M*  = copy 'n' bytes to l", CR
	.asc	".Na  = set 'n' value (16-bit)", CR
	.asc	".O*  = set origin address", CR
	.asc	".Pd  = set Status reg.", CR
	.asc	".Q   = quit", CR
	.asc	".R   = reboot or poweroff", CR
	.asc	".Ss  = store raw string", CR
	.asc	".T*  = assemble source", CR
	.asc	".Ud  = set 'u' lines", CR
	.asc	".V   = view registers", CR
	.asc	".Wa  = store word", CR
	.asc	".X*  = set X reg. (16-bit)", CR
	.asc	".Y*  = set Y reg. (16-bit)", CR
	.asc	".Z*  = set Direct Page (16-bit)", CR
#endif
	.byt	0

#ifdef	NOHEAD
title:
	.asc	"miniMoDA", 0	; headerless builds
#endif

; include opcode list
da_oclist:
#include "data/opcodes16.s"
mmd_end:					; size computation
.)

.as:.xs
