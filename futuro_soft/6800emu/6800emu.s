; 6800 emulator for minimOS!
; v0.1a3
; (c) 2016 Carlos J. Santisteban
; last modified 20160203

#include "../../OS/options.h"	; machine specific
#include "../../OS/macros.h"
#include "../../OS/abi.h"		; ** new filename **
.zero
#include "../../OS/zeropage.h"
.bss
#include "../../OS/firmware/firmware.h"	; machine specific
#include "../../OS/sysvars.h"
.text

; ** some useful macros **
; these need to be used in xa65, might go into macros.h
#define	RMB0	RMB #0,
#define RMB1	RMB #1,
#define RMB2	RMB #2,
#define RMB3	RMB #3,
#define RMB4	RMB #4,
#define RMB5	RMB #5,
#define RMB6	RMB #6,
#define RMB7	RMB #7,
#define SMB0	SMB #0,
#define SMB1	SMB #1,
#define SMB2	SMB #2,
#define SMB3	SMB #3,
#define SMB4	SMB #4,
#define SMB5	SMB #5,
#define SMB6	SMB #6,
#define SMB7	SMB #7,
; these almost got me nuts!
#define BBR0	BBR #0,
#define BBR1	BBR #1,
#define BBR2	BBR #2,
#define BBR3	BBR #3,
#define BBR4	BBR #4,
#define BBR5	BBR #5,
#define BBR6	BBR #6,
#define BBR7	BBR #7,
#define BBS0	BBS #0,
#define BBS1	BBS #1,
#define BBS2	BBS #2,
#define BBS3	BBS #3,
#define BBS4	BBS #4,
#define BBS5	BBS #5,
#define BBS6	BBS #6,
#define BBS7	BBS #7,

; these make listings more succint
; inject address MSB into 16+16K space (5/5.5/6)
#define	_AH_BOUND	AND #%10111111: BMI *+4: ORA #%01000000
; increase Y checking injected boundary crossing (5/5/18)
#define	_PC_ADV		INY: BNE *+13: LDA pc68+1: INC: _AH_BOUND: STA pc68+1
; compute pointer for indexed addressing mode (31/32/45)
#define	_INDEXED	_PC_ADV: LDA (pc68), Y: CLC: ADC x68: STA tmptr: LDA x68+1: ADC #0: _AH_BOUND: STA tmptr+1
; compute pointer for extended addressing mode (31/32.5/45)
#define	_EXTENDED	_PC_ADV: LDA (pc68), Y: _AH_BOUND: STA tmptr+1: _PC_ADV: LDA (pc68), Y: STA tmptr
; compute pointer (as X index) for direct addressing mode (12/12/25)
#define	_DIRECT		_PC_ADV: LDA (pc68), Y: TAX

; check Z & N flags (6/10/14)
#define _CC_NZ		BNE *+4: SMB2 ccr68: BPL *+4: SMB3 ccr68

; ** minimOS executable header will go here **

; declare zeropage addresses
tmptr	=	uz		; temporary storage (up to 16 bit)
sp68	=	uz+2	; stack pointer (16 bit, little-endian, now injected into host map)
pc68	=	uz+4	; program counter (16 bit, little-endian, injected into host map) same as stacking order
x68		=	uz+6	; index register (16 bit, little-endian)
a68		=	uz+8	; first accumulator (8 bit)
b68		=	uz+9	; second accumulator (8 bit)
ccr68	=	uz+10	; status register (8 bit)

; *** startup code, minimOS specific stuff ***
	LDA #tmptr-uz+2	; zeropage space needed
#ifdef	SAFE
	CMP z_used		; check available zeropage space
	BCC go_emu		; enough space
		_ERR(FULL)		; not enough memory otherwise (rare)
go_emu:
#endif
	STA z_used		; set required ZP space as required by minimOS
; might check here whether a Rockwell 65C02 is used!
; should try to allocate memory here

; *** start the emulation! ***
reset68:
	LDA #%11010000	; restart with interrupts masked
	STA ccr68		; store initial flags
	LDY $BFFF		; get RESET vector LSB from emulated ROM (this is big-endian!)
	LDA $BFFE		; same for MSB... but create offset!
	_AH_BOUND		; use two 16K chunks ignoring A14
	STZ pc68		; base offset is 0, Y index holds LSB
	STA pc68+1		; address fully generated
; *** main loop ***
execute:
		LDA (pc68), Y		; get opcode (needs CMOS) (5)
		ASL				; double it as will become pointer (2)
		TAX				; use as pointer, keeping carry (2)
		BCC lo_jump		; seems to be less opcodes with bit7 low... (2/3)
			JMP (optable_h, X)	; emulation routines for opcodes with bit7 hi (6)
lo_jump:
			JMP (optable_l, X)	; otherwise, emulation routines for opcodes with bit7 low
next_op:					; continue execution via JMP next_op, will not arrive here otherwise
		INY			; advance one byte (2)
		BNE execute		; fetch next instruction if no boundary is crossed (3/2)
; usual overhead is now 22+3=25 clock cycles, instead of 33
; boundary crossing **simplified version, 8 bytes, 8-15 cycles**
	INC pc68 + 1		; increase MSB otherwise, faster than using 'that macro' (5)
	BPL execute			; seems to stay in RAM area (3/2)
		RMB6 pc68 + 1		; in ROM area, A14 is goes low (5) *** Rockwell
	BRA execute			; fetch next (3)

; *** opcode execution routines, labels must match those on tables below ***
; unsupported opcodes first
_00:_02:_03:_04:_05:_12:_13:_14:_15:_18:_1a:_1c:_1d:_1e:_1f:_21:_38:_3a:_3c:_3d
_41:_42:_45:_4b:_4e:_51:_52:_55:_5b:_5e:_61:_62:_65:_6b:_71:_72:_75:_7b
_83:_87:_8f:_93:_9d:_a3:_b3:_c3:_c7:_cc:_cd:_cf:_d3:_dc:_dd:_e3:_ec:_ed:_f3:_fc:_fd

; illegal opcodes will seem to trigger an NMI!
nmi68:
	_PC_ADV			; hardware interrupts (when available) supposedly checked before incrementing PC, anyway skip illegal opcode
	SEC				; prepare subtraction
	LDA sp68		; get stack pointer LSB
	SBC #7			; make room for stack frame
	TAX				; store for later
	BCS nmi_do		; no need for further action
		LDA sp68+1		; get MSB
		DEC				; wrap
		_AH_BOUND		; keep into emulated space
		STA sp68+1		; update pointer
nmi_do:
	STX sp68		; room already made
	LDX #0			; index for register area stacking
	LDY #7			; index for stack area
nmi_loop:
		LDA pc68, X			; get one byte from register area
		STA (sp68), Y		; store in free stack space
		INX					; increase original offset
		DEY					; stack grows backwards
		BMI nmi_loop		; zero is included
	SMB4 ccr68		; mask interrupts! *** Rockwell ***
	LDY $BFFD		; get LSB from emulated NMI vector
	LDA $BFFC		; get MSB...
	_AH_BOUND		; ...but inject it into emulated space
	STA pc68 + 1	; update PC
	JMP execute		; continue with NMI handler

; valid opcode definitions
_01:
; NOP (2)
	JMP next_op	; standard end of routine (all +3 unless otherwise noted)

_06:
; TAP (2)
; +6
	LDA a68		; get A accumulator...
	STA ccr68	; ...and store it in CCR
	JMP next_op	; standard end of routine

