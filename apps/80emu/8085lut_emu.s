; Intel 8080/8085 emulator for minimOS!
; *** FASTER VERSION WITH LUT *** Rockwell only!
; v0.1b2
; (c) 2016-2020 Carlos J. Santisteban
; last modified 20180404-1425

#include "../../OS/usual.h"

; ** some useful macros **
; these make listings more succint

; inject address MSB into 16+16K space (5/5.5/6)
#define	_AH_BOUND	AND #hi_mask: BMI *+4: ORA #lo_mask

; increment Y checking injected boundary crossing (5/5/30) ** new compact version
#define	_PC_ADV		INY: BNE *+5: JSR wrap_pc

; compute pointer for direct absolute addressing mode (31/31.5/57) eeeek
#define	_DIRECT		_PC_ADV: LDA (pc80), Y: STA tmptr: _PC_ADV: LDA (pc80), Y: _AH_BOUND: STA tmptr+1

; compute pointer from HL (17/17.5/18)
#define	_MEMORY		LDX l80: LDA h80: _AH_BOUND: STX tmptr: STA tmptr+1


; *** declare some constants ***
hi_mask	= %10111111	; injects A15 hi into $8000-$BFFF, regardless of A14
lo_mask	= %01000000	; injects A15 lo into $4000-$7FFF, regardless of A14
;lo_mask	= %00100000	; injects into upper 8 K ($2000-$3FFF) for 16K RAM systems

; *** declare zeropage addresses ***
; ** 'uz' is first available zeropage address (currently $03 in minimOS) **
tmptr	= uz		; temporary storage (up to 16 bit, little endian)
sp80		= uz+2	; stack pointer (16 bit injected into host map)
pc80		= uz+4	; program counter (16 bit injected into host map)

f80		= uz+6	; flags SZ?H?P-C

; S is sign
; Z is zero
; ? is always 0 on 8080, undefined in 8085
; H is half carry (for BCD, not testable), reset by OR/XOR
; P is parity, sets on logical/rots (and more?) when number of 1s is EVEN
; ** on Z80 is P/V, also overflow
; - is always 1 in 8080, undefined in 8085
; ** - is add/subtract in Z80 (for BCD, not testable) 1 is subtract
; C is carry, reset by AND, OR, XOR, borrow unlike 6502!

a80		= uz+7	; general purpose registers
c80		= uz+8
b80		= uz+9
e80		= uz+10
d80		= uz+11
l80		= uz+12
h80		= uz+13

rimask	= uz+14	; interrupt masks as set by SIM and read by RIM

; rimask = SID-I7-I6-I5-IE-M7-M6-M5
; SID is serial input (not implemented)
; I7~I5 are pending stati of INT7.5 ~ INT5.5, first one could be reset by SIM.D4
; IE is interrupt enable flag, also at f.d5???
; M7~M5 are the masks for INT7.5~INT5.5, set by SIM.d2~d0 iff d3=1

cdev		= uz+15		; I/O device *** minimOS specific ***

; *** minimOS executable header will go here ***

; *** startup code, minimOS specific stuff ***
	LDA #cdev-uz+1	; zeropage space needed
#ifdef	SAFE
	CMP z_used		; check available zeropage space
	BCC go_emu		; more than enough space
	BEQ go_emu		; just enough!
		_ABORT(FULL)	; not enough memory otherwise (rare) new interface
go_emu:
#endif
	STA z_used		; set required ZP space as required by minimOS
	STZ zpar		; no screen size required
	STZ zpar+1		; neither MSB
	LDY #<title		; LSB of window title
	LDA #>title		; MSB of window title
	STY zaddr3		; set parameter
	STA zaddr3+1
	_KERNEL(OPEN_W)	; ask for a character I/O device
	BCC open_emu	; no errors
		_ABORT(NO_RSRC)	; abort otherwise!
open_emu:
	STY cdev		; store device!!!
; should try to allocate memory here

; *** start the emulation! ***
reset80:
	LDY #0		; RST 0
	STY rimask	; restart with interrupts disabled
	STY pc80	; indirect indexed! NMOS savvy...
	LDA #lo_mask	; inject low memory into 65xx space
	STA pc80+1	; injected MSB

; *** main loop ***
execute:
		LDA (pc80), Y	; get opcode (needs CMOS) (5)
		ASL				; double it as will become pointer (2)
		TAX				; use as pointer, keeping carry (2)
		BCC lo_jump		; seems to be less opcodes with bit7 low... (2/3)
			JMP (opt_h, X)	; emulation routines for opcodes with bit7 hi (6)
lo_jump:
			JMP (opt_l, X)	; otherwise, emulation routines for opcodes with bit7 low

; *** NOP (4) arrives here, saving 3 bytes and 3 cycles ***
; also 'absurd' instructions like MOV B, B

_00:
_40:_49:_52:_5b:_64:_6d:_7f:

; continue execution via JMP next_op, will not arrive here otherwise
next_op:
		INY				; advance one byte (2)
		BNE execute		; fetch next instruction if no boundary is crossed (3/2)
		
; usual overhead is 22 clock cycles, not including final jump
; boundary crossing, simplified version
; ** should be revised for other than 16K+16K systems **

	INC pc80 + 1		; increment MSB otherwise, faster than using 'that macro' (5)
	BPL execute			; seems to stay in low area (3/2)
		RMB6 pc80 + 1		; in ROM area, A14 is goes low (5) *** Rockwell
	BRA execute			; fetch next (3)


; *** window title, optional and minimOS specific ***
title:
	.asc	"i8085", 0
exit:
	.asc 13, "{HLT}", 13, 0


; *** interrupt support ***
; unsupported opcodes will be TRAPped

_08:_10:_18:_28:_38:_d9:
_cb:_ed:_dd:_fd:

	_PC_ADV			; skip illegal opcode (5)

nmi80:				; hardware interrupts, when available, to be checked AFTER incrementing PC
; nmi is called TRAP in 8085, absent in 8080!!!
	LDX #$24			; offset for NMI entry point (2)

intr80:				; ** generic interrupt entry point, offset in X ** (70/76.5/83)
	STX tmptr		; keep it eeeeeek^2 (3)
	TYA
	TAX			; retrieve current PC (2+2+3)
	LDA pc80+1
	JSR push	; save return address (50 best case)
; saved processor status
; seems to push PC only!!!
	LDX tmptr	; retrieve offset eeeeek^2 (3)

vector_pull:		; ** standard jump to entry point, offset in X **
	LDA #lo_mask	; get injected MSB (2)
	STA pc80+1	; set it (3)
	TXA
	TAY		; update PC (4)
	BRA execute		; continue with interrupt handler

; ** other 8085 hardware interrupts... when available **
rst55:
		BBS0 rimask, execute	; ignore if masked
	LDX #$2C	; hardwired address
	BRA intr80	; respond to interrupt

rst65:
		BBS1 rimask, execute	; ignore if masked
	LDX #$34	; hardwired address
	BRA intr80	; respond to interrupt

rst75:
		BBS2 rimask, execute	; ignore if masked
	LDX #$3C	; hardwired address
	BRA intr80	; respond to interrupt


; ** common routines **

; increment PC MSB in case of boundary crossing, rare (19/19.5/20)
wrap_pc:
	LDA pc80 + 1	; get MSB
	INC				; increment
	_AH_BOUND		; keep injected!
	STA pc80 + 1	; update pointer
	RTS				; *** to be used in rare cases, worth it ***

; push word from A/X into stack (44/50.5/57)
push:
	PHA		; keep it!
	LDA sp80	; prefetch SP LSB
	BNE ph1n	; will not wrap!
		LDA sp80+1	; correct MSB
		DEC
		_AH_BOUND		; just in case
		STA sp80+1
ph1n:
	PLA		; retrieve LSB
	DEC sp80	; predecrement
	STA (sp80)	; store without altering status
	BNE ph2n	; will not wrap second time
		LDA sp80+1	; correct MSB otherwise
		DEC
		_AH_BOUND		; just in case
		STA sp80+1
ph2n:
	DEC sp80	; last predecrement
	TXA		; original LSB
	STA (sp80)	; push LSB last
	RTS

; pop word from stack into A/X (34/44/54)
pop:
	LDA (sp80)	; pop first value as will be postincrementd
	TAX		; final LSB destination
	INC sp80	; postincrement
	BNE plnw	; did not wrap
		LDA sp80+1	; correct MSB otherwise
		INC
		_AH_BOUND		; just in case
		STA sp80+1
