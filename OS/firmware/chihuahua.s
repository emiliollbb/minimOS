; firmware for minimOS on Chihuahua PLUS (and maybe others)
; v0.9.6b5
; (c)2015-2018 Carlos J. Santisteban
; last modified 20180131-1051

#define		FIRMWARE 	_FIRMWARE

#include "usual.h"

; already set at FW_BASE via rom.s

.(
#ifndef	NOHEAD
; *** first some ROM identification *** new 20150612
; this is expected to be loaded at an aligned address anyway
fw_start:
	.asc	0, "m", CPU_TYPE			; standard system file wrapper, new format 20161010, experimental type
	.asc	"****", CR					; flags TBD
	.asc	"boot", 0					; standard filename
fw_splash:
	.asc	"0.9.6b5 firmware for "	; machine description as comment
fw_mname:
	.asc	MACHINE_NAME, 0
; advance to end of header
	.dsb	fw_start + $F8 - *, $FF	; for ready-to-blow ROM, advance to time/date field

; *** date & time in MS-DOS format at byte 248 ($F8) ***
	.word	$7000	; time, 13.00
	.word	$4AC2	; date, 2017/6/2

fwSize	=	fw_end - fw_start - 256	; compute size NOT including header!

; filesize in top 32 bits NOT including header, new 20161216
	.word	fwSize			; filesize
	.word	0				; 64K space does not use upper 16-bit
; *** end of standard header ***
#else
; if no headers, put identifying strings somewhere
fw_splash:
	.asc	"0.9.6b5 FW @ "
fw_mname:
	.asc	MACHINE_NAME, 0		; store the name at least
#endif

; *********************************
; *********************************
; *** administrative jump table *** changing
; *********************************
; *********************************
fw_admin:
; generic functions, esp. interrupt related
	.word	gestalt		; GESTALT get system info (renumbered)
	.word	set_isr		; SET_ISR set IRQ vector
	.word	set_nmi		; SET_NMI set (magic preceded) NMI routine
	.word	set_dbg		; SET_DBG set debugger, new 20170517
	.word	jiffy		; JIFFY set jiffy IRQ speed
	.word	irq_src		; IRQ_SOURCE get interrupt source in X for total ISR independence

; pretty hardware specific
	.word	poweroff	; POWEROFF power-off, suspend or cold boot
	.word	freq_gen	; *** FREQ_GEN frequency generator hardware interface, TBD

; not for LOWRAM systems
#ifndef	LOWRAM
	.word	install		; INSTALL copy jump table
	.word	patch		; PATCH patch single function (renumbered)
	.word	context		; *** CONTEXT context bankswitching
#else
#ifdef	SAFE
	.word	missing		; these three functions not implemented on such systems
	.word	missing
	.word	missing

missing:
		_DR_ERR(UNAVAIL)	; return some error while trying to install or patch!
#endif
#endif


; ********************
; ********************
; *** cold restart ***
; ********************
; ********************

; *** basic init *** save a few bytes as Chihuahua is unlikely to use a 65816
reset:
#include "firmware/modules/basic_init02.s"

; ******************************
; *** minimal hardware setup ***
; ******************************

; check for VIA presence and disable all interrupts
#include "firmware/modules/viacheck_irq.s"

; *********************************
; *** optional firmware modules ***
; *********************************

; optional boot selector
;#include "firmware/modules/bootoff.s"

; might check ROM integrity here
;#include "firmware/modules/romcheck.s"

; Chihuahua has no ROM-in-RAM feature!


; basic startup beep
#include "firmware/modules/beep.s"

; SRAM test
#include "firmware/modules/ramtest.s"

; ********************************
; *** hardware interrupt setup ***
; ********************************

; VIA initialisation (and stop beeping)
#include "firmware/modules/via_init.s"

; ***********************************
; *** firmware parameter settings ***
; ***********************************

; *** set default CPU type ***
; just set expected default type as defined in options.h...
;#include "firmware/modules/default_cpu.s"
; ...or actually check for it!
#include "firmware/modules/cpu_check.s"
; do NOT include both files at once!

; in case an NMOS CPU is used, make sure this was built for it
#include "firmware/modules/nmos_savvy.s"

; *** continue parameter setting ***
; preset kernel start address
#include "firmware/modules/kern_addr.s"

; preset default BRK handler
#include "firmware/modules/brk_addr.s"

; no need to set NMI as it will be validated


; preset jiffy irq frequency
#include "firmware/modules/jiffy_hz.s"

; reset jiffy count
#include "firmware/modules/jiffy_rst.s"

; reset last installed kernel (new)
#include "firmware/modules/rst_lastk.s"

; *** direct print splash string code comes here, when available ***


; *** optional network booting ***
; might modify the contents of fw_warm
;#include "firmware/modules/netboot.s"

; ************************
; *** start the kernel ***
; ************************
start_kernel:
	JMP (fw_warm)		; (6)


; ********************************
; ********************************
; ****** interrupt handlers ******
; ********************************
; ********************************

; **********************************************
; *** vectored NMI handler with magic number *** eeeeeeeeeeeeeek
; **********************************************
nmi:
#include "firmware/modules/nmi_hndl.s"

; ****************************
; *** vectored IRQ handler ***
; ****************************
; nice to be here, but might go elsewhere in order to save space, like between FW interface calls
irq:
	JMP (fw_isr)		; vectored ISR (6)

; ***************************
; *** minimOS BRK handler ***
; ***************************
brk_hndl:				; label from vector list
#include "firmware/modules/brk_hndl.s"


; ********************************
; ********************************
; *** administrative functions ***
; ********************************
; ********************************

; *** generic functions ***

; *********************************
; GESTALT, get system info, API TBD
; *********************************
gestalt:
#include "firmware/modules/gestalt.s"

; ***********************
; SET_ISR, set IRQ vector
; ***********************
set_isr:
#include "firmware/modules/set_isr.s"

; ********************************
; SET_NMI, set NMI handler routine
; ********************************
set_nmi:
#include "firmware/modules/set_nmi.s"

; ********************************
; SET_DBG, set BRK handler routine
; ********************************
set_dbg:
#include "firmware/modules/set_dbg.s"

; ***************************
; JIFFY, set jiffy IRQ period
; ***************************
jiffy:
#include "firmware/modules/jiffy.s"

; ****************************************
; IRQ_SRC, investigate source of interrupt
; ****************************************
; notice non-standard ABI, same module as 6502 version!
irq_src:
#include "firmware/modules/irq_src.s"

; *** hardware specific ***

; **********************
; POWEROFF, shutdown etc *** TBD
; **********************
poweroff:
#include "firmware/modules/poweroff.s"

; ***********************************
; FREQ_GEN, generate frequency at PB7 *** TBD
; ***********************************
freq_gen:
;#include "firmware/modules/freq_gen16.s"
	_DR_ERR(UNAVAIL)	; not yet implemented

; *** other functions with RAM enough ***
#ifndef		LOWRAM
; **************************
; INSTALL, supply jump table
; **************************
install:
#include "firmware/modules/install.s"

; ****************************
; PATCH, patch single function
; ****************************
patch:
#include "firmware/modules/patch.s"

; *****************************************
; CONTEXT, hardware switch zeropage & stack
; *****************************************
context:
	_DR_ERR(UNAVAIL)	; Chihuahua has nothing about this
#endif

; ----------------------- OLD CODE ---------------------------


; ***********************************
; FREQ_GEN, generate frequency at PB7
; ***********************************
; ****** T B D ******
fw_fgen:
	_DR_ERR(UNAVAIL)		; not supported

; these are for systems with enough RAM

#ifndef		LOWRAM
; **************************
; INSTALL, supply jump table
; **************************
;		INPUT
; kerntab	= address of supplied jump table

fw_install:
	LDY #0				; reset index (2)
	_CRITIC				; disable interrupts! (5)
fwi_loop:
		LDA (kerntab), Y	; get from table as supplied (5)
		STA fw_table, Y		; copy where the firmware expects it (4+2)
		INY
		CPY #LAST_API		; EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEK
		BNE fwi_loop		; until whole page is done (3/2)
	_NO_CRIT			; restore interrupts if needed (4)
	_DR_OK				; all done (8)

; ****************************
; PATCH, patch single function
; ****************************
;		INPUT
; kerntab	= address of code
; Y		= function to be patched

fw_patch:
	LDA kerntab				; get LSB (3)
	LDX kerntab+1			; same for MSB (3)
	_CRITIC					; disable interrupts! (5)
	STA fw_table, Y			; store where the firmware expects it (4+4)
	TXA						; eeeeeeeeeeeek
	STA fw_table+1, Y
	_NO_CRIT				; restore interrupts if needed (4)
	_DR_OK					; done (8)

; ****************************
; CONTEXT, not supported here!
; ****************************

f_unavail:
	_DR_ERR(UNAVAIL)		; not supported

#endif

; WILL CHANGE

; **** some strange data ****
fw_map:
	.word	0		; PLACEHOLDER FOR MEMORY MAP

; *********************************************
; *********************************************
; *** experimental blinking of CapsLock LED ***
; *********************************************
; *********************************************
led_lock:
; make sure PB3 is output and device $Bx is selected, just in case
; should toggle PB7 too with CB2 high, for a clicking sound****
	LDA VIA+DDRB		; original direction
	ORA #%11111001		; desired outputs
	STA VIA+DDRB		; set on VIA
; intial value selects $D8 device (LCD on keyboard, E down and LED on)
	LDA #%11011000
ll_tog:
		STA VIA+IORB		; turn LED on, LCD will not disturb
ll_loop:
				INX			; inner loop (2)
				NOP			; add some delay (2+2)
				NOP
				BNE ll_loop		; inner takes 2303t (3)
			INY			; outer loop (2)
			BNE ll_loop		; full loop is ~0.59s @ 1 MHz (3)
		EOR #%00001000		; toggle PB3
		_BRA ll_tog		; switch and continue forever


; ******************************************************************
; ****** the following will come ALWAYS at standard addresses ****** last 64 bytes
; ******************************************************************

; filling for ready-to-blow ROM
#ifdef		ROM
	.dsb	kerncall-*, $FF
#endif

; *** minimOS function call primitive ($FFC0) ***
* = kerncall
	_JMPX(fw_table)	; macro for NMOS compatibility (6)

; as 8-bit systems use std call for U_ADM, no $FFC8 wrapper

; filling for ready-to-blow ROM
#ifdef		ROM
	.dsb	adm_call-*, $FF
#endif

; *** administrative meta-kernel call primitive ($FFD0) ***
* = adm_call
	_JMPX(fw_admin)		; takes 6 clocks with CMOS

; this could be a good place for the IRQ handler...

; filling for ready-to-blow ROM
#ifdef	ROM
	.dsb	lock-*, $FF
#endif

; *** panic routine, locks at very obvious address ($FFE1-$FFE2) ***
; alternatively, blink CapsLock LED!
* = lock
	SEI					; unified procedure like 6800
; classic way
panic_loop:
	_BRA panic_loop		; no problem if /SO is used
; ** alternative way **
;	JMP led_lock		; start CapsLock blinking!

; filling for ready-to-blow ROM
#ifdef	ROM
	.dsb	$FFFA-*, $FF
#endif

; once again, CHIHUAHUA is very unlikely to use a 65816
; *** 65(C)02 ROM vectors ***
* = $FFFA				; just in case
	.word	nmi			; NMI	@ $FFFA
	.word	reset		; RST	@ $FFFC
	.word	irq			; IRQ	@ $FFFE

fw_end:					; for size computation
.)