_07:
; TPA (2)
; +6
	LDA ccr68	; get CCR...
	STA a68		; ...and store it in A
	JMP next_op	; standard end of routine

_08:
; INX (4)
; +12/12/21
	INC x68		; increase LSB
	BEQ inx_w	; wrap is a rare case
		RMB2 ccr68	; clear Z bit, *** Rockwell only! ***
		JMP next_op	; usual end
inx_w:
	INC x68 + 1	; increase MSB
	BEQ inx_z	; becoming zero is even rarer!
		RMB2 ccr68	; clear Z bit, *** Rockwell only! ***
		JMP next_op	; wrapped non-zero end (+20 in this case)
inx_z:
	SMB2 ccr68	; set Z bit, *** Rockwell only! ***
	JMP next_op	; rarest end of routine

_09:
; DEX (4)
; +17...
	LDA x68			; check LSB
	BEQ dex_w		; if zero, will wrap upon decrease!
		DEC x68			; otherwise just decrease LSB
		BEQ dex_z		; if zero now, could be all zeroes!
			RMB2 ccr68		; clear Z bit, *** Rockwell only! ***
			JMP next_op		; usual end
dex_w:
		DEC x68			; decrease as usual
		DEC x68 + 1		; wrap MSB
		RMB2 ccr68		; clear Z bit, *** Rockwell only! ***
		JMP next_op		; usual end
dex_z:
	LDA x68 + 1		; check MSB
	BEQ dex_zz		; it went down to zero!
		RMB2 ccr68		; clear Z bit, *** Rockwell only! ***
		JMP next_op		; usual end
dex_zz:
	SMB2 ccr68	; set Z bit, *** Rockwell only! ***
	JMP next_op	; rarest end of routine

_0a:
; CLV (2)
; +5
	RMB1 ccr68	; clear V bit, *** Rockwell only! ***
	JMP next_op	; standard end of routine

_0b:
; SEV (2)
; +5
	SMB1 ccr68	; set V bit, *** Rockwell only! ***
	JMP next_op	; standard end of routine

_0c:
; CLC (2)
; +5
	RMB0 ccr68	; clear C bit, *** Rockwell only! ***
	JMP next_op	; standard end of routine

_0d:
; SEC (2)
; +5
	SMB0 ccr68	; set C bit, *** Rockwell only! ***
	JMP next_op	; standard end of routine

_0e:
; CLI (2)
; +5
	RMB4 ccr68	; clear I bit, *** Rockwell only! ***
	JMP next_op	; standard end of routine

_0f:
; SEI (2)
; +5
	SMB4 ccr68	; set I bit, *** Rockwell only! ***
	JMP next_op	; standard end of routine

_10:
; SBA (2)
; +42/45.5/49
	LDA a68		; get A
	BPL sba_nm	; skip if was positive
		SMB1 ccr68	; set V like N, to be toggled later ***Rockwell***
		BRA sba_sv	; do not clear V
sba_nm:
	RMB1 ccr68	; clear V ***Rockwell***
sba_sv:
	SEC			; prepare for subtraction
	SBC b68		; minus B
	STA a68		; store result in A
	LDA ccr68	; get original flags
	LDA #%11110010	; mask out affected bits (but keep V)
	BCC sba_nc	; check for carry, will it work just like the 6502?
		INC			; will set C flag
sba_nc:
	LDX a68		; retrieve value
	BNE sba_nz	; skip if not zero
		ORA #%00000100	; set Z flag
sba_nz:
	LDX a68		; retrieve again!
	BPL sba_pl	; skip if positive
		ORA #%00001000	; set N flag
		EOR #%00000010	; toggle V flag (see above)
sba_pl:
	STA ccr68	; update flags
	JMP next_op	; standard end of routine

_11:
; CBA (2)
; +39/42.5/46
	LDA a68		; get A
	BPL cba_nm	; skip if was positive
		SMB1 ccr68	; set V like N, to be toggled later ***Rockwell***
		BRA cba_sv	; do not clear V
cba_nm:
	RMB1 ccr68	; clear V ***Rockwell***
cba_sv:
	SEC			; prepare subtraction, simulating comparison
	SBC b68		; minus B
	TAX			; store for later
	LDA ccr68	; get original flags
	LDA #%11110010	; mask out affected bits (but keep V)
	BCC cba_nc	; check for carry, will it work just like the 6502?
		INC			; will set C flag
cba_nc:
	CPX #0		; test value, hope it is OK
	BNE cba_nz	; skip if not zero
		ORA #%00000100	; set Z flag
cba_nz:
	CPX #0		; retrieve again!
	BPL cba_pl	; skip if positive
		ORA #%00001000	; set N flag
		EOR #%00000010	; toggle V flag (see above)
cba_pl:
	STA ccr68	; update status
	JMP next_op	; standard end of routine

_16:
; TAB (2)
; +20/24/28
	LDA ccr68	; get original flags
	AND #%11110001	; reset N,Z, and always V
	STA ccr68	; update status
	LDX a68		; get A
	STX b68		; store in B
	_CC_NZ		; set NZ flags when needed
	JMP next_op	; standard end of routine

_17:
; TBA (2)
; +20/24/28
	LDA ccr68	; get original flags
	AND #%11110001	; reset N,Z, and always V
	STA ccr68	; update status
	LDX b68		; get B
	STX a68		; store in A
	_CC_NZ		; check these flags
	JMP next_op	; standard end of routine

_19:
; DAA (2)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end of routine

_1b:
; ABA (2)
; +42/45.5/49
	LDA a68		; get A
	BPL aba_nm	; skip if was positive
		SMB1 ccr68	; set V like N, to be toggled later ***Rockwell***
		BRA aba_sv	; do not clear V
aba_nm:
	RMB1 ccr68	; clear V ***Rockwell***
aba_sv:
	CLC			; prepare to add
	ADC b68		; plus B
	STA a68		; store result in A
	LDA ccr68	; get original flags
	LDA #%11110010	; mask out affected bits (but keep V)
	BCC aba_nc	; check for carry, will it work just like the 6502?
		INC			; will set C flag
aba_nc:
	LDX a68		; retrieve value
	BNE aba_nz	; skip if not zero
		ORA #%00000100	; set Z flag
aba_nz:
	LDX a68		; retrieve again!
	BPL aba_pl	; skip if positive
		ORA #%00001000	; set N flag
		EOR #%00000010	; toggle V flag (see above)
aba_pl:
	STA ccr68	; update status
	JMP next_op	; standard end of routine

_20:
; BRA rel (4)
; -5+25/34.3/52
	_PC_ADV			; go for operand (5...18)
bra_do:
	SEC				; base offset is after the instruction
	LDA (pc68), Y	; check direction
	BMI bra_bk		; backwards jump
		TYA				; get current pc low
		ADC (pc68), Y	; add offset
		TAY				; new offset!!!
		BCS bra_bc		; same msb, go away
bra_go:
			JMP execute		; resume execution
bra_bc:
		INC pc68 + 1	; carry on msb
		BPL bra_lf		; skip if in low area
			RMB6 pc68+1		; otherwise clear A14
			JMP execute		; and jump
bra_lf:
		SMB6 pc68+1			; low area needs A14 set
		JMP execute
bra_bk:
	TYA				; get current pc low
	ADC (pc68), Y	; "subtract" offset
	TAY				; new offset!!!
		BCS bra_go		; all done
	DEC pc68 + 1	; borrow on msb
		BPL bra_lf		; skip if in low area
 	RMB6 pc68+1		; otherwise clear A14
	JMP execute		; and jump