plnw:
	LDA (sp80)	; now pop other byte
	INC sp80	; postincrement
	BNE plend	; all OK
		PHA		; need to keep value
		LDA sp80+1	; correct MSB...
		INC
		_AH_BOUND		; ...and keep it injected
		STA sp80+1
		PLA		; retrieve value
plend:
	RTS


; *** *** valid opcode definitions *** ***

; ** move ** these do not affect any flags
; to B

_41:
; MOV B,C (5, 4 @ 8085)
; +9
	LDA c80	; source
	STA b80	; destination
	JMP next_op	; flags unaffected

_42:
; MOV B,D (5, 4 @ 8085)
; +9
	LDA d80	; source
	STA b80	; destination
	JMP next_op	; flags unaffected

_43:
; MOV B,E (5, 4 @ 8085)
; +9
	LDA e80	; source
	STA b80	; destination
	JMP next_op	; flags unaffected

_44:
; MOV B,H (5, 4 @ 8085)
; +9
	LDA h80	; source
	STA b80	; destination
	JMP next_op	; flags unaffected

_45:
; MOV B,L (5, 4 @ 8085)
; +9
	LDA l80	; source
	STA b80	; destination
	JMP next_op	; flags unaffected

_46:
; MOV B,M (7) from memory
; +28/28.5/29
	_MEMORY		; prepare pointer
	LDA (tmptr)	; pointed source
	STA b80	; destination
	JMP next_op	; flags unaffected

_47:
; MOV B,A (5, 4 @ 8085)
; +9
	LDA a80	; source
	STA b80	; destination
	JMP next_op	; flags unaffected

; to C

_48:
; MOV C,B (5, 4 @ 8085)
; +9
	LDA b80	; source
	STA c80	; destination
	JMP next_op	; flags unaffected

_4a:
; MOV C,D (5, 4 @ 8085)
; +9
	LDA d80	; source
	STA c80	; destination
	JMP next_op	; flags unaffected

_4b:
; MOV C,E (5, 4 @ 8085)
; +9
	LDA e80	; source
	STA c80	; destination
	JMP next_op	; flags unaffected

_4c:
; MOV C,H (5, 4 @ 8085)
; +9
	LDA h80	; source
	STA c80	; destination
	JMP next_op	; flags unaffected

_4d:
; MOV C,L (5, 4 @ 8085)
; 9
	LDA l80	; source
	STA c80	; destination
	JMP next_op	; flags unaffected

_4e:
; MOV C,M (7) from memory
; +28/28.5/29
	_MEMORY		; prepare pointer
	LDA (tmptr)	; pointed source
	STA c80	; destination
	JMP next_op	; flags unaffected

_4f:
; MOV C,A (5, 4 @ 8085)
; +9
	LDA a80	; source
	STA c80	; destination
	JMP next_op	; flags unaffected

; to D

_50:
; MOV D,B (5, 4 @ 8085)
; +9
	LDA b80	; source
	STA d80	; destination
	JMP next_op	; flags unaffected

_51:
; MOV D,C (5, 4 @ 8085)
; +9
	LDA c80	; source
	STA d80	; destination
	JMP next_op	; flags unaffected

_53:
; MOV D,E (5, 4 @ 8085)
; +9
	LDA e80	; source
	STA d80	; destination
	JMP next_op	; flags unaffected

_54:
; MOV D,H (5, 4 @ 8085)
; +9
	LDA h80	; source
	STA d80	; destination
	JMP next_op	; flags unaffected

_55:
; MOV D,L (5, 4 @ 8085)
; +9
	LDA l80	; source
	STA d80	; destination
	JMP next_op	; flags unaffected

_56:
; MOV D,M (7) from memory
; +28/28.5/29
	_MEMORY		; prepare pointer
	LDA (tmptr)	; pointed source
	STA d80	; destination
	JMP next_op	; flags unaffected

_57:
; MOV D,A (5, 4 @ 8085)
; +9
	LDA a80	; source
	STA d80	; destination
	JMP next_op	; flags unaffected

; to E

_58:
; MOV E,B (5, 4 @ 8085)
; +9
	LDA b80	; source
	STA e80	; destination
	JMP next_op	; flags unaffected

_59:
; MOV E,C (5, 4 @ 8085)
; +9
	LDA c80	; source
	STA e80	; destination
	JMP next_op	; flags unaffected

_5a:
; MOV E,D (5, 4 @ 8085)
; +9
	LDA d80	; source
	STA e80	; destination
	JMP next_op	; flags unaffected

_5c:
; MOV E,H (5, 4 @ 8085)
; +9
	LDA h80	; source
	STA e80	; destination
	JMP next_op	; flags unaffected

_5d:
; MOV E,L (5, 4 @ 8085)
; +9
	LDA l80	; source
	STA e80	; destination
	JMP next_op	; flags unaffected

_5e:
; MOV E,M (7) from memory
; +28/28.5/29
	_MEMORY		; prepare pointer
	LDA (tmptr)	; pointed source
	STA e80	; destination
	JMP next_op	; flags unaffected

_5f:
; MOV E,A (5, 4 @ 8085)
; +9
	LDA a80	; source
	STA e80	; destination
	JMP next_op	; flags unaffected

; to H

_60:
; MOV H,B (5, 4 @ 8085)
; +9
	LDA b80	; source
	STA h80	; destination
	JMP next_op	; flags unaffected

_61:
; MOV H,C (5, 4 @ 8085)
; +9
	LDA c80	; source
	STA h80	; destination
	JMP next_op	; flags unaffected

_62:
; MOV H,D (5, 4 @ 8085)
; +9
	LDA d80	; source
	STA h80	; destination
	JMP next_op	; flags unaffected

_63:
; MOV H,E (5, 4 @ 8085)
; +9
	LDA e80	; source
	STA h80	; destination
	JMP next_op	; flags unaffected

_65:
; MOV H,L (5, 4 @ 8085)
; +9
	LDA l80	; source
	STA h80	; destination
	JMP next_op	; flags unaffected

_66:
; MOV H,M (7) from memory
; +28/28.5/29
	_MEMORY		; prepare pointer
	LDA (tmptr)	; pointed source
	STA h80	; destination
	JMP next_op	; flags unaffected

_67:
; MOV H,A (5, 4 @ 8085)
; +9
	LDA a80	; source
	STA h80	; destination
	JMP next_op	; flags unaffected

; to L

_68:
; MOV L,B (5, 4 @ 8085)
; +9
	LDA b80	; source
	STA l80	; destination
	JMP next_op	; flags unaffected

_69:
; MOV L,C (5, 4 @ 8085)
; +9
	LDA c80	; source
	STA l80	; destination
	JMP next_op	; flags unaffected

_6a:
; MOV L,D (5, 4 @ 8085)
; +9
	LDA d80	; source
	STA l80	; destination
	JMP next_op	; flags unaffected

_6b:
; MOV L,E (5, 4 @ 8085)
; +9
	LDA e80	; source
	STA l80	; destination
	JMP next_op	; flags unaffected

_6c:
; MOV L,H (5, 4 @ 8085)
; +9
	LDA h80	; source
	STA l80	; destination
	JMP next_op	; flags unaffected

_6e:
; MOV L,M (7) from memory
; +28/28.5/29
	_MEMORY		; prepare pointer
	LDA (tmptr)	; pointed source
	STA l80	; destination
	JMP next_op	; flags unaffected

_6f:
; MOV L,A (5, 4 @ 8085)
; +9
	LDA a80	; source
	STA l80	; destination
	JMP next_op	; flags unaffected

; to memory

_70:
; MOV M,B (7)
; +33/33.5/34
	LDX b80	; source
	BRA movm	; common end

_71:
; MOV M,C (7)
; +33/33.5/34
	LDX c80	; source
	BRA movm	; common end

_72:
; MOV M,D (7)
; +33/33.5/34
	LDX d80	; source
	BRA movm	; common end

_73:
; MOV M,E (7)
; +33/33.5/34
	LDX e80	; source
	BRA movm	; common end

_74:
; MOV M,H (7)
; +33/33.5/34
	LDX h80	; source
	BRA movm	; common end

_75:
; MOV M,L (7)
; +33/33.5/34
	LDX l80	; source
	BRA movm	; common end

_77:
; MOV M,A (7) cannot use macro in order to stay generic
; +30/30.5/31
	LDX a80	; source
movm:
	LDA l80		; pointer LSB
	STA tmptr	; create temporary pointer
	LDA h80		; pointer MSB...
	_AH_BOUND	; ...to be bound
	STA tmptr+1	; pointer ready
	TXA		; get data
	STA (tmptr)	; pointed source
	JMP next_op	; flags unaffected

