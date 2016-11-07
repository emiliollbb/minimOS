; minimOS·16 generic Kernel
; v0.5.1a6
; (c) 2012-2016 Carlos J. Santisteban
; last modified 20161107-1329

#define	C816	_C816
; avoid standalone definitions
#define		KERNEL	_KERNEL

; uncomment in case of separate, downloadable jump & boot files
; should assume standalone assembly!!! (will get drivers anyway)
;#define		DOWNLOAD	_DOWNLOAD

; in case of standalone assembly
#ifndef	HEADERS
#include "usual.h"
.bss
#ifdef		DOWNLOAD
* = $0400				; safe address for patchable 2 kiB systems, change if required
#else
#include "drivers/config/DRIVER_PACK.h"
-user_sram = *
#include "drivers/config/DRIVER_PACK.s"
* = ROM_BASE			; just a placeholder, no standardised address
#endif
.text
#endif

; **************************************************
; *** kernel begins here, much like a warm reset ***
; **************************************************

warm:
	CLI				; interrupts off, just in case
	CLD				; do not assume anything
	SEC
	XCE				; set emulation mode for a moment! will reset to 8-bit registers
; assume interrupts off, binary mode and 65C816 in emulation mode!
	CLC
	XCE				; enter native mode! still 8 bit regs, though

; worth going 16-bit for the install calls?
; install kernel jump table if not previously loaded
#ifndef		DOWNLOAD
	LDY #<k_vec		; get table address, nicer way (2+2)
	LDA #>k_vec
	STY ex_pt		; store parameter (3+3)
	STA ex_pt+1
	_ADMIN(INSTALL)	; copy jump table (14...)
#endif

; install ISR code (as defined in "isr/irq.s" below)
	LDY #<k_isr		; get address, nicer way (2+2)
	LDA #>k_isr
	STY ex_pt		; no need to know about actual vector location (3)
	STA ex_pt+1
	_ADMIN(SET_ISR)	; install routine (14...)

; Kernel no longer supplies default NMI, but could install it otherwise

	STZ sd_flag		; this is important to be clear (PW_STAT) or set as proper error handler

; *****************************
; *** memory initialisation ***
; *****************************
	.al: REP #$20	; *** 16-bit memory most of the time ***
	LDY #FREE_RAM	; dirty trick no longer allowed...
	STY ram_stat	; as it is the first entry, no index needed
	LDY #END_RAM	; also for end-of-memory marker
	STY ram_stat+2	; note offset for interleaved array!
	LDX #>user_ram	; beginning of available ram, as defined... in rom.s
	LDY #<user_ram	; LSB misaligned?
	BEQ ram_init	; nothing to align
		INX				; otherwise start at next page
ram_init:
	TXA				; will set MSB as zero
	STA ram_pos		; store it
	LDA #SRAM		; number of SRAM pages as defined in options.h
	STA ram_pos+2	; store second entry and we are done!

; ******************************************************
; intialise drivers from their jump tables
; ******************************************************
; THINK about making API entries for this!

; set some labels, much neater this way
; globally defined da_ptr is a pointer for indirect addressing, new CIN/COUT compatible 20150619, revised 20160413
; same with dr_aut, now independent kernel call savvy 20161103
; 16-bit revamp 20161013

	LDX #0				; reset driver index (2)
	STX dpoll_mx		; reset all indexes (4+4+4)
	STX dreq_mx
	STX dsec_mx
; already in 16-bit memory mode...
	LDA #dr_error			; make unused entries point to a standard error routine (3)
dr_clear:
		STA drv_opt, X			; set full pointer for output (5)
		STA drv_ipt, X			; and for input (5)
		INX						; gANDo for next entry (2+2)
		INX
		BNE dr_clear			; finish page (3/2)

; *** in non-multitasking systems, install embedded TASK_DEV driver ***
#ifndef	MULTITASK
	LDA #st_taskdev		; pseudo-driver full address -- standard label on api16.s
	STA drv_opt			; *** assuming TASK_DEV = 128, index otherwise
#endif
; might do something similar for WIND_DEV = 129...

; first get the pointer to each driver table
dr_loop:
		PHX					; keep current value (3)
		LDA drivers_ad, X	; get full address (5)
		BNE dr_inst			; cannot be zero, in case is too far for BEQ dr_ok (3/2)
			JMP dr_ok			; all done otherwise (0/4)