_22:
; BHI rel (4)
; +11/24.8/65
	_PC_ADV				; go for operand
	BBS0 ccr68, bhi_go	; neither carry...
	BBS2 ccr68, bhi_go	; ...nor zero...
		JMP bra_do		; ...do branch
bhi_go:
	JMP next_op		; exit without branching

_23:
; BLS rel (4)
; +11...
	_PC_ADV				; go for operand
	BBS0 ccr68, bls_do	; either carry...
	BBS2 ccr68, bls_do	; ...or zero will do
		JMP next_op			; exit without branching
bls_do:
		JMP bra_do		; do branch

_24:
; BCC rel (4)
; +10...
	_PC_ADV				; go for operand
	BBR0 ccr68, bcc_do	; only if carry clear
		JMP next_op			; exit without branching otherwise
bcc_do:
	JMP bra_do			; do branch

_25:
; BCS rel (4)
; +10...
	_PC_ADV				; go for operand
	BBS0 ccr68, bcs_do	; only if carry set...
		JMP next_op			; exit without branching
bcs_do:
	JMP bra_do			; branch

_26:
; BNE rel (4)
; +10...
	_PC_ADV				; go for operand
	BBR2 ccr68, bne_do	; only if zero clear...
		JMP next_op			; exit without branching
bne_do:
	JMP bra_do			; branch

_27:
; BEQ rel (4)
; +10...
	_PC_ADV				; go for operand
	BBS2 ccr68, beq_do	; only if zero set...
		JMP next_op			; exit without branching
beq_do:
	JMP bra_do			; branch

_28:
; BVC rel (4)
; +10...
	_PC_ADV				; go for operand
	BBR1 ccr68, bvc_do		; only if overflow clear...
		JMP next_op			; exit without branching
bvc_do:
	JMP bra_do			; branch

_29:
; BVS rel (4)
; +10...
	_PC_ADV				; go for operand
	BBS1 ccr68, bvs_do	; only if overflow set...
		JMP next_op			; exit without branching
bvs_do:
	JMP bra_do			; branch

_2a:
; BPL rel (4)
; +10...
	_PC_ADV				; go for operand
	BBR3 ccr68, bpl_do	; only if plus...
		JMP next_op			; exit without branching
bpl_do:
		JMP bra_do			; branch

_2b:
; BMI rel (4)
; +10...
	_PC_ADV				; go for operand
	BBS3 ccr68, bmi_do	; only if negative...
		JMP next_op			; exit without branching
bmi_do:
	JMP bra_do			; ...do branch

_2c:
; BGE rel (4)
; +17...
	_PC_ADV			; go for operand
	LDA ccr68		; get flags
	AND #%00001010	; filter N and V only
	BIT #%00000010	; check V
	BEQ bge_nx		; do not XOR N if clear
		EOR #%00001000	; toggle N
bge_nx:
	BEQ bge_do		; branch N XOR V is zero
		JMP next_op		; exit without branching
bge_do:
	JMP bra_do		; jump otherwise

_2d:
; BLT rel (4)
; +17...
	_PC_ADV			; go for operand
	LDA ccr68		; get flags
	AND #%00001010	; filter N and V only
	BIT #%00000010	; check V
	BEQ blt_nx		; do not XOR N if clear
		EOR #%00001000	; toggle N
blt_nx:
	BNE blt_do		; branch if N XOR V is true
		JMP next_op		; exit without branching
blt_do:
	JMP bra_do		; jump otherwise

_2e:
; BGT rel (4)
; +17...
	_PC_ADV			; go for operand
	LDA ccr68		; get flags
	AND #%00001110	; filter Z, N and V
	BIT #%00000010	; check V
	BEQ bgt_nx		; do not XOR N if clear
		EOR #%00001000	; toggle N
bgt_nx:
	BEQ bgt_do		; only if N XOR V (OR Z) is false
		JMP next_op		; exit without branching
bgt_do:
	JMP bra_do		; jump otherwise

_2f:
; BLE rel (4)
; +17...
	_PC_ADV			; go for operand
	LDA ccr68		; get flags
	AND #%00001110	; filter Z, N and V
	BIT #%00000010	; check V
	BEQ ble_nx		; do not XOR N if clear
		EOR #%00001000	; toggle N
ble_nx:
	BNE ble_do		; only if N XOR V (OR Z) is true
		JMP next_op		; exit without branching
ble_do:
	JMP bra_do		; jump otherwise

_30:
; TSX (4)
; +21/23/25
	LDA sp68+1		; get stack pointer MSB, to be injected
	LDX sp68		; get stack pointer LSB
	INX				; point to last used!!!
	STX x68			; store in X
	BEQ tsx_w		; rare wrap
tsx_do:
		_AH_BOUND		; inject
		STA x68 + 1		; pointer complete
		JMP next_op		; standard end of routine
tsx_w:
	INC				; increase MSB
	_AH_BOUND		; inject
	STA x68 + 1		; pointer complete
	JMP next_op		; rarer end of routine

_31:
; INS (4)
; +7/7/22
	INC sp68	; increase LSB
	BEQ ins_w	; wrap is a rare case
		JMP next_op	; usual end
ins_w:
	LDA sp68 + 1	; prepare to inject
	INC				; increase MSB
	_AH_BOUND
	STA sp68 + 1	; update pointer
	JMP next_op		; wrapped end

_32:
; PUL A (4)
; +15/15/30
	INC sp68		; pre-increment
	BEQ pula_w		; should correct MSB, rare?
pula_do:
		LDA (sp68)		; take value from stack
		STA a68			; store it in accumulator A
		JMP next_op		; standard end of routine
pula_w:
	LDA sp68 + 1	; get stack pointer MSB
	INC				; increase MSB
	_AH_BOUND		; keep injected
	STA sp68 + 1	; update real thing
	LDA (sp68)		; take value from stack
	STA a68			; store it in accumulator A
	JMP next_op		; standard end of routine

_33:
; PUL B (4)
; +15/15/30
	INC sp68		; pre-increment
	BEQ pulb_w		; should correct MSB, rare?
pulb_do:
		LDA (sp68)		; take value from stack
		STA b68			; store it in accumulator B
		JMP next_op		; standard end of routine
pulb_w:
	LDA sp68 + 1	; get stack pointer MSB
	INC				; increase MSB
	_AH_BOUND		; keep injected
	STA sp68 + 1	; update real thing
	LDA (sp68)		; take value from stack
	STA b68			; store it in accumulator B
	JMP next_op		; standard end of routine

_34:
; DES (4)
; +10/10/24
	LDA sp68		; check older LSB
	BEQ des_w		; will wrap upon decrease!
		DEC sp68		; decrease LSB
		JMP next_op		; usual end
des_w:
	DEC sp68		; as usual
	LDA sp68 + 1	; get MSB
	DEC				; decrease
	_AH_BOUND		; keep injected
	JMP next_op		; wrapped end

_35:
; TXS (4)
; +21/21.5/25
	LDA x68+1		; MSB will be injected
	LDX x68			; check LSB
	BEQ txs_w		; will wrap upon decrease
		DEX				; as expected
		STX sp68		; copy
		_AH_BOUND		; always!
		STA sp68+1		; pointer ready
		JMP next_op		; standard end
txs_w:
	DEX				; as expected
	STX sp68		; copy
	DEC				; will also affect MSB
	_AH_BOUND		; always!
	STA sp68+1		; pointer ready
	JMP next_op		; standard end