; to A

_78:
; MOV A,B (5, 4 @ 8085)
; +9
	LDA b80	; source
	STA a80	; destination
	JMP next_op	; flags unaffected

_79:
; MOV A,C (5, 4 @ 8085)
; +9
	LDA c80	; source
	STA a80	; destination
	JMP next_op	; flags unaffected

_7a:
; MOV A,D (5, 4 @ 8085)
; +9
	LDA d80	; source
	STA a80	; destination
	JMP next_op	; flags unaffected

_7b:
; MOV A,E (5, 4 @ 8085)
; +9
	LDA e80	; source
	STA a80	; destination
	JMP next_op	; flags unaffected

_7c:
; MOV A,H (5, 4 @ 8085)
; +9
	LDA h80	; source
	STA a80	; destination
	JMP next_op	; flags unaffected

_7d:
; MOV A,L (5, 4 @ 8085)
; +9
	LDA l80	; source
	STA a80	; destination
	JMP next_op	; flags unaffected

_7e:
; MOV A,M (7) from memory
; +28/28.5/29
	_MEMORY		; prepare pointer
	LDA (tmptr)	; pointed source
	STA a80	; destination
	JMP next_op	; flags unaffected

; immediate

_06:
; MVI B (7)
; +16/16/41
	_PC_ADV		; point to operand
	LDA (pc80), Y	; get immediate
	STA b80	; destination
	JMP next_op	; flags unaffected

_0e:
; MVI C (7)
; +16/16/41
	_PC_ADV		; point to operand
	LDA (pc80), Y	; get immediate
	STA c80	; destination
	JMP next_op	; flags unaffected

_16:
; MVI D (7)
; +16/16/41
	_PC_ADV		; point to operand
	LDA (pc80), Y	; get immediate
	STA d80	; destination
	JMP next_op	; flags unaffected

_1e:
; MVI E (7)
; +16/16/41
	_PC_ADV		; point to operand
	LDA (pc80), Y	; get immediate
	STA e80	; destination
	JMP next_op	; flags unaffected

_26:
; MVI H (7)
; +16/16/41
	_PC_ADV		; point to operand
	LDA (pc80), Y	; get immediate
	STA h80	; destination
	JMP next_op	; flags unaffected

_2e:
; MVI L (7)
; +16/16/41
	_PC_ADV		; point to operand
	LDA (pc80), Y	; get immediate
	STA l80	; destination
	JMP next_op	; flags unaffected

_36:
; MVI M (10) to memory
; +35/35.5/61
	_MEMORY		; prepare pointer
	_PC_ADV		; point to operand
	LDA (pc80), Y	; get immediate
	STA (tmptr)	; eeeeeeek
	JMP next_op	; flags unaffected

_3e:
; MVI A (7)
; +16/16/41
	_PC_ADV		; point to operand
	LDA (pc80), Y	; get immediate
	STA a80	; destination
	JMP next_op	; flags unaffected

; double immediate

_01:
; LXI B (10)
; +29/29/54
	_PC_ADV		; point to operand
	LDA (pc80), Y	; get first immediate
	STA c80	; LSB destination
	_PC_ADV		; advance to next byte
	LDA (pc80), Y	; get second immediate
	STA b80	; MSB destination
	JMP next_op	; flags unaffected

_11:
; LXI D (10)
; +29/29/54
	_PC_ADV		; point to operand
	LDA (pc80), Y	; get first immediate
	STA e80	; LSB destination
	_PC_ADV		; advance to next byte
	LDA (pc80), Y	; get second immediate
	STA d80	; MSB destination
	JMP next_op	; flags unaffected

_21:
; LXI H (10)
; +29/29/54
	_PC_ADV		; point to operand
	LDA (pc80), Y	; get first immediate
	STA l80	; LSB destination
	_PC_ADV		; advance to next byte
	LDA (pc80), Y	; get second immediate
	STA h80	; MSB destination
	JMP next_op	; flags unaffected

_31:
; LXI SP (10)
; +34/34.5/60
	_PC_ADV		; point to operand
	LDA (pc80), Y	; get first immediate
	STA sp80	; LSB destination
	_PC_ADV		; advance to next byte
	LDA (pc80), Y	; get second immediate
	_AH_BOUND		; SP is kept bound eeeeeeek
	STA sp80+1	; MSB destination
	JMP next_op	; flags unaffected

; ** load/store A indirect **

_0a:
; LDAX B (7)
; +28/28.5/29
	LDX c80		; pointer LSB
	LDA b80		; pointer MSB...
ldax:
	_AH_BOUND	; ...to be bound
	STX tmptr	; create temporary pointer
	STA tmptr+1
	LDA (tmptr)	; pointed source
	STA a80	; destination
	JMP next_op	; flags unaffected

_1a:
; LDAX D (7)
; +31/31.5/32
	LDX e80		; pointer LSB
	LDA d80		; pointer MSB...
	BRA ldax	; common end

_02:
; STAX B (7)
; +28/28.5/29
	LDX c80		; pointer LSB
	LDA b80		; pointer MSB...
stax:
	_AH_BOUND	; ...to be bound
	STX tmptr	; create temporary pointer
	STA tmptr+1
	LDA a80	; get source data
	STA (tmptr)	; indirect destination
	JMP next_op	; flags unaffected

_12:
; STAX D (7)
;+31/31.5/32
	LDX e80		; pointer LSB
	LDA d80		; pointer MSB...
	BRA stax	; common end

; ** load/store direct **

_3a:
; LDA (13)
;+42/42.5/68
	_DIRECT		; get pointer to operand
	LDA (tmptr)	; actual data
	STA a80	; destination
	JMP next_op	; flags unaffected

_2a:
; LHLD (16) load HL direct
;+63/67.5/97
	_DIRECT		; point to operand
	LDA (tmptr)	; actual LSB
	STA l80	; destination
	INC tmptr	; point to MSB
	BNE lhld	; did not wrap
		LDA tmptr+1	; eeeeeeeeek
		INC		; correct MSB otherwise
		_AH_BOUND	; eeeeeek
		STA tmptr+1
lhld:
	LDA (tmptr)	; repeat for MSB
	STA h80
	JMP next_op	; flags unaffecfed

_32:
; STA (13)
;+42/42.5/68
	_DIRECT		; get destination address
	LDA a80	; source data
	STA (tmptr)	; store at destination
	JMP next_op	; flags unaffected

_22:
; SHLD (16) store HL direct
;+63/67.5/97
	_DIRECT		; point to operand
	LDA l80	; actual LSB
	STA (tmptr)	; destination
	INC tmptr	; point to MSB
	BNE shld	; did not wrap
		LDA tmptr+1	; eeeeeeeeek
		INC		; correct MSB otherwise
		_AH_BOUND	; eeeeeek
		STA tmptr+1
shld:
	LDA h80	; repeat for MSB
	STA (tmptr)
	JMP next_op	; flags unaffecfed

; exchange DE & HL

_eb:
; XCHG (4)
;+27
	LDX d80	; preserve MSB
	LDA h80	; get other source
	STA d80	; substitute
	STX h80	; restore other MSB
	LDX e80	; same for LSB
	LDA l80
	STA e80
	STX l80
	JMP next_op	; flags unaffected


; ** jump **

_c3:
; JMP (10)
;+38/38.5/64
jump:
	_DIRECT		; get target address in tmptr
do_jmp:
	LDY tmptr	; copy fetched address...
	LDX tmptr+1	; already bound MSB
	STX pc80+1	; ...into PC
	JMP execute	; jump to it!

_da:
; JC (10, 7/10 @ 8085) if carry
;+44/44.5/70 if taken, +21/21/46 if not
		BBS0 f80, jump	; best way
	BRA notjmp	; otherwise skip & continue

_d2:
; JNC (10, 7/10 @ 8085) if not carry
;+44/44.5/70 if taken, +21/21/46 if not
		BBR0 f80, jump	; best way
	BRA notjmp	; otherwise skip & continue

_f2:
; JP (10, 7/10 @ 8085) if plus
;+44/44.5/70 if taken, +21/21/46 if not
		BBR7 f80, jump	; best way
	BRA notjmp	; skip and continue

_fa:
; JM (10, 7/10 @ 8085) if minus
;+44/44.5/70 if taken, +21/21/46 if not
		BBS7 f80, jump	; best way
	BRA notjmp	; skip and continue