dr_inst:
		STA da_ptr			; store full pointer (4)
; create entry on IDs table
		LDY #D_ID			; offset for ID (2)
		LDA (da_ptr), Y		; get ID code... plus extra byte (6)
#ifdef	SAFE
		AND #$00FF			; just keep LSB (3)
		CMP #$0080			; check sign (3)
		BCS dr_phys			; only physical devices (3/2)
			JMP dr_abort		; reject logical devices (3)
dr_phys:
#endif
		ASL					; convert to index, no matter the MSB (2+2)
		TAX
; new 161014, TASK_DEV (128 turns into 0 as index) does NOT get checked, allowing default installation
		BEQ dr_empty
; alternative in case of WIND_DEV managed similarly
;		CPX #4				; first index that will be managed normally
;		BCC dr_empty		; 0 & 2 (TASK_DEV & WIND_DEV) will NOT be checked from default installation
			LDA #dr_error		; will look for this address (3)
			CMP drv_opt, X		; check whether in use (5)
				BNE dr_busy			; pointer was not empty (2/3)
			CMP drv_ipt, X		; now check input, just in case (5)
			BEQ dr_empty		; it is OK to set (3/2)
dr_busy:
			JMP dr_abort		; already in use (3)
dr_empty:
		LDY #D_COUT			; offset for output routine (2)
		LDA (da_ptr), Y		; get full address (6)
		STA drv_opt, X		; store full pointer in table (5)
		LDY #D_CIN			; same for input routine (2)
		LDA (da_ptr), Y		; get full address (6)
		STA drv_ipt, X		; store full pointer in table (5)

; register interrupt routines (as usual)
		LDY #D_AUTH			; offset for feature code (2)
		LDA (da_ptr), Y		; get auth code... plus extra byte (6)
		STA dr_aut			; and keep for later! (4)
		BIT #A_POLL			; check whether D_POLL routine is avaliable (2)
		BEQ dr_nopoll		; no D_POLL installed (2/3)
			LDY #D_POLL			; get offset for periodic vector (2)
			LDX dpoll_mx		; get destination index (4)
			CPX #MAX_QUEUE		; compare against limit (2)
				BCS dr_abort		; error registering driver! (2/3) nothing was queued
			LDA (da_ptr), Y		; get full pointer bytes (6)
			STA drv_poll, X		; store word in list (5)
			INX					; increase index (2+2)
			INX
			STX dpoll_mx		; save updated index (4)
			LDA dr_aut			; get auth code... plus extra byte (4)
dr_nopoll:
		BIT #A_REQ			; check D_REQ presence (2)
		BEQ dr_noreq		; no D_REQ installed (2/3)
			LDY #D_REQ			; get offset for async vector (2)
			LDX dreq_mx			; get destination index (4)
			CPX #MAX_QUEUE		; compare against limit (2)
				BCS dr_ab_p			; error registering driver! (2/3) check poll!
			LDA (da_ptr), Y		; get full pointer (6)
			STA drv_async, X	; store word in list (5)
			INX					; increase index (2+2)
			INX
			STX dreq_mx			; save updated index  (4)
			LDA dr_aut			; get auth code... plus extra byte (4)
dr_noreq:
		BIT #A_SEC			; check D_SEC (2)
		BEQ dr_nosec		; no D_SEC installed (2/3)
			LDY #D_SEC			; get offset for 1-sec vector (2)
			LDX dsec_mx			; get destination index (4)
			CPX #MAX_QUEUE		; compare against limit (2)
				BCS dr_abpr		; error registering driver! (2/3) check poll & req!
			LDA (da_ptr), Y		; get full pointer (6)
			STA drv_sec, X		; store word in list (5)
			INX					; increase index (2+2)
			INX
			STX dsec_mx			; save updated index (4)
dr_nosec: 
; continue initing drivers
		JSR dr_icall		; call routine (6+...)
		.al: REP #$20		; *** 16-bit memory again, just in case ***
		.xs: SEP #$10		; *** 8-bit indexes, again just in case ***
		BCC dr_next			; did not failed initialisation
			LDY #D_AUTH
			LDA (da_ptr), Y		; get auth code... plus extra byte (6)
			BIT #A_SEC			; any slow?
			BNE dr_abpr			; none to remove
				DEC dsec_mx			; otherwise remove from queue!
				DEC dsec_mx			; two-byte pointer