_36:
; PSH A (4)
; +18/18/33
	LDA a68		; get accumulator A
	STA (sp68)	; put it on stack space
	LDX sp68	; check LSB
	BEQ psha_w	; will wrap
		DEX			; post-decrease
		STX sp68	; update real value
		JMP next_op	; all done
psha_w:
	DEX			; post-decrease
	STX sp68	; update real value
	LDA sp68+1	; get MSB
	DEC			; decrease it
	_AH_BOUND	; and inject it
	STA sp68+1	; worst update
	JMP next_op		; all done

_37:
; PSH B (4)
; +18/18/33
	LDA b68		; get accumulator B
	STA (sp68)	; put it on stack space
	LDX sp68	; check LSB
	BEQ pshb_w	; will wrap
		DEX			; post-decrease
		STX sp68	; update real value
		JMP next_op	; all done
pshb_w:
	DEX			; post-decrease
	STX sp68	; update real value
	LDA sp68+1	; get MSB
	DEC			; decrease it
	_AH_BOUND	; and inject it
	STA sp68+1	; worst update
	JMP next_op		; all done

_39:
; RTS (5)
	; ***** TO DO ***** TO DO *****

	JMP next_op	; standard end of routine

_3b:
; RTI (10)
	; ***** TO DO ***** TO DO *****

	JMP next_op	; standard end of routine

_3e:
; WAI (9)
	; ***** TO DO ***** TO DO *****

	JMP next_op	; standard end of routine

_3f:
; SWI (12)
	; ***** TO DO ***** TO DO *****

	JMP next_op	; standard end of routine

_40:
; NEG A (2)
; +29/35/41
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits
	STA ccr68	; update status
	SEC			; prepare subtraction
	LDA #0
	SBC a68		; negate A
	STA a68		; update value
	_CC_NZ		; check these
	CMP #$80	; did change sign?
	BNE nega_nv	; skip if not V
		SMB1 ccr68	; set V flag
nega_nv:
	JMP next_op	; standard end of routine

_43:
; COM A (2)
; +24/28/32
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits
	INC			; C always set
	STA ccr68	; update status
	LDA a68		; get A
	EOR #$FF	; complement it
	STA a68		; update value
	_CC_NZ		; check these
	JMP next_op	; standard end of routine

_44:
; LSR A (2)
; +19/20/21
	LDA ccr68		; get original flags
	AND #%11110000	; reset relevant bits (N always reset)
	LSR a68			; shift A right
	BNE lsra_nz		; skip if not zero
		ORA #%00000100	; set Z flag
lsra_nz:
	BCC lsra_nc		; skip if there was no carry
		ORA #%00000011	; will set C and V flags, is that OK?
lsra_nc:
	STA ccr68		; update status
	JMP next_op		; standard end of routine

_46:
; ROR A (2)
; +32/36/40
	CLC			; prepare
	LDA ccr68	; get original flags
	BIT #%00000001	; mask for C flag
	BEQ rora_do	; skip if C clear
		SEC			; otherwise, set carry
rora_do:
	AND #%11110000	; reset relevant bits
	ROR a68		; rotate A right
	BNE rora_nz	; skip if not zero
		ORA #%00000100	; set Z flag
rora_nz:
	LDX a68		; retrieve again!
	BPL rora_pl	; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
rora_pl:
	BCC rora_nc	; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
rora_nc:
	STA ccr68	; update status
	JMP next_op	; standard end of routine

_47:
; ASR A (2)
; +33/37/41
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits
	CLC			; prepare
	BIT a68		; check bit 7
	BPL asra_do	; do not insert C if clear
		SEC			; otherwise, set carry
asra_do:
	ROR a68		; emulate aritmetic shift left with preloaded-C rotation
	BNE asra_nz	; skip if not zero
		ORA #%00000100	; set Z flag
asra_nz:
	LDX a68		; retrieve again!
	BPL asra_pl	; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
asra_pl:
	BCC asra_nc	; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
asra_nc:
	STA ccr68	; update status
	JMP next_op	; standard end of routine

_48:
; ASL A (2)
; +25/28.5/32
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits
	ASL a68		; shift A left
	BNE asla_nz	; skip if not zero
		ORA #%00000100	; set Z flag
asla_nz:
	LDX a68		; retrieve again!
	BPL asla_pl	; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
asla_pl:
	BCC asla_nc	; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
asla_nc:
	STA ccr68	; update status
	JMP next_op	; standard end of routine

_49:
; ROL A (2)
; +32/36/40
	CLC				; prepare
	LDA ccr68		; get original flags
	BIT #%00000001	; mask for C flag
	BEQ rola_do		; skip if C clear
		SEC				; otherwise, set carry
rola_do:
	AND #%11110000	; reset relevant bits
	ROL a68			; rotate A left
	BNE rola_nz		; skip if not zero
		ORA #%00000100	; set Z flag
rola_nz:
	LDX a68			; retrieve again!
	BPL rola_pl		; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
rola_pl:
	BCC rola_nc		; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
rola_nc:
	STA ccr68		; update status
	JMP next_op		; standard end of routine

_4a:
; DEC A (2)
; +27//39
	LDA ccr68	; get original status
	AND #%11110001	; reset all relevant bits for CCR
	STA ccr68	; store new flags
	DEC a68		; decrease A
	_CC_NZ		; check these
	LDX a68		; check it!
	CPX #$7F	; did change sign?
	BNE deca_nv	; skip if not overflow
		SMB1 ccr68	; will set V flag
deca_nv:
	JMP next_op	; standard end of routine

_4c:
; INC A (2)
	LDA ccr68	; get original status
	AND #%11110001	; reset all relevant bits for CCR 
	STA ccr68	; store new flags
	INC a68		; increase A
	_CC_NZ		; check these
	LDX a68		; check it!
	CPX #$80	; did change sign?
	BNE inca_nv	; skip if not overflow
		SMB1 ccr68	; will set V flag
inca_nv:
	JMP next_op	; standard end of routine (+27...39)

_4d:
; TST A (2)
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits
	STA ccr68	; update status
	LDA a68		; check accumulator A
	_CC_NZ		; check these flags
	JMP next_op	; standard end of routine (+17...25)

_4f:
; CLR A (2)
	STZ a68		; clear A
	LDA ccr68	; get previous status
	AND #%11110100	; clear N, V, C
	ORA #%00000100	; set Z
	STA ccr68	; update (+13)
	JMP next_op	; standard end of routine

_50:
; NEG B (2)
; +29/35/41
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits
	STA ccr68	; update status
	SEC			; prepare subtraction
	LDA #0
	SBC b68		; negate B
	STA b68		; update value
	_CC_NZ		; check these
	CMP #$80	; did change sign?
	BNE negb_nv	; skip if not V
		SMB1 ccr68	; set V flag
negb_nv:
	JMP next_op	; standard end of routine

_53:
; COM B (2)
; +24/28/32
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits
	INC			; C always set
	STA ccr68	; update status
	LDA b68		; get B
	EOR #$FF	; complement it
	STA b68		; update value
	_CC_NZ		; check these
	JMP next_op	; standard end of routine

_54:
; LSR B (2)
; +19/20/21
	LDA ccr68		; get original flags
	AND #%11110000	; reset relevant bits (N always reset)
	LSR b68			; shift B right
	BNE lsrb_nz		; skip if not zero
		ORA #%00000100	; set Z flag
lsrb_nz:
	BCC lsrb_nc		; skip if there was no carry
		ORA #%00000011	; will set C and V flags, OK?