_ca:
; JZ (10, 7/10 @ 8085) if zero
;+44/44.5/70 if taken, +18/18/43 if not
		BBS6 f80, jump	; best way
notjmp:
	_PC_ADV		; skip unused address
	_PC_ADV
	JMP next_op	; continue otherwise

_c2:
; JNZ (10, 7/10 @ 8085) if not zero
;+44/44.5/70 if taken, +21/21/46 if not
		BBR6 f80, jump	; best way
	BRA notjmp	; skip and continue

_ea:
; JPE (10, 7/10 @ 8085) on parity even, better version
;+44/44.5/70 if taken, +21/21/46 if not
		BBS2 f80, jump	; jump on flag 2 set
	BRA notjmp	; otherwise skip and continue

_e2:
; JPO (10, 7/10 @ 8085) on parity odd
;+44/44.5/70 if taken, +21/21/46 if not
		BBR2 f80, jump	; jump on flag 2 clear
	BRA notjmp	; otherwise skip and continue

_e9:
; PCHL (5, 6 @ 8085) jump to address pointed by HL
;+17/17.5/18
	LDY l80		; get HL word
	LDA h80
	_AH_BOUND	; eeeeeek
	STA pc80+1	; set PC
	JMP execute


; ** call **

_cd:
; CALL (17, 18 @ 8085)
;+100/107/136###
call:
	_DIRECT		; get target address in tmptr
	_PC_ADV		; set PC as the return address
	TYA
	TAX		; fetch PC LSB
	LDA pc80+1	; fetch PC MSB
	JSR push	; ***might be online*** push word in A/X
	BRA do_jmp	; continue like jump, shorter (7)
	
_dc:
; CC (11/17, 9/18 @ 8085) if carry
;+106/113/142### if taken, +21/21/46 if not
		BBS0 f80, call	; best way
	BRA notjmp	; otherwise skip & continue

_d4:
; CNC (11/17, 9/18 @ 8085) if not carry
;+106/113/142### if taken, +21/21/46 if not
		BBR0 f80, call	; best way
	BRA notjmp	; otherwise skip & continue

_f4:
; CP (11/17, 9/18 @ 8085) if plus
;+106/113/142### if taken, +21/21/46 if not
		BBR7 f80, call	; better
	BRA notjmp	; skip and continue

_fc:
; CM (11/17, 9/18 @ 8085) if minus
;+106/113/142### if taken, +21/21/46 if not
		BBS7 f80, call	; best way
	BRA notjmp	; otherwise skip & continue

_cc:
; CZ (11/17, 9/18 @ 8085) if zero
;+106/113/142### if taken, +21/21/46 if not
		BBS6 f80, call	; best way
	BRA notjmp	; otherwise skip & continue

_c4:
; CNZ (11/17, 9/18 @ 8085) if not zero
;+106/113/142### if taken, +21/21/46 if not
		BBR6 f80, call	; best way
	BRA notjmp	; otherwise skip & continue

_ec:
; CPE (11/17, 9/18 @ 8085) on parity even, better version, saves 3 bytes & 2 clocks
;+106/113/142### if taken, +21/21/46 if not
		BBS2 f80, call	; jump on flag 2 set
	BRA notjmp	; otherwise skip and continue

_e4:
; CPO (11/17, 9/18 @ 8085p) on parity odd
;+106/113/142### if taken, +21//46 if not
		BBR2 f80, call	; jump on flag 2 clear
	BRA notjmp	; otherwise skip and continue


; ** return **

_c9:
; RET (10)
;+50/60.5/71
ret:
; pop return address from stack
	JSR pop		; ***might be online*** returns word in A/X
	_AH_BOUND		; just in case!
	STA pc80+1	; fetch injected MSB
	TXA		; fetch LSB...
	TAY		; ...into PC
	JMP execute	; back to caller
	
_d8:
; RC (5/11, 6/12 @ 8085) if carry
;+56/66.5/77 if taken, +21/21/46 if not
		BBS0 f80, ret	; faster & shorter
	BRA notjmp2	; otherwise skip & continue

_d0:
; RNC (5/11, 6/12 @ 8085) if not carry
;+56/66.5/77 if taken, +21/21/46 if not
		BBR0 f80, ret	; faster & shorter
	BRA notjmp2	; otherwise skip & continue

_f0:
; RP (5/11, 6/12 @ 8085) if plus
;+56/66.5/77 if taken, +21/21/46 if not
		BBR7 f80, ret	; faster & shorter
	BRA notjmp2	; otherwise skip & continue

_f8:
; RM (5/11, 6/12 @ 8085) if minus
;+56/66.5/77 if taken, +21/21/46 if not
		BBS7 f80, ret	; faster & shorter
	BRA notjmp2	; otherwise skip & continue

_c0:
; RNZ (5/11, 6/12 @ 8085) if not zero
;+56/66.5/77 if taken, +21/21/46 if not
		BBR6 f80, ret	; faster & shorter
	BRA notjmp2	; otherwise skip & continue

_c8:
; RZ (5/11, 6/12 @ 8085) if zero
;+56/66.5/77 if taken, +18/18/43 if not
		BBS6 f80, ret	; faster & shorter
notjmp2:
	_PC_ADV		; skip unused address
	_PC_ADV
	JMP next_op	; continue otherwise

_e8:
; RPE (5/11, 6/12 @ 8085) on parity even, better version
;+56/66.5/77 if taken, +21/21/46 if not
		BBS2 f80, ret	; jump on flag 2 set
	BRA notjmp2	; otherwise skip and continue

_e0:
; RPO (5/11, 6/12 @ 8085) on parity odd
;+56/66.5/77 if taken, +21/21/46 if not
		BBR2 f80, ret	; jump on flag 2 clear
	BRA notjmp2	; otherwise skip and continue


; ** restart **
; faster, specific routines

_c7:
; RST 0 (11, 12 @ 8085)
;+80/86.5/118
	_PC_ADV		; skip opcode
	LDX #0	; offset
	JMP intr80	; calling procedure

_cf:
; RST 1 (11, 12 @ 8085)
;+80/86.5/118
	_PC_ADV		; skip opcode
	LDX #$08	; offset
	JMP intr80	; calling procedure

_d7:
; RST 2 (11, 12 @ 8085)
;+80/86.5/118
	_PC_ADV		; skip opcode
	LDX #$10	; offset
	JMP intr80	; calling procedure

_df:
; RST 3 (11, 12 @ 8085)
;+80/86.5/118
	_PC_ADV		; skip opcode
	LDX #$18	; offset
	JMP intr80	; calling procedure

_e7:
; RST 4 (11, 12 @ 8085)
;+80/86.5/118
	_PC_ADV		; skip opcode
	LDX #$20	; offset
	JMP intr80	; calling procedure

_ef:
; RST 5 (11, 12 @ 8085)
;+80/86.5/118
	_PC_ADV		; skip opcode
	LDX #$28	; offset
	JMP intr80	; calling procedure

_f7:
; RST 6 (11, 12 @ 8085)
;+80/86.5/118
	_PC_ADV		; skip opcode
	LDX #$30	; offset
	JMP intr80	; calling procedure

_ff:
; RST 7 (11, 12 @ 8085)
;+80/86.5/118
	_PC_ADV		; skip opcode
	LDX #$38	; offset
	JMP intr80	; calling procedure


; ** stack **

_c5:
; PUSH B (11, 13 @ 8085) BE
;+62/68.5/75
	LDA b80		; load data word
	LDX c80
	BRA phcnt	; push and continue

_d5:
; PUSH D (11, 13 @ 8085) DE
;+62/68.5/75
	LDA d80		; load data word
	LDX e80
	BRA phcnt	; push and continue

_e5:
; PUSH H (11, 13 @ 8085) HL
;+62/68.5/75
	LDA h80		; load data word
	LDX l80
	BRA phcnt	; push and continue

_f5:
; PUSH PSW (11, 12! @ 8085) AF
;+59/65.5/72
	LDA a80		; load data word
	LDX f80
phcnt:
	JSR push	; put in stack ** might optimise against interrupts
	JMP next_op	; flags unaffected

_c1:
; POP B (10) BC
;+52/62/72
	JSR pop		; retrieve from stack
	STA b80		; store MSB
	STX c80		; store LSB
	JMP next_op

_d1:
; POP D (10) DE
;+52/62/72
	JSR pop		; retrieve from stack
	STA d80		; store MSB
	STX e80		; store LSB
	JMP next_op

