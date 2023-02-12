; nanoPython (Proof Of Concept)
; (c) 2023 Carlos J. Santisteban
; last modified 20230212-1004

; *** zeropage ***
cio_pt		= $E6
cio_src		= $E4
temptr		= $E8

; *** hardware definitions for Durango-X ***
IO8attr		= $DF80
IOAen		= $DFA0
; *** firmware definitions for Durango-X ***
fw_irq		= $0200			; ### usual minimOS interrupt vectors ###
fw_nmi		= $0202			; not used
ticks		= $0206			; jiffy counter EEEEK
; make room for keyboard driver ($020A-$020F)
; CONIO specific variables
fw_cbin		= $0210			; integrated picoVDU/Durango-X specifics
fw_fnt		= fw_cbin+1		; (new, pointer to relocatable 2KB font file)
fw_mask		= fw_fnt+2		; (for inverse/emphasis mode)
fw_chalf	= fw_mask+1		; (remaining pages to write)
fw_sind		= fw_chalf+1
fw_ccol		= fw_sind+3		; (no longer SPARSE array of two-pixel combos, will store ink & paper)
fw_ctmp		= fw_ccol+4
fw_cbyt		= fw_ctmp		; (temporary glyph storage) other tmp
fw_ccnt		= fw_cbyt		; (bytes per raster counter, no longer X) actually the same tmp
fw_ciop		= fw_ccnt+1		; cursor position
fw_vbot		= fw_ciop+2		; page start of screen at current hardware setting (updated upon FF)
fw_vtop		= fw_vbot+1		; first non-VRAM page (new)
fw_io9		= fw_vtop+1		; received keypress
fw_scur		= fw_io9+1		; NEW, cursor control

; *************************
; *** *** main code *** ***
; *************************
nanopython:
	LDX #>splash
	LDY #<splash
	JSR string
repl:
		JSR prompt
		JSR getch
		JSR conio	; *** just echo
		CPY #13				; hit RETURN?
		BEQ proc
		BNE repl
proc:
		LDX #>wtf
		LDY #<wtf
		JSR string
		JMP repl

; ************************
; *** support routines ***
; ************************
getch:
; *** get a character from keyboard (locking) ***
		LDY #0
		JSR conio			; character input
		BCS getch
	RTS

prompt:
; *** display current prompt ***
	LDY #13
	JSR conio
	LDY #'>'
	JSR conio
	LDY #'>'
	JSR conio
	LDY #'>'
	JSR conio
	LDY #' '
	JMP conio				; display last char and return

string:
; *** display string at XY ***
	STX temptr+1
	STZ temptr				; set pointer
str_loop:
		LDA (temptr), Y		; get char from string
			BEQ str_end		; terminator will finish printing
		PHY					; keep cursor
		JSR conio			; display char
		PLY					; retrieve cursor
		INY					; next char
		BNE str_loop
	INC temptr+1			; in case of page crossing
		BNE str_loop		; always
str_end:
	RTS

; ********************
; *** *** data *** ***
; ********************
splash:
	.asc	"65C02 nanoPython PoC", 13, "@zuiko21", 13, 0
wtf:
	.asc	13, 14, "*** WTF?? ***", 15, 13, 0

; *** *** *** ***** *** *** ***

	.dsb	$E000-*, $FF	; just in case, skip IO

; ********************
; *** *** BIOS *** ***
; ********************

reset:
; POST
	SEI						; usual 6502 stuff
	CLD
	LDX #$FF
	TXS
	STX IOAen				; ### enable Durango-X hardware interrupt ###
	STX fw_scur				; as bit 7 is on, activates cursor
	LDA #$B0				; start in HIRES mode
	STA IO8attr
	LDX #3					; max jiffy counter index
jf_res:
		STZ ticks, X		; reset all jiffy counter bytes
		STZ kb_asc, X		; init all keyboard variables too, up to kb_scan (4 bytes)
		DEX
		BPL jf_res
	LDX #>std_irq
	LDY #<std_irq
	STY fw_irq				; set standard interrupt vectors
	STX fw_irq+1
	LDX #>std_nmi			; danger if commented!
	LDY #<std_nmi
	STY fw_nmi
	STX fw_nmi+1
; * check keyboard *
	LDX #0					; default is PASK
	LDA #32					; column 6
	STA IO9m5x8				; select it
	LDA IO9m5x8				; and read rows
	CMP #$2C				; is it a 5x8 matrix? EEEEEEEEK
	BNE not_5x8
		LDX #2				; set as default keyboard
not_5x8:
	STX kb_type				; set selected type
; * init CONIO *
	STZ fw_cbin				; EEEEEEK
	STZ fw_mask
	STZ fw_io9
	LDA #$87				; yellow on blue intial colours (not for HIRES)
	STA fw_ccol+1			; will reconstruct colours from this upon FF
	LDY #12					; FF = clear screen
	JSR conio

	JMP nanopyhton			; start nanoPython

; **************************
; *** interrupt handlers ***
; **************************
irq:
	JMP (fw_irq)			; standard minimOS vector
std_irq:					; IRQ support for EhBASIC, from min_mon.asm
; *** minimOS jiffy counter ***
	INC ticks
	BNE irq_sup
		INC ticks+1
	BNE irq_sup
		INC ticks+2
	BNE irq_sup
		INC ticks+3
irq_sup:
	PHA
	PHX
	PHY						; needed for 5x8 matrix support
; *** interrupt support for matrix keyboard ***
	JSR kbd_isr
; in extremis check for (catastrophic) BRK
;	PHX						; already saved
	TSX
	LDA $104, X				; get pushed PSR (note stack frame)
	AND #$10				; check BRK bit
	BEQ not_brk
; *** BRK happened *** will keep the LED flashing, as no debugger is installed
brk_panic:
				INX
				BNE brk_panic
			INY
			BNE brk_panic	; 0.2s delay
		INC					; cycle LED
		STA IOAen
		BRA brk_panic
not_brk:
	PLY						; for 5x8 matrix support
	PLX
	PLA
nmi:						; NMI does nothing
	RTI

; ******************************
; *** multi-keyboard support ***
; ******************************
kbd_isr:
	LDX kb_type
	JMP (kbd_drv, X)		; CMOS only
; drivers pointer list
kbd_drv:
	.word	drv_pask
	.word	drv_5x8
; generic PASK driver
drv_pask:
	LDA IO9pask				; PASK peripheral address
	STA kb_asc				; store for software
	RTS

#include "../../OS/macros.h"
; EMPTY definition from abi.h
#define	EMPTY	6
#define	SAFE
-conio:
#include "../../OS/firmware/modules/conio-durango-fast.s"

; keyboard driver
#ifdef	KBDMAT
#include "../../OS/firmware/modules/durango-5x8key.s"
#endif

; ************************************************
; *** padding, signatures and hardware vectors ***
; ************************************************

	.dsb	$FFD6-*, $FF
	.asc	"DmOS"			; minimOS-compliant Durango-X cartridge signature
	.dsb	$FFDE-*, $FF
	.word	$FFFF			; Fletcher-16 checksum placeholder (not currently used)
	SEI
	JMP ($FFFC)				; devCart support @ $FFE1!

	.dsb	$FFFA-*, $FF

	.word	nmi				; standard 6502 hardware vectors
	.word	reset
	.word	irq