lsrb_nc:
	STA ccr68		; update status
	JMP next_op		; standard end of routine

_56:
; ROR B (2)
; +32/36/40
	CLC			; prepare
	LDA ccr68	; get original flags
	BIT #%00000001	; mask for C flag
	BEQ rorb_do	; skip if C clear
		SEC			; otherwise, set carry
rorb_do:
	AND #%11110000	; reset relevant bits
	ROR b68		; rotate B right
	BNE rorb_nz	; skip if not zero
		ORA #%00000100	; set Z flag
rorb_nz:
	LDX b68		; retrieve again!
	BPL rorb_pl	; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
rorb_pl:
	BCC rorb_nc	; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
rorb_nc:
	STA ccr68	; update status
	JMP next_op	; standard end of routine

_57:
; ASR B (2)
; +33/37/41
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits
	CLC			; prepare
	BIT b68		; check bit 7
	BPL asrb_do	; do not insert C if clear
		SEC			; otherwise, set carry
asrb_do:
	ROR b68		; emulate aritmetic shift left with preloaded-C rotation
	BNE asrb_nz	; skip if not zero
		ORA #%00000100	; set Z flag
asrb_nz:
	LDX b68		; retrieve again!
	BPL asrb_pl	; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
asrb_pl:
	BCC asrb_nc	; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
asrb_nc:
	STA ccr68	; update status
	JMP next_op	; standard end of routine

_58:
; ASL B (2)
; +25/28.5/32
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits
	ASL b68		; shift B left
	BNE aslb_nz	; skip if not zero
		ORA #%00000100	; set Z flag
aslb_nz:
	LDX b68		; retrieve again!
	BPL aslb_pl	; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
aslb_pl:
	BCC aslb_nc	; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
aslb_nc:
	STA ccr68	; update status
	JMP next_op	; standard end of routine

_59:
; ROL B (2)
; +32/36/40
	CLC			; prepare
	LDA ccr68	; get original flags
	BIT #%00000001	; mask for C flag
	BEQ rolb_do	; skip if C clear
		SEC			; otherwise, set carry
rolb_do:
	AND #%11110000	; reset relevant bits
	ROL b68		; rotate B left
	BNE rolb_nz	; skip if not zero
		ORA #%00000100	; set Z flag
rolb_nz:
	LDX b68		; retrieve again!
	BPL rolb_pl	; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
rolb_pl:
	BCC rolb_nc	; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
rolb_nc:
	STA ccr68	; update status
	JMP next_op	; standard end of routine


_5a:
; DEC B (2)
; +27//39
	LDA ccr68	; get original status
	AND #%11110001	; reset all relevant bits for CCR
	STA ccr68	; store new flags
	DEC b68		; decrease B
	_CC_NZ		; check these
	LDX b68		; check it!
	CPX #$7F	; did change sign?
	BNE decb_nv	; skip if not overflow
		SMB1 ccr68	; will set V flag
decb_nv:
	JMP next_op	; standard end of routine

_5c:
; INC B (2)
	LDA ccr68	; get original status
	AND #%11110001	; reset all relevant bits for CCR 
	STA ccr68	; store new flags
	INC b68		; increase B
	_CC_NZ		; check these
	LDX b68		; check it!
	CPX #$80	; did change sign?
	BNE incb_nv	; skip if not overflow
		SMB1 ccr68	; will set V flag
incb_nv:
	JMP next_op	; standard end of routine (+27...39)

_5d:
; TST B (2)
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits
	STA ccr68	; update status
	LDA b68		; check accumulator B
	_CC_NZ		; check these flags
	JMP next_op	; standard end of routine (+17...25)

_5f:
; CLR B (2)
	STZ b68		; clear B
	LDA ccr68	; get previous status
	AND #%11110100	; clear N, V, C
	ORA #%00000100	; set Z
	STA ccr68	; update (+13)
	JMP next_op	; standard end of routine

_60:
; NEG ind (7)
; +
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits
	STA ccr68	; update status
	_INDEXED	; compute pointer
	SEC			; prepare subtraction
	LDA #0
	SBC (tmptr)	; negate memory
	STA (tmptr)	; update value
	_CC_NZ		; check these
	CMP #$80	; did change sign?
	BNE negi_nv	; skip if not V
		SMB1 ccr68	; set V flag
negi_nv:
	JMP next_op	; standard end of routine

_63:
; COM ind (7)
; +
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits
	INC			; C always set
	STA ccr68	; update status
	_INDEXED	; compute pointer
	LDA (tmptr)	; get memory
	EOR #$FF	; complement it
	STA (tmptr)	; update value
	_CC_NZ		; check these
	JMP next_op	; standard end of routine

_64:
; LSR ind (7)
; +
	_INDEXED	; addressing mode
	LDA (tmptr)	; get operand
	LSR
	STA (tmptr)	; modify operand
	TAX			; store for later, worth it
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits (N always reset)
	BCC lsri_nc	; skip if there was no carry
		ORA #%00000011	; will set C and V flags
lsri_nc:
	CPX #0		; retrieve value
	BNE lsri_nz	; skip if not zero
		ORA #%00000100	; set Z flag
lsri_nz:
	STA ccr68	; update status
	JMP next_op	; standard end of routine

_66:
; ROR ind (7)
; +
	_INDEXED		; addressing mode
	CLC				; prepare
	LDA ccr68		; get original flags
	BIT #%00000001	; mask for C flag
	BEQ rori_do		; skip if C clear
		SEC				; otherwise, set carry
rori_do:
	LDA (tmptr)		; get memory
	ROR				; rotate right
	STA (tmptr)		; modify
	TAX				; keep for later
	LDA ccr68		; get flags again
	AND #%11110000	; reset relevant bits
	BCC rori_nc		; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
rori_nc:
	CPX #0			; watch computed value!
	BNE rori_nz		; skip if not zero
		ORA #%00000100	; set Z flag
rori_nz:
	CPX #0			; watch computed value!
	BPL rori_pl		; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
rori_pl:
	STA ccr68		; update status
	JMP next_op		; standard end of routine

_67:
; ASR ind (7)
; +
	_INDEXED		; get pointer to operand
	CLC				; prepare
	LDA (tmptr)		; check operand
	BPL asri_do		; do not insert C if clear
		SEC				; otherwise, set carry
asri_do:
	ROR 			; emulate aritmetic shift left with preloaded-C rotation
	STA (tmptr)		; update memory
	TAX				; store for later!
	LDA ccr68		; get original flags
	AND #%11110000	; reset relevant bits
	BCC asri_nc		; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
asri_nc:
	CPX #0			; retrieve value
	BNE asri_nz		; skip if not zero
		ORA #%00000100	; set Z flag
asri_nz:
	CPX #0			; retrieve again!
	BPL asri_pl		; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
asri_pl:
	STA ccr68		; update status
	JMP next_op		; standard end of routine

_68:
; ASL ind (7)
; +
	_INDEXED		; prepare pointer
	LDA (tmptr)		; get operand
	ASL				; shift left
	STA (tmptr)		; update memory
	TAX				; save for later!
	LDA ccr68		; get original flags
	AND #%11110000	; reset relevant bits
	BCC asli_nc		; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
asli_nc:
	CPX #0			; retrieve value
	BNE asli_nz		; skip if not zero
		ORA #%00000100	; set Z flag
asli_nz:
	CPX #0			; retrieve again!
	BPL asli_pl		; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