_e1:
; POP H (10) HL
;+52/62/72
	JSR pop		; retrieve from stack
	STA h80		; store MSB
	STX l80		; store LSB
	JMP next_op

_f1:
; POP PSW (10) AF
;+49/59/69
	JSR pop		; retrieve from stack
	STA a80		; store MSB
	STX f80		; store LSB
	JMP next_op

_e3:
; XTHL (18, 16 @ 8085) exchange HL with top of stack
;+117/133.5/150, could be optimised
	JSR pop		; get top of stack
	STX tmptr	; store temporarily
	STA tmptr+1
	LDA h80		; original HL contents
	LDX l80
	JSR push	; put on stack
	LDX tmptr	; retrieve older top
	LDA tmptr+1
	STA h80		; new HL contents
	STX l80
	JMP next_op

_f9:
; SPHL (5, 6 @ 8085) set SP as HL
;+20/20.5/21
	LDA h80		; get HL word
	LDX l80
	_AH_BOUND		; eeeeeek
	STA sp80+1	; set SP
	STX sp80
	JMP next_op

_33:
; INX SP (5, 6 @ 8085)
;+11/17.5/24
	INC sp80	; increment SP LSB
	BNE xsend	; no wrap
		LDA sp80+1	; get MSB
		INC
		_AH_BOUND		; just in case
		STA sp80+1	; update MSB 
xsend:
	JMP next_op	; flags unaffected

_3b:
; DCX SP (5, 6 @ 8085)
;+14/20.5/27
	LDX sp80	; preload LSB
	BNE dcxn	; will not wrap
		LDA sp80+1	; original MSB
		DEC		; correct MSB otherwise
		_AH_BOUND	; just in case
		STA sp80+1
dcxn:
	DEC sp80	; decrement LSB
	JMP next_op


; ** control **

_fb:
; EI (4)
;+8
; ***** actually delays enabling for one instruction! *****
	SMB3 rimask	; enable interrupts
	JMP next_op

_f3:
; DI (4)
;+8
	RMB3 rimask	; disable interrupts
	JMP next_op

_76:
; HLT (7, 5 @ 8085)
; abort emulation and return to shell...
; ...since interrupts are not yet supported!
	LDY cdev	; console device
	_KERNEL(FREE_W)	; release device or window
	_FINISH			; *** go away *** new interface


; ** specials **

_2f:
; CMA (4) complement A
;+11
	LDA a80		; get accumulator
	EOR #$FF	; complement
	STA a80		; update
	JMP next_op

_37:
; STC (4) set carry
;+8
	SMB0 f80	; easiest way in Intel CPUs
	JMP next_op

_3f:
; CMC (4) complement carry
;+11
	LDA f80		; status
	EOR #%00000001	; invert C
	STA f80		; update status
	JMP next_op

_27:
; DAA (4) decimal adjust
;+54/~70.5/87#
	LDA a80		; binary value
	TAX		; worth saving
		BBS4 f80, lp6	; halfcarry was set, add 6
	AND #$0F	; low nibble
	CMP #10		; BCD valid?
		BCS llp6	; if not, reload value and add 6
daah:
	TXA		; reload current value
		BBS0 f80, hp6	; normal carry was set, add 6 to hi nibble
	AND #$F0	; hi nibble
	CMP #10		; valid BCD?
	BCC daac	; OK, do not add anything
		TXA		; A was lost
hp6:
		CLC
		ADC #$60	; add 6 to hi nibble, might set native C
		STA a80		; update value!
		TAX		; right value
daac:
	BCC daa_nc	; no final carry
		SMB0 f80	; or set C
daa_nc:
	JMP i_szp		; check flags and exit (18)

; pseudo-routine for low nibble
llp6:
	TXA		; reload as was masked
lp6:
	CLC
	ADC #6	; correct low nibble
	STA a80		; update
	TXA		; get older value*******not sure about H
	EOR a80		; check differences
	AND #%00001000	; looking for bit 3
	BEQ lp_nh	; no change, no half carry
		SMB4 f80	; or set H
lp_nh:
	LDX a80		; retrieve value
	BRA daah	; and try next nibble


; ** input/output **
; * might be trapped easily *

_db:
; IN (10)
;+22/22/47
	_PC_ADV		; go for address
	LDA (pc80), Y	; get port
	TAX
	LDA IO_BASE, X	; actual port access
	STA a80		; gets into A
	JMP next_op	; flags unaffected

_d3:
; OUT (10)
;+22/22/47
	_PC_ADV		; go for address
	LDA (pc80), Y	; get port
	TAX
	LDA a80		; take data from A
	STA IO_BASE, X	; actual port access
	JMP next_op	; flags unaffected


; ** new 8085 instructions **

_20:
; RIM (4) read interrupt mask
;+11
	LDA rimask	; get data
	AND #%01111111	; no serial input this far...
	STA a80		; transfer to A
	JMP next_op	; anything else?

_30:
; SIM (4) set interrupt mask
;+16/25.5/35
	LDA a80		; get argument
	BIT #%00010000	; check bit 4
	BEQ sim_r7	; will not clear I7.5
		RMB6 rimask	; otherwise reset it
sim_r7:
	BIT #%00001000	; check bit 3
	BEQ sim_m	; no mask change
		AND #%00000111	; otherwise filter new masks
		STA tmptr	; save them
		LDA rimask	; older values
		AND #%11111000	; delete older
		ORA tmptr	; put new ones
		STA rimask	; update
sim_m:
	JMP next_op	; anything else?

	
;** rotate **

_07:
; RLC (4) rotate A left, Z80 needs older version of rots
; +23
	LSR f80		; lose C
	LDA a80		; check bit 7
	ASL		; if one, set native carry
	ROL a80		; rotate register
	ROL f80		; restore new C
	JMP next_op

_0f:
; RRC (4) rotate A right
;+23
	LSR f80		; lose C
	LDA a80		; temporary check
	LSR		; copy bit 0 in native C
	ROR a80		; rotate register
	ROL f80		; restore new C
	JMP next_op

_17:
; RAL (4) rotate A left thru carry
;+18
	LSR f80		; copy C on native
	ROL a80		; rotate register
	ROL f80		; return status with updated carry
	JMP next_op

_1f:
; RAR (4) rotate A right thru carry
;+18
	LSR f80		; copy C on native
	ROR a80		; rotate register
	ROL f80		; return status with updated carry
	JMP next_op


; ** increment & decrement **

_34:
; INR M (10!)
;+58/60.5/63
; affects all but C
	_MEMORY		; prepare pointer
	LDA (tmptr)	; older value
	INC		; operation
	TAX		; FINAL result for further testing, status OK
	STA (tmptr)	; and update memory
iflags:
	RMB4 f80	; reset H (+27/29/31)
	TXA		; retrieve value
	AND #$0F	; filter low nibble
	BNE i_szp	; not zero, could not set H
		SMB4 f80	; ...or set H
i_szp:
	LDA f80		; get previous status (+15)
	AND #%00111011	; reset SZP, H already checked
x_szp:
	ORA szp_lut, X	; set appropriate flags! (+10)
	STA f80		; update status
	JMP next_op

_04:
; INR B (5, 4 @ 8085)
;+38/40/42
	INC b80
	LDX b80		; appropriate register
	BRA iflags	; common ending

_0c:
; INR C (5, 4 @ 8085)
;+38/40/42
	INC c80
	LDX c80		; appropriate register
	BRA iflags	; common ending

_14:
; INR D (5, 4 @ 8085)
;+38/40/42
	INC d80
	LDX d80		; appropriate register
	BRA iflags	; common ending

_1c:
; INR E (5, 4 @ 8085)
;+38/40/42
	INC e80
	LDX e80		; appropriate register
	BRA iflags	; common ending

_24:
; INR H (5, 4 @ 8085)
;+38/40/42
	INC h80
	LDX h80		; appropriate register
	BRA iflags	; common ending

_2c:
; INR L (5, 4 @ 8085)
;+38/40/42
	INC l80
	LDX l80		; appropriate register
	BRA iflags	; common ending

_3c:
; INR A (5, 4 @ 8085)
;+38/40/42
	INC a80
	LDX a80		; appropriate register
	BRA iflags	; common ending

_35:
; DCR M (10!)
;+58/62/66
; affects all but C
	_MEMORY		; prepare pointer
	LDA (tmptr)	; older value
	DEC		; operation
	TAX		; FINAL result for further testing, status OK
	STA (tmptr)	; and update memory