dr_abpr:
			BIT #A_REQ			; any async?
			BNE dr_ab_p			; none to remove
				DEC dreq_mx			; otherwise remove from queue!
				DEC dreq_mx			; two-byte pointer
dr_ab_p:
			BIT #A_POLL			; any jiffy?
			BNE dr_abort		; none to remove
				DEC dpoll_mx		; otherwise remove from queue!
				DEC dpoll_mx		; two-byte pointer
dr_abort:
			LDY #D_ID			; offset for ID (2)
			LDA (da_ptr), Y		; get ID code... plus extra (6)
#ifdef	SAFE
			BIT #$0080			; check whether it was a valid physical device, negative LSB (
				BEQ dr_next			; nothing to delete (2/3)
#endif
			ASL					; use retrieved ID as index (2+2)
			TAX					; will keep LSB only
			LDA #dr_error		; make deleted entries point to a standard error routine (3)
			STA drv_opt, X		; set full pointer for output (5)
			STA drv_ipt, X		; and for input (5)
dr_next:
; in order to keep drivers_ad in ROM, can't just forget unsuccessfully registered drivers...
; in case drivers_ad is *created* in RAM, dr_abort could just be here, is this OK with new separate pointer tables?
		PLX					; retrieve saved index (4)
		INX					; update ADDRESS index, even if unsuccessful (2)
		INX					; eeeeeeeek! pointer arithmetic! (2)
		JMP dr_loop			; go for next (3)

dr_error:
	_DR_ERR(N_FOUND)	; standard exit for non-existing drivers!

dr_icall:
	LDY #D_INIT			; original pointer offset (2)
; *** generic driver call, pointer set at da_ptr, Y holds table offset
; *** assume 16-bit memory and 8-bit indexes ***
; takes 7 bytes (could be 2 less) 21 clocks, was 10 bytes, 29 clocks
dr_call:
	LDA (da_ptr), Y		; destination pointer MSB (6)
	DEC					; one less for RTS (2)
	PHA					; push it (4)
	.as: SEP #$20		; make sure driver is called in 8-bit size (3)
	RTS					; actual CORRECTED jump (6)

dr_ok:					; *** all drivers inited ***
	PLX					; discard stored X, beware of 16-bit memory!

; **********************************
; ********* startup code ***********
; **********************************

; reset several remaining flags
	STZ cin_mode	; reset binary mode flag, new 20150618

; *** set default SIGTERM handler for single-task systems, new 20150514 ***
; **** since shell will be launched via proper B_FORK & B_EXEC, do not think is needed any longer!
; could be done always, will not harm anyway
#ifndef		MULTITASK
	LDA #sig_kill	; get default routine full address, we are still in 16-bit memory
	STA mm_term		; store in new system variable
#endif

; **********************************
; startup code, revise ASAP
; **********************************

; *** set default I/O device *** still in 16-bit memory
	LDA #DEVICE*257		; as defined in options.h **** revise as it might be different for I and O
	STA default_in	; should check some devices, this assumes _in is LSB
; do not forget setting local devices via B_EXEC

; *** interrupt setup no longer here, firmware did it! *** 20150605

; ******************************
; **** launch monitor/shell ****
; ******************************
	_KERNEL(B_FORK)		; reserve first execution braid
	CLI					; enable interrupts, this is the right time
	LDX #'V'			; assume shell code is 65816!!! ***** REVISE
	STX cpu_ll			; architecture parameter
.al						; I do not know why is this needed
	LDA #shell			; pointer to integrated shell!
	STA ex_pt			; set execution full address
	LDA #DEVICE*257			; revise as above *****
	STA def_io			; default LOCAL I/O
	_KERNEL(B_EXEC)		; go for it!

	JMP lock			; ...as the scheduler will detour execution

; place here the shell code, must end in FINISH macro
shell:
#include "shell/SHELL"

; *** generic kernel routines, now in separate file 20150924 *** new filenames
#ifndef	LOWRAM
#ifndef		C816
#include "api.s"
#else
#include "api16.s"
#endif
#else
#include "api_lowram.s"
#endif

; *** new, sorted out code 20150124 ***
; *** interrupt service routine ***

k_isr:
#ifndef	C816
#include "isr/irq.s"
#else
#include "isr/irq16.s"
#endif

; default NMI-ISR is on firmware!