asli_pl:
	STA ccr68		; update status
	JMP next_op		; standard end of routine

_69:
; ROL ind (7)
; +
	_INDEXED		; addressing mode
	CLC				; prepare
	LDA ccr68		; get original flags
	BIT #%00000001	; mask for C flag
	BEQ roli_do		; skip if C clear
		SEC				; otherwise, set carry
roli_do:
	LDA (tmptr)		; get memory
	ROL				; rotate left
	STA (tmptr)		; modify
	TAX				; keep for later
	LDA ccr68		; get flags again
	AND #%11110000	; reset relevant bits
	BCC roli_nc		; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
roli_nc:
	CPX #0			; watch computed value!
	BNE roli_nz		; skip if not zero
		ORA #%00000100	; set Z flag
roli_nz:
	CPX #0			; watch computed value!
	BPL roli_pl		; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
roli_pl:
	STA ccr68		; update status
	JMP next_op		; standard end of routine

_6a:
; DEC ind (7)
; +
	LDA ccr68		; get original status
	AND #%11110001	; reset all relevant bits for CCR
	STA ccr68		; store new flags
	_INDEXED		; addressing mode
	LDA (tmptr)		; no DEC (tmptr) available...
	DEC
	STA (tmptr)
	_CC_NZ			; check these
	CMP #$7F		; did change sign?
	BNE deci_nv		; skip if not overflow
		SMB1 ccr68		; will set V flag
deci_nv:
	JMP next_op		; standard end of routine

_6c:
; INC ind (7)
; +
	LDA ccr68		; get original status
	AND #%11110001	; reset all relevant bits for CCR 
	STA ccr68		; store new flags
	_INDEXED		; addressing mode
	LDA (tmptr)		; no INC (tmptr) available...
	INC
	STA (tmptr)
	_CC_NZ			; check these
	CMP #$80		; did change sign?
	BNE inci_nv		; skip if not overflow
		SMB1 ccr68		; will set V flag
inci_nv:
	JMP next_op		; standard end of routine

_6d:
; TST ind (7)
; +
	LDA ccr68		; get original flags
	AND #%11110000	; reset relevant bits
	STA ccr68		; update status
	_INDEXED		; set pointer
	LDA (tmptr)		; check operand
	_CC_NZ			; check these flags
	JMP next_op		; standard end of routine

_6e:
; JMP ind (4)
; -5+27//28
	_PC_ADV			; get operand
	LDA (pc68), Y	; set offset
	CLC				; prepare
	ADC x68			; add LSB
	TAY				; this is new offset!
	LDA x68 + 1		; get MSB
	ADC #0			; propagate carry
	_AH_BOUND		; stay injected
	STA pc68 + 1	; update pointer
	JMP execute		; do jump

_6f:
; CLR ind (7)
; +
	_INDEXED		; prepare pointer
	LDA #0			; no indirect STZ available
	STA (tmptr)		; clear memory
	LDA ccr68		; get previous status
	AND #%11110100	; clear N, V, C
	ORA #%00000100	; set Z
	STA ccr68		; update flags
	JMP next_op		; standard end of routine

_70:
; NEG ext (6)
; +
	LDA ccr68		; get original flags
	AND #%11110000	; reset relevant bits
	STA ccr68		; update status
	_EXTENDED		; addressing mode
	SEC				; prepare subtraction
	LDA #0
	SBC (tmptr)		; negate memory
	STA (tmptr)		; update value
	_CC_NZ			; check these
	CMP #$80		; did change sign?
	BNE nege_nv		; skip if not V
		SMB1 ccr68		; set V flag
nege_nv:
	JMP next_op	; standard end of routine

_73:
; COM ext (6)
; +
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits
	INC			; C always set
	STA ccr68	; update status
	_EXTENDED	; addressing mode
	LDA (tmptr)	; get memory
	EOR #$FF	; complement it
	STA (tmptr)	; update value
	_CC_NZ		; check these
	CPX #$80	; did change sign?
	BNE come_nv	; skip if not V
		SMB1 ccr68	; set V flag
come_nv:
	JMP next_op	; standard end of routine

_74:
; LSR ext (6)
; +
	_EXTENDED	; addressing mode
	LDA (tmptr)	; get operand
	LSR
	STA (tmptr)	; modify operand
	TAX			; store for later, worth it
	LDA ccr68	; get original flags
	AND #%11110000	; reset relevant bits (N always reset)
	BCC lsre_nc	; skip if there was no carry
		ORA #%00000011	; will set C and V flags
lsre_nc:
	CPX #0		; retrieve value
	BNE lsre_nz	; skip if not zero
		ORA #%00000100	; set Z flag
lsre_nz:
	STA ccr68	; update status
	JMP next_op	; standard end of routine

_76:
; ROR ext (6)
; +
	_EXTENDED		; addressing mode
	CLC				; prepare
	LDA ccr68		; get original flags
	BIT #%00000001	; mask for C flag
	BEQ rore_do		; skip if C clear
		SEC				; otherwise, set carry
rore_do:
	LDA (tmptr)		; get memory
	ROR				; rotate right
	STA (tmptr)		; modify
	TAX				; keep for later
	LDA ccr68		; get flags again
	AND #%11110000	; reset relevant bits
	BCC rore_nc		; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
rore_nc:
	CPX #0			; watch computed value!
	BNE rore_nz		; skip if not zero
		ORA #%00000100	; set Z flag
rore_nz:
	CPX #0			; watch computed value!
	BPL rore_pl		; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
rore_pl:
	STA ccr68		; update status
	JMP next_op		; standard end of routine

_77:
; ASR ext (6)
; +
	_EXTENDED		; get pointer to operand
	CLC				; prepare
	LDA (tmptr)		; check operand
	BPL asre_do		; do not insert C if clear
		SEC				; otherwise, set carry
asre_do:
	ROR 			; emulate aritmetic shift left with preloaded-C rotation
	STA (tmptr)		; update memory
	TAX				; store for later!
	LDA ccr68		; get original flags
	AND #%11110000	; reset relevant bits
	BCC asre_nc		; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
asre_nc:
	CPX #0			; retrieve value
	BNE asre_nz		; skip if not zero
		ORA #%00000100	; set Z flag
asre_nz:
	CPX #0			; retrieve again!
	BPL asre_pl		; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
asre_pl:
	STA ccr68		; update status
	JMP next_op		; standard end of routine


_78:
; ASL ext (6)
; +
	_EXTENDED		; prepare pointer
	LDA (tmptr)		; get operand
	ASL				; shift left
	STA (tmptr)		; update memory
	TAX				; save for later!
	LDA ccr68		; get original flags
	AND #%11110000	; reset relevant bits
	BCC asle_nc		; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
asle_nc:
	CPX #0			; retrieve value
	BNE asle_nz		; skip if not zero
		ORA #%00000100	; set Z flag
asle_nz:
	CPX #0			; retrieve again!
	BPL asle_pl		; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
asle_pl:
	STA ccr68		; update status
	JMP next_op		; standard end of routine

_79:
; ROL ext (6)
; +
	_EXTENDED		; addressing mode
	CLC				; prepare
	LDA ccr68		; get original flags
	BIT #%00000001	; mask for C flag
	BEQ role_do		; skip if C clear
		SEC				; otherwise, set carry
role_do:
	LDA (tmptr)		; get memory
	ROL				; rotate left
	STA (tmptr)		; modify
	TAX				; keep for later
	LDA ccr68		; get flags again
	AND #%11110000	; reset relevant bits
	BCC role_nc		; skip if there was no carry
		ORA #%00000001	; will set C flag
		EOR #%00000010	; toggle V bit