dflags:
	RMB4 f80	; reset H (+27/30.5/34)
	TXA		; retrieve value
	AND #$0F	; filter low nibble
	BNE i_szp	; not zero, could not set H
		SMB4 f80	; ...or set H
	BRA i_szp	; common ending

_05:
; DCR B (5, 4 @ 8085)
;+38/41.5/45
	DEC b80
	LDX b80		; appropriate register
	BRA dflags	; common ending

_0d:
; DCR C (5, 4 @ 8085)
;+38/41.5/45
	DEC c80
	LDX c80		; appropriate register
	BRA dflags	; common ending

_15:
; DCR D (5, 4 @ 8085)
;+38/41.5/45
	DEC d80
	LDX d80		; appropriate register
	BRA dflags	; common ending

_1d:
; DCR E (5, 4 @ 8085)
;+38/41.5/45
	DEC e80
	LDX e80		; appropriate register
	BRA dflags	; common ending

_25:
; DCR H (5, 4 @ 8085)
;+38/41.5/45
	DEC h80
	LDX h80		; appropriate register
	BRA dflags	; common ending

_2d:
; DCR L (5, 4 @ 8085)
;+38/41.5/45
	DEC l80
	LDX l80		; appropriate register
	BRA dflags	; common ending

_3d:
; DCR A (5, 4 @ 8085)
;+38/41.5/45
	DEC a80
	LDX a80		; appropriate register
	BRA dflags	; common ending

; 16-bit inc/dec 

_03:
; INX B (5, 6 @ 8085)
;+11/13/15
	INC c80	; increment LSB
	BNE ixb	; no wrap
		INC b80	; correct MSB
ixb:
	JMP next_op	; flags unaffected

_0b:
; DCX B (5, 6 @ 8085)
;+14/16/18
	LDX c80	; preload LSB
	BNE dxb	; will not wrap
		DEC b80	; correct MSB otherwise
dxb:
	DEC c80	; decrement LSB
	JMP next_op

_13:
; INX D (5, 6 @ 8085)
;+11/13/15
	INC e80	; increment LSB
	BNE ixd	; no wrap
		INC d80	; correct MSB
ixd:
	JMP next_op	; flags unaffected

_1b:
; DCX D (5, 6 @ 8085)
;+14/16/18
	LDX e80	; preload LSB
	BNE dxd	; will not wrap
		DEC d80	; correct MSB otherwise
dxd:
	DEC e80	; decrement LSB
	JMP next_op

_23:
; INX H (5, 6 @ 8085)
;+11/13/15
	INC l80	; increment LSB
	BNE ixh	; no wrap
		INC h80	; correct MSB
ixh:
	JMP next_op	; flags unaffected

_2b:
; DCX H (5, 6 @ 8085)
;+14/16/18
	LDX l80	; preload LSB
	BNE dxh	; will not wrap
		DEC h80	; correct MSB otherwise
dxh:
	DEC l80	; decrement LSB
	JMP next_op


; ** logical **

; and

_a0:
; ANA B (4)
;+34
	LDA b80		; variable term
	BRA anam	; generic routine

_a1:
; ANA C (4)
;+34
	LDA c80		; variable term
	BRA anam	; generic routine

_a2:
; ANA D (4)
;+34
	LDA d80		; variable term
	BRA anam	; generic routine

_a3:
; ANA E (4)
;+34
	LDA e80		; variable term
	BRA anam	; generic routine

_a4:
; ANA H (4)
;+34
	LDA h80		; variable term
	BRA anam	; generic routine

_a5:
; ANA L (4)
;+34
	LDA l80		; variable term
	BRA anam	; generic routine

_a6:
; ANA M (7)
;+50/50.5/51
; ***** WARNING, 8085 (and Z80?) sets H, but 8080 computes old.d3 OR new.d3 for H *****
; ***** Logic ops clear C (at least ANA/ANI) *****
	_MEMORY		; prepare pointer
	LDA (tmptr)	; variable term
anam:
	AND a80		; logical AND (+28)
	STA a80		; store result
	TAX		; keep final result
	LDA f80		; get old flags
	AND #%00111010	; reset S, Z, P & C, ANA specific masks
	ORA #%00010000	; set H... 8085 behaviour
	JMP x_szp	; common flag set & exit

_a7:
; ANA A (4) somewhat special as will only update flags! not worth
; +34
	LDA a80		; original intact data
	BRA anam

; and immediate

_e6:
; ANI (7)
;+41/41/66
	_PC_ADV		; go for the operand
	LDA (pc80), Y	; immediate addressing
	BRA anam	; generic routine

; exclusive or

_a8:
; XRA B (4)
;+32
	LDA b80		; variable term
	BRA xram	; generic routine

_a9:
; XRA C (4)
;+32
	LDA c80		; variable term
	BRA xram	; generic routine

_aa:
; XRA D (4)
;+32
	LDA d80		; variable term
	BRA xram	; generic routine

_ab:
; XRA E (4)
;+32
	LDA e80		; variable term
	BRA xram	; generic routine

_ac:
; XRA H (4)
;+32
	LDA h80		; variable term
	BRA xram	; generic routine

_ad:
; XRA L (4)
;+32
	LDA l80		; variable term
	BRA xram	; generic routine

_ae:
; XRA M (7) with parity instead of overflow!
;+48/48.5/49
; ***** clears C & H *****
	_MEMORY		; prepare pointer
	LDA (tmptr)	; variable term
xram:
	EOR a80		; exclusive OR (+26)
l_flags:
	STA a80		; store result (+23)
	TAX		; keep final result
	LDA f80		; get old flags
	AND #%00101010	; reset S, Z, H, P & C
	JMP x_szp	; common flag set & exit

_af:
; XRA A (4) will always get zero, worth optimising as a quick way to zero A
;+16
	LDA f80		; get old flags
	AND #%01101110	; reset S, H & C
	ORA #%01000100	; set Z & P
	STA f80		; store base flags
	STZ a80		; result is always zero!
	JMP next_op

; or

_b6:
; ORA M (7)
;+51/51.5/52
;***** resets C & H ***
	_MEMORY		; prepare pointer
	LDA (tmptr)	; variable term
oram:
	ORA a80		; logical OR (+29)
	BRA l_flags	; store & check flags

; exclusive or immediate

_ee:
; XRI (7)
;+39/39/64
	_PC_ADV		; go for the operand
	LDA (pc80), Y	; immediate addressing
	BRA xram	; generic routine (54/112.5/130)

_b0:
; ORA B (4)
;+35
	LDA b80		; variable term
	BRA oram	; generic routine

_b1:
; ORA C (4)
;+35
	LDA c80		; variable term
	BRA oram	; generic routine

_b2:
; ORA D (4)
;+35
	LDA d80		; variable term
	BRA oram	; generic routine

_b3:
; ORA E (4)
;+35
	LDA e80		; variable term
	BRA oram	; generic routine

_b4:
; ORA H (4)
;+35
	LDA h80		; variable term
	BRA oram	; generic routine

_b5:
; ORA L (4)
;+35
	LDA l80		; variable term
	BRA oram	; generic routine

_b7:
; ORA A (4) not really the same as AND A (this clears H)
;+35
	LDA a80		; variable term
	BRA oram	; generic routine

; or immediate

_f6:
; ORI (7)
;+42/42/67
	_PC_ADV		; go for the operand
	LDA (pc80), Y	; immediate addressing
	BRA oram	; generic routine

; compare with A

_b8:
; CMP B (4)
;+61/67/73
	LDA b80		; variable term
	BRA cmpm	; generic routine

_b9:
; CMP C (4)
;+61/67/73
	LDA c80		; variable term
	BRA cmpm	; generic routine

_ba:
; CMP D (4)
;+61/67/73
	LDA d80		; variable term
	BRA cmpm	; generic routine

_bb:
; CMP E (4)
;+61/67/73
	LDA e80		; variable term
	BRA cmpm	; generic routine

_bc:
; CMP H (4)
;+61/67/73
	LDA h80		; variable term
	BRA cmpm	; generic routine

_bd:
; CMP L (4)
;+61/67/73
	LDA l80		; variable term
	BRA cmpm	; generic routine

_be:
; CMP M (7)
;+77/83.5/90
	_MEMORY		; prepare pointer
	LDA (tmptr)	; variable term
cmpm:
	STA tmptr	; keep first operand! (+55/61/67)
	LDA a80		; have a look at accumulator
	STA tmptr+1	; store second operand!
	SEC		; prepare subtraction
	SBC tmptr	; subtract without storing
	TAX		; keep final result
	LDA #%00010001	; mask for H & C
	TRB f80	; clear them! eeeeeeek
	BCS cmp_c	; if native carry is set, there is NO borrow
		SMB0 f80	; otherwise set emulated C
cmp_c:
	TXA		; restore result for H computation!
	EOR tmptr	; exclusive OR of result with both operands
	EOR tmptr+1
	AND #%00010000	; just look at bit 4
	BEQ cmp_h	; no half carry if zero
		TSB f80	; or set H, A already was %00010000
cmp_h:
	JMP i_szp	; update flags and continue (18)

_bf:
; CMP A (4) special
;+13
	LDA f80		; old flags
	AND #%01101010	; clear S, H, P & C
	ORA #%01000000	; set Z!
	STA f80		; store flags
	JMP next_op

; compare A immediate

_fe:
; CPI (7)
;+68/74/105
	_PC_ADV		; go for the operand
	LDA (pc80), Y	; immediate addressing
	BRA cmpm	; generic routine


; ** addition **

; without carry

_86:
; ADD M (7)
;+82/87.5/93
	_MEMORY		; prepare pointer
	LDA (tmptr)	; variable term
addm:
	STA tmptr	; keep first operand! (+60/65/70)
	LDA a80		; look at accumulator
	STA tmptr+1	; keep second
	CLC		; ignore previous carry
	ADC tmptr	; addition
	STA a80		; store result
	TAX		; keep final result
	LDA #%00010001	; mask for H & C
	TRB f80	; clear them! eeeeeeek
	BCC a_flags	; no carry was generated
		SMB0 f80	; or set C
a_flags:
	TXA		; restore result for H computation! (+31/33/35)
	EOR tmptr	; exclusive OR on three values
	EOR tmptr+1
	AND #%00010000	; bit 4 only
	BEQ add_h	; no change, no halfcarry
		TSB f80	; or set H, A already was %00010000
add_h:
	JMP i_szp	; update flags and continue (18)

_80:
; ADD B (4)
;+66/71/76
	LDA b80		; appropriate register
	BRA addm	; common routine

_81:
; ADD C (4)
;+66/71/76
	LDA c80		; appropriate register
	BRA addm	; common routine

_82:
; ADD D (4)
;+66/71/76
	LDA d80		; appropriate register
	BRA addm	; common routine

_83:
; ADD E (4)
;+66/71/76
	LDA e80		; appropriate register
	BRA addm	; common routine

_84:
; ADD H (4)
;+66/71/76
	LDA h80		; appropriate register
	BRA addm	; common routine

_85:
; ADD L (4)
;+66/71/76
	LDA l80		; appropriate register
	BRA addm	; common routine

_87:
; ADD A (4), worth optimising? rot left, if C then toggle H, should recheck SZ & H
;+66/71/76
	LDA a80		; appropriate register
	BRA addm	; common routine

; immediate

_c6:
; ADI (7)
;+73/78/108
	_PC_ADV		; go for the operand
	LDA (pc80), Y	; immediate addressing
	BRA addm	; generic routine

; with carry

_8e:
; ADC M (7)
;+88/90.5/93
	_MEMORY		; prepare pointer
	LDA (tmptr)	; variable term
adcm:
	STA tmptr	; keep first operand! (+66/68/70)
	LDA f80		; get old flags
	LSR		; transfer emulated C on native carry! 
	AND #%01110111	; clear H, note shift
	STA f80		; store base flags
	LDA a80		; look at accumulator
	STA tmptr+1	; keep second
	ADC tmptr	; addition with carry
	STA a80		; store result
	TAX		; here too! eeeek
	ROL f80		; restore flags with result C
	JMP a_flags	; continue (34/36/38)

_88:
; ADC B (4)
;+72/74/76
	LDA b80		; appropriate register
	BRA adcm

_89:
; ADC C (4)
;+72/74/76
	LDA c80		; appropriate register
	BRA adcm

_8a:
; ADC D (4)
;+72/74/76
	LDA d80		; appropriate register
	BRA adcm

_8b:
; ADC E (4)
;+72/74/76
	LDA e80		; appropriate register
	BRA adcm

_8c:
; ADC H (4)
;+72/74/76
	LDA h80		; appropriate register
	BRA adcm

_8d:
; ADC L (4)
;+72/74/76
	LDA l80		; appropriate register
	BRA adcm

_8f:
; ADC A (4) might optimise as emulated C is OK for rots
;+72/74/76
	LDA a80		; appropriate register
	BRA adcm

; immediate

_ce:
; ACI (7)
;+79/81/108
	_PC_ADV		; go for the operand
	LDA (pc80), Y	; immediate addressing
	BRA adcm	; generic routine

_09:
; DAD B (10)
;+27
;***** affects just C *****
	LSR f80		; move C to native carry
	LDA l80		; add LSB
	ADC c80
	STA l80		; store
	LDA h80		; same for MSB
	ADC b80
	STA h80
	ROL f80		; restore emulated C flag
	JMP next_op

_19:
; DAD D (10)
;+27
	LSR f80		; move C to native carry
	LDA l80		; add LSB
	ADC e80
	STA l80		; store
	LDA h80		; same for MSB
	ADC d80
	STA h80
	ROL f80		; restore emulated C flag
	JMP next_op

_29:
; DAD H (10)
;+27
	LSR f80		; move C to native carry
	LDA l80		; add LSB
	ADC l80
	STA l80		; store
	LDA h80		; same for MSB
	ADC h80
	STA h80
	ROL f80		; restore emulated C flag
	JMP next_op

_39:
; DAD SP (10)
;+27
	LSR f80		; move C to native carry
	LDA l80		; add LSB
	ADC sp80
	STA l80		; store
	LDA h80		; same for MSB
	ADC sp80+1
	STA h80
	ROL f80		; restore emulated C flag
	JMP next_op

; ** subtract **

_90:
; SUB B (4)
;+69/74/79
	LDA b80		; get register
	BRA subm	; common code

_91:
; SUB C (4)
;+69/74/79
	LDA c80		; get register
	BRA subm	; common code

_92:
; SUB D (4)
;+69/74/79
	LDA d80		; get register
	BRA subm	; common code

_93:
; SUB E (4)
;+69/74/79
	LDA e80		; get register
	BRA subm	; common code

_94:
; SUB H (4)
;+69/74/79
	LDA h80		; get register
	BRA subm	; common code

_95:
; SUB L (4)
;+69/74/79
	LDA l80		; get register
	BRA subm	; common code

_96:
; SUB M (7)
;+85/90.5/96
	_MEMORY			; prepare pointer
	LDA (tmptr)		; variable term
subm:
	STA tmptr	; keep first operand! (+63/68/73)
	LDA a80		; look at accumulator
	STA tmptr+1	; keep second
	SEC		; ignore previous carry
	SBC tmptr	; subtraction
	STA a80		; store result
s_flags:
	TAX		; keep final result (+46/51/56)
	LDA #%00010001	; mask for H & C
	TRB f80	; clear them! eeeeeeek
	BCS s_nb	; no borrow was generated
		SMB0 f80	; or set C
s_nb:
	JMP a_flags	; continue with rest of flags (34/36/38)

_97:
; SUB A (4) special as always returns zero
;+13
	LDA f80		; get flags
	AND #%01101110	; clear S, H & C
	ORA #%01000100	; set Z & P
	STZ a80		; clear A
	JMP next_op

; immediate

_d6:
; SUI (7)
;+76/81/111
	_PC_ADV		; go for the operand
	LDA (pc80), Y	; immediate addressing
	BRA subm	; generic routine

; * with borrow *

_98:
; SBB B (4)
;+85/90.5/96
	LDA b80		; get register
	BRA sbbm	; common code

_99:
; SBB C (4)
;+85/90.5/96
	LDA c80		; get register
	BRA sbbm	; common code

_9a:
; SBB D (4)
;+85/90.5/96
	LDA d80		; get register
	BRA sbbm	; common code

_9b:
; SBB E (4)
;+85/90.5/96
	LDA e80		; get register
	BRA sbbm	; common code

_9c:
; SBB H (4)
;+85/90.5/96
	LDA h80		; get register
	BRA sbbm	; common code

_9d:
; SBB L (4)
;+85/90.5/96
	LDA l80		; get register
	BRA sbbm	; common code

_9e:
; SBB M (7)
;+101/107/113
	_MEMORY			; prepare pointer
	LDA (tmptr)		; variable term
sbbm:
	STA tmptr		; keep first operand! (+79/84.5/90)
	LDA f80			; old flags
	SEC
	BIT #%00000001	; check original C
	BNE sbb_c		; if set, no borrow! eeeeek
		CLC				; native carry