role_nc:
	CPX #0			; watch computed value!
	BNE role_nz		; skip if not zero
		ORA #%00000100	; set Z flag
role_nz:
	CPX #0			; watch computed value!
	BPL role_pl		; skip if positive
		ORA #%00001000	; will set N bit
		EOR #%00000010	; toggle V bit
role_pl:
	STA ccr68		; update status
	JMP next_op		; standard end of routine

_7a:
; DEC ext (6)
; +
	LDA ccr68		; get original status
	AND #%11110001	; reset all relevant bits for CCR
	STA ccr68		; store new flags
	_EXTENDED		; addressing mode
	LDA (tmptr)		; no DEC (tmptr) available...
	DEC
	STA (tmptr)
	_CC_NZ			; check these
	CMP #$7F		; did change sign?
	BNE dece_nv		; skip if not overflow
		SMB1 ccr68		; will set V flag
dece_nv:
	JMP next_op		; standard end of routine

_7c:
; INC ext (6)
; +
	LDA ccr68		; get original status
	AND #%11110001	; reset all relevant bits for CCR 
	STA ccr68		; store new flags
	_EXTENDED		; addressing mode
	LDA (tmptr)		; no INC (tmptr) available...
	INC
	STA (tmptr)
	_CC_NZ			; check these
	CMP #$80		; did change sign?
	BNE ince_nv		; skip if not overflow
		SMB1 ccr68		; will set V flag
ince_nv:
	JMP next_op		; standard end of routine

_7d:
; TST ext (6)
; +
	LDA ccr68		; get original flags
	AND #%11110000	; reset relevant bits
	STA ccr68		; update status
	_EXTENDED		; set pointer
	LDA (tmptr)		; check operand
	_CC_NZ			; check these flags
	JMP next_op		; standard end of routine

_7e:
; JMP ext (3)
	_PC_ADV		; go for destination MSB
	LDA (pc68), Y	; get it
	_AH_BOUND	; check against emulated limits
	TAX			; hold it for a moment
	_PC_ADV		; now for the LSB
	LDA (pc68), Y	; get it
	TAY			; this works as index
	STX pc68 + 1	; MSB goes into register area
	JMP execute	; all done (-5 for jumps, all this is +32...46)

_7f:
; CLR ext (6)
; +
	_EXTENDED		; prepare pointer
	LDA #0			; no indirect STZ available
	STA (tmptr)		; clear memory
	LDA ccr68		; get previous status
	AND #%11110100	; clear N, V, C
	ORA #%00000100	; set Z
	STA ccr68		; update flags
	JMP next_op		; standard end of routine

_80:
; SUB A imm (2)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_81:
; CMP A imm (2)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_82:
; SBC A imm (2)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_84:
; AND A imm (2)
; +30...
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	_PC_ADV			; go for operand
	LDA (pc68), Y	; immediate
	AND a68			; AND with accumulator A
	STA a68			; update
	_CC_NZ			; check these
	JMP next_op		; standard end

_85:
; BIT A imm (2)
; +27...
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	_PC_ADV			; go for operand
	LDA (pc68), Y	; immediate
	AND a68			; AND with accumulator A
	_CC_NZ			; check these
	JMP next_op		; standard end

_86:
; LDA A imm (2)
; +27...
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	_PC_ADV			; go for operand
	LDA (pc68), Y	; immediate
	STA a68			; update accumulator A
	_CC_NZ			; check these
	JMP next_op		; standard end

_88:
; EOR A imm (2)
; +30...
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	_PC_ADV			; go for operand
	LDA (pc68), Y	; immediate
	EOR a68			; EOR with accumulator A
	STA a68			; update
	_CC_NZ			; check these
	JMP next_op		; standard end

_89:
; ADC A imm (2)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_8a:
; ORA A imm (2)
; +30...
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	_PC_ADV			; go for operand
	LDA (pc68), Y	; immediate
	ORA a68			; OR with accumulator A
	STA a68			; update
	_CC_NZ			; check these
	JMP next_op		; standard end

_8b:
; ADD A imm (2)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_8c:
; CPX imm (2)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_8d:
; BSR rel
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_8e:
; LDS imm
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_90:
; SUB A dir (3)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_91:
; CMP A dir (3)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_92:
; SBC A dir (3)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_94:
; AND A dir (3)
; +
	_DIRECT			; X points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	AND $4000, X	; AND with operand
	STA a68			; update A
	_CC_NZ			; set flags
	JMP next_op		; standard end

_95:
; BIT A dir (3)
; +
	_DIRECT			; X points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	AND $4000, X	; test operand
	_CC_NZ			; set flags
	JMP next_op		; standard end

_96:
; LDA A dir (3)
; +
	_DIRECT			; X points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA $4000, X	; get operand
	STA a68			; load into A
	_CC_NZ			; set flags
	JMP next_op		; standard end

_97:
; STA A dir (4)
; +
	_DIRECT			; X points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	STA $4000, X	; store at operand
	_CC_NZ			; set flags
	JMP next_op		; standard end

_98:
; EOR A dir (3)
; +
	_DIRECT			; X points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	EOR $4000, X	; EOR with operand
	STA a68			; update A
	_CC_NZ			; set flags
	JMP next_op		; standard end

_99:
; ADC A dir (3)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_9a:
; ORA A dir (3)
; +
	_DIRECT			; X points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	ORA $4000, X	; ORA with operand
	STA a68			; update A
	_CC_NZ			; set flags
	JMP next_op		; standard end

_9b:
; ADD A dir (3)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_9c:
; CPX dir
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_9e:
; LDS dir
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_9f:
; STS dir
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_a0:
; SUB A ind (5)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_a1:
; CMP A ind (5)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_a2:
; SBC A ind (5)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_a4:
; AND A ind (5)
; +
	_INDEXED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	AND (tmptr)		; AND with operand
	STA a68			; update A
	_CC_NZ			; set flags
	JMP next_op		; standard end

_a5:
; BIT A ind (5)
; +
	_INDEXED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	AND (tmptr)		; AND with operand, just for flags
	_CC_NZ			; set flags
	JMP next_op		; standard end

_a6:
; LDA A ind (5)
; +
	_INDEXED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA (tmptr)		; get operand
	STA a68			; load into A
	_CC_NZ			; set flags
	JMP next_op		; standard end

_a7:
; STA A ind (6)
; +
	_INDEXED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	STA (tmptr)		; store at operand
	_CC_NZ			; set flags
	JMP next_op		; standard end

_a8:
; EOR A ind (5)
; +
	_INDEXED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	EOR (tmptr)		; EOR with operand
	STA a68			; update A
	_CC_NZ			; set flags
	JMP next_op		; standard end

_a9:
; ADC A ind (5)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_aa:
; ORA A ind (5)
; +
	_INDEXED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	ORA (tmptr)		; ORA with operand
	STA a68			; update A
	_CC_NZ			; set flags
	JMP next_op		; standard end

_ab:
; ADD A ind (5)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_ac:
; CPX ind
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_ad:
; JSR ind
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_ae:
; LDS ind
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_af:
; STS ind
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_b0:
; SUB A ext (4)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_b1:
; CMP A ext (4)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_b2:
; SBC A ext (4)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_b4:
; AND A ext (4)
; +
	_EXTENDED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	AND (tmptr)		; AND with operand
	STA a68			; update A
	_CC_NZ			; set flags
	JMP next_op		; standard end

_b5:
; BIT A ext (4)
; +
	_EXTENDED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	AND (tmptr)		; AND with operand, just for flags
	_CC_NZ			; set flags
	JMP next_op		; standard end

_b6:
; LDA A ext (4)
; +
	_EXTENDED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA (tmptr)		; get operand
	STA a68			; load into A
	_CC_NZ			; set flags
	JMP next_op		; standard end

_b7:
; STA A ext (5)
; +
	_EXTENDED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	STA (tmptr)		; store at operand
	_CC_NZ			; set flags
	JMP next_op		; standard end

_b8:
; EOR A ext (4)
; +
	_EXTENDED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	EOR (tmptr)		; EOR with operand
	STA a68			; update A
	_CC_NZ			; set flags
	JMP next_op		; standard end

_b9:
; ADC A ext (4)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_ba:
; ORA A ext (4)
; +
	_EXTENDED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA a68			; get A accumulator
	ORA (tmptr)		; ORA with operand
	STA a68			; update A
	_CC_NZ			; set flags
	JMP next_op		; standard end

_bb:
; ADD A ext (4)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_bc:
; CPX ext
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_bd:
; JSR ext
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_be:
; LDS ext
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_bf:
; STS ext
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_c0:
; SUB B imm (2)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_c1:
; CMP B imm (2)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_c2:
; SBC B imm (2)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_c4:
; AND B imm (2)
; +30...
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	_PC_ADV			; go for operand
	LDA (pc68), Y	; immediate
	AND b68			; AND with accumulator B
	STA b68			; update
	_CC_NZ			; check these
	JMP next_op		; standard end

_c5:
; BIT B imm (2)
; +27...
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	_PC_ADV			; go for operand
	LDA (pc68), Y	; immediate
	AND b68			; AND with accumulator B
	_CC_NZ			; check these
	JMP next_op		; standard end

_c6:
; LDA B imm (2)
; +27...
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	_PC_ADV			; go for operand
	LDA (pc68), Y	; immediate
	STA b68			; update accumulator B
	_CC_NZ			; check these
	JMP next_op		; standard end

_c8:
; EOR B imm (2)
; +30...
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	_PC_ADV			; go for operand
	LDA (pc68), Y	; immediate
	EOR b68			; EOR with accumulator B
	STA b68			; update
	_CC_NZ			; check these
	JMP next_op		; standard end

_c9:
; ADC B imm (2)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_ca:
; ORA B imm (2)
; +30...
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	_PC_ADV			; go for operand
	LDA (pc68), Y	; immediate
	ORA b68			; OR with accumulator B
	STA b68			; update
	_CC_NZ			; check these
	JMP next_op		; standard end

_cb:
; ADD B imm (2)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_ce:
; LDX ind ()
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_d0:
; SUB B dir (3)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_d1:
; CMP B dir (3)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_d2:
; SBC B dir (3)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_d4:
; AND B dir (3)
; +
	_DIRECT			; X points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	AND $4000, X	; AND with operand
	STA b68			; update B
	_CC_NZ			; set flags
	JMP next_op		; standard end

_d5:
; BIT B dir (3)
; +
	_DIRECT			; X points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	AND $4000, X	; AND with operand
	_CC_NZ			; set flags
	JMP next_op		; standard end

_d6:
; LDA B dir (3)
; +
	_DIRECT			; X points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA $4000, X	; get operand
	STA b68			; laod into B
	_CC_NZ			; set flags
	JMP next_op		; standard end

_d7:
; STA B dir (4)
; +
	_DIRECT			; X points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	STA $4000, X	; store into operand
	_CC_NZ			; set flags
	JMP next_op		; standard end

_d8:
; EOR B dir (3)
; +
	_DIRECT			; X points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	EOR $4000, X	; EOR with operand
	STA b68			; update B
	_CC_NZ			; set flags
	JMP next_op		; standard end

_d9:
; ADC B dir (3)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_da:
; ORA B dir (3)
; +
	_DIRECT			; X points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	ORA $4000, X	; ORA with operand
	STA b68			; update B
	_CC_NZ			; set flags
	JMP next_op		; standard end

_db:
; ADD B dir (3)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_de:
; LDX dir (4)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_df:
; STX dir (5)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_e0:
; SUB B ind (5)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_e1:
; CMP B ind (5)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_e2:
; SBC B ind (5)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_e4:
; AND B ind (5)
; +
	_INDEXED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	AND (tmptr)		; AND with operand
	STA b68			; update B
	_CC_NZ			; set flags
	JMP next_op		; standard end

_e5:
; BIT B ind (5)
; +
	_INDEXED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	AND (tmptr)		; AND with operand, just for flags
	_CC_NZ			; set flags
	JMP next_op		; standard end

_e6:
; LDA B ind (5)
; +
	_INDEXED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA (tmptr)		; get operand
	STA b68			; load into B
	_CC_NZ			; set flags
	JMP next_op		; standard end

_e7:
; STA B ind (6)
; +
	_INDEXED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	STA (tmptr)		; store at operand
	_CC_NZ			; set flags
	JMP next_op		; standard end

_e8:
; EOR B ind (5)
; +
	_INDEXED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	EOR (tmptr)		; EOR with operand
	STA b68			; update B
	_CC_NZ			; set flags
	JMP next_op		; standard end

_e9:
; ADC B ind (5)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_ea:
; ORA B ind (5)
; +
	_INDEXED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	ORA (tmptr)		; ORA with operand
	STA b68			; update B
	_CC_NZ			; set flags
	JMP next_op		; standard end

_eb:
; ADD B ind (5)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_ee:
; LDX ind (6)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_ef:
; STX ind (7)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_f0:
; SUB B ext (4)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_f1:
; CMP B ext (4)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_f2:
; SBC B ext (4)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_f4:
; AND B ext (4)
; +
	_EXTENDED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	AND (tmptr)		; AND with operand
	STA b68			; update B
	_CC_NZ			; set flags
	JMP next_op		; standard end

_f5:
; BIT B ext (4)
; +
	_EXTENDED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	AND (tmptr)		; AND with operand, just for flags
	_CC_NZ			; set flags
	JMP next_op		; standard end

_f6:
; LDA B ext (4)
; +
	_EXTENDED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA (tmptr)		; get operand
	STA b68			; load into B
	_CC_NZ			; set flags
	JMP next_op		; standard end

_f7:
; STA B ext (5)
; +
	_EXTENDED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	STA (tmptr)		; store at operand
	_CC_NZ			; set flags
	JMP next_op		; standard end

_f8:
; EOR B ext (4)
; +
	_EXTENDED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	EOR (tmptr)		; EOR with operand
	STA b68			; update B
	_CC_NZ			; set flags
	JMP next_op		; standard end

_f9:
; ADC B ext (4)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_fa:
; ORA B ext (4)
; +
	_EXTENDED		; points to operand
	LDA ccr68		; get flags
	AND #%11110001	; clear relevant bits
	STA ccr68		; update
	LDA b68			; get B accumulator
	ORA (tmptr)		; ORA with operand
	STA b68			; update B
	_CC_NZ			; set flags
	JMP next_op		; standard end

_fb:
; ADD B ext (4)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_fe:
; LDX ext (5)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

_ff:
; STX ext (6)
	; ***** TO DO ***** TO DO *****
	JMP next_op	; standard end

; *** opcode execution addresses table ***
; should stay no matter the CPU!
optable_l:
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
	.word	_68
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
optable_h:
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