sbb_c:
	AND #%00101010	; clear SZHPC
	STA f80			; store base flags
	LDA a80			; look at accumulator
	STA tmptr+1		; keep second
	SBC tmptr		; subtraction
	STA a80			; store result
	JMP s_flags		; common end (49/54/59)

_9f:
; SBB A (4) result depends on C, not worth optimising
;+85/90.5/96
	LDA a80		; get register
	BRA sbbm	; common code

; immediate

_de:
; SBI (7)
;+92/97.5/128
	_PC_ADV		; go for the operand
	LDA (pc80), Y	; immediate addressing
	BRA sbbm	; generic routine


; *** LUT for S, Z & P status bits directly based on result as index ***
szp_lut:
	.byt	%01000100, %000, %000, %100, %000, %100, %100, %000	; zero to 7
	.byt		%000, %100, %100, %000, %100, %000, %000, %100	; 8-15
	.byt		%000, %100, %100, %000, %100, %000, %000, %100	; 16-23
	.byt		%100, %000, %000, %100, %000, %100, %100, %000	; 24-31
	.byt		%000, %100, %100, %000, %100, %000, %000, %100	; 32-39
	.byt		%100, %000, %000, %100, %000, %100, %100, %000	; 40-47
	.byt		%100, %000, %000, %100, %000, %100, %100, %000	; 48-55
	.byt		%000, %100, %100, %000, %100, %000, %000, %100	; 56-63
	.byt		%000, %100, %100, %000, %100, %000, %000, %100	; 64-71
	.byt		%100, %000, %000, %100, %000, %100, %100, %000	; 72-79
	.byt		%100, %000, %000, %100, %000, %100, %100, %000	; 80-87
	.byt		%000, %100, %100, %000, %100, %000, %000, %100	; 88-95
	.byt		%100, %000, %000, %100, %000, %100, %100, %000	; 96-103
	.byt		%000, %100, %100, %000, %100, %000, %000, %100	; 104-111
	.byt		%000, %100, %100, %000, %100, %000, %000, %100	; 112-119
	.byt		%100, %000, %000, %100, %000, %100, %100, %000	; 120-127
	.byt	$80, $84, $84, $80, $84, $80, $80, $84	; negative, 128-135
	.byt	$84, $80, $80, $84, $80, $84, $84, $80	; 136-143
	.byt	$84, $80, $80, $84, $80, $84, $84, $80	; 144-151
	.byt	$80, $84, $84, $80, $84, $80, $80, $84	; 152-159
	.byt	$84, $80, $80, $84, $80, $84, $84, $80	; 160-167
	.byt	$80, $84, $84, $80, $84, $80, $80, $84	; 168-175
	.byt	$80, $84, $84, $80, $84, $80, $80, $84	; 176-183
	.byt	$84, $80, $80, $84, $80, $84, $84, $80	; 184-191
	.byt	$84, $80, $80, $84, $80, $84, $84, $80	; 192-199
	.byt	$80, $84, $84, $80, $84, $80, $80, $84	; 200-207
	.byt	$80, $84, $84, $80, $84, $80, $80, $84	; 208-215
	.byt	$84, $80, $80, $84, $80, $84, $84, $80	; 216-223
	.byt	$80, $84, $84, $80, $84, $80, $80, $84	; 224-231
	.byt	$84, $80, $80, $84, $80, $84, $84, $80	; 232-239
	.byt	$84, $80, $80, $84, $80, $84, $84, $80	; 240-247
	.byt	$80, $84, $84, $80, $84, $80, $80, $84	; 248-255


; *** opcode execution addresses table ***
; should stay no matter the CPU!
opt_l:
	.word	_00
	.word	_01
	.word	_02
	.word	_03
	.word	_04
	.word	_05
	.word	_06
	.word	_07
	.word	_08
	.word	_09
	.word	_0a
	.word	_0b
	.word	_0c
	.word	_0d
	.word	_0e
	.word	_0f
	.word	_10
	.word	_11
	.word	_12
	.word	_13
	.word	_14
	.word	_15
	.word	_16
	.word	_17
	.word	_18
	.word	_19
	.word	_1a
	.word	_1b
	.word	_1c
	.word	_1d
	.word	_1e
	.word	_1f
	.word	_20
	.word	_21
	.word	_22
	.word	_23
	.word	_24
	.word	_25
	.word	_26
	.word	_27
	.word	_28
	.word	_29
	.word	_2a
	.word	_2b
	.word	_2c
	.word	_2d
	.word	_2e
	.word	_2f
	.word	_30
	.word	_31
	.word	_32
	.word	_33
	.word	_34
	.word	_35
	.word	_36
	.word	_37
	.word	_38
	.word	_39
	.word	_3a
	.word	_3b
	.word	_3c
	.word	_3d
	.word	_3e
	.word	_3f
	.word	_40
	.word	_41
	.word	_42
	.word	_43
	.word	_44
	.word	_45
	.word	_46
	.word	_47
	.word	_48
	.word	_49
	.word	_4a
	.word	_4b
	.word	_4c
	.word	_4d
	.word	_4e
	.word	_4f
	.word	_50
	.word	_51
	.word	_52
	.word	_53
	.word	_54
	.word	_55
	.word	_56
	.word	_57
	.word	_58
	.word	_59
	.word	_5a
	.word	_5b
	.word	_5c
	.word	_5d
	.word	_5e
	.word	_5f
	.word	_60
	.word	_61
	.word	_62
	.word	_63
	.word	_64
	.word	_65
	.word	_66
	.word	_67
	.word	_80
	.word	_69
	.word	_6a
	.word	_6b
	.word	_6c
	.word	_6d
	.word	_6e
	.word	_6f
	.word	_70
	.word	_71
	.word	_72
	.word	_73
	.word	_74
	.word	_75
	.word	_76
	.word	_77
	.word	_78
	.word	_79
	.word	_7a
	.word	_7b
	.word	_7c
	.word	_7d
	.word	_7e
	.word	_7f
opt_h:
	.word	_80
	.word	_81
	.word	_82
	.word	_83
	.word	_84
	.word	_85
	.word	_86
	.word	_87
	.word	_88
	.word	_89
	.word	_8a
	.word	_8b
	.word	_8c
	.word	_8d
	.word	_8e
	.word	_8f
	.word	_90
	.word	_91
	.word	_92
	.word	_93
	.word	_94
	.word	_95
	.word	_96
	.word	_97
	.word	_98
	.word	_99
	.word	_9a
	.word	_9b
	.word	_9c
	.word	_9d
	.word	_9e
	.word	_9f
	.word	_a0
	.word	_a1
	.word	_a2
	.word	_a3
	.word	_a4
	.word	_a5
	.word	_a6
	.word	_a7
	.word	_a8
	.word	_a9
	.word	_aa
	.word	_ab
	.word	_ac
	.word	_ad
	.word	_ae
	.word	_af
	.word	_b0
	.word	_b1
	.word	_b2
	.word	_b3
	.word	_b4
	.word	_b5
	.word	_b6
	.word	_b7
	.word	_b8
	.word	_b9
	.word	_ba
	.word	_bb
	.word	_bc
	.word	_bd
	.word	_be
	.word	_bf
	.word	_c0
	.word	_c1
	.word	_c2
	.word	_c3
	.word	_c4
	.word	_c5
	.word	_c6
	.word	_c7
	.word	_c8
	.word	_c9
	.word	_ca
	.word	_cb
	.word	_cc
	.word	_cd
	.word	_ce
	.word	_cf
	.word	_d0
	.word	_d1
	.word	_d2
	.word	_d3
	.word	_d4
	.word	_d5
	.word	_d6
	.word	_d7
	.word	_d8
	.word	_d9
	.word	_da
	.word	_db
	.word	_dc
	.word	_dd
	.word	_de
	.word	_df
	.word	_e0
	.word	_e1
	.word	_e2
	.word	_e3
	.word	_e4
	.word	_e5
	.word	_e6
	.word	_e7
	.word	_e8
	.word	_e9
	.word	_ea
	.word	_eb
	.word	_ec
	.word	_ed
	.word	_ee
	.word	_ef
	.word	_f0
	.word	_f1
	.word	_f2
	.word	_f3
	.word	_f4
	.word	_f5
	.word	_f6
	.word	_f7
	.word	_f8
	.word	_f9
	.word	_fa
	.word	_fb
	.word	_fc
	.word	_fd
	.word	_fe
	.word	_ff
	
