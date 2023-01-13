; nanoLink NMI handler for transparent reception
; (c) 2023 Carlos J. Santisteban
; last modified 20230113-1034

; *****************************************
; *** NMI handler for nanoLink receiver ***
; input
;	sys_sp	= 8 to enable, 0 to disable
;	sysptr	= pointer to receive buffer
; *****************************************

rcv_nmi:
.(
	STZ IOAie				; disable hardware interrupt ASAP (4+ACK)
	PHA						; save reg (3, total 7+)
	LDA sys_sp				; check current state (optional, usually 5t, total 12+)
		BEQ disabled		; do not disturb operation if disabled
	ASL systmp				; make room into received value (5, 17+)
	LDA fw_irq+1
	PHA
	LDA fw_irq
	PHA						; save previous IRQ vector (14, 31+)
	LDA #<rcv_irq
	STA fw_irq
	LDA #>rcv_irq
	STA fw_irq+1			; point to specific nanoLink IRQ handler (12, 43+)
	CLI						; enable interrupt... (2, 45+)
; *** IRQ is executed if bit is 1, takes 27 extra t ***
; MUST return with interrupts disabled in stacked P!
	SEI						; ...and disable it, in case no IRQ was called! (2, 47+ if 0, 74+ if 1)
	PLA
	STA fw_irq
	PLA 
	STA fw_irq+1			; restore interrupt vector (16, 63+ if 0, 90+ if 1)
	LDA #1					; odd value to enable interrupts (2, 65+ if 0, 92+ if 1)
	DEC sys_sp				; one bit less to go (5, 70+ if 0, 97+ if 1)
	BNE no_byte				; not yet complete (usually 3, 73+ if 0, 100+ if 1) (*or 2, 72+ if 0, 99+ if 1)
		LDA systmp			; get read value (*3, 75+ if 0, 102+ if 1)
		STA (sysptr)		; and store into buffer, CMOS only (*5, 80+ if 0, 107+ if 1)
		LDA #8				; reset value for bit counter (*2, 82+ if 0, 109+ if 1)
		INC sysptr			; advance into buffer (*5, 87+ if 0, 114+ if 1)
		BNE no_wrap			; (*typically 3, 90+ if 0, 117+ if 1) (**or 2, 89+ if 0, 116+ if 1)
			INC sysptr+1	; page crossing (**5, 94+ if 0, 121+ if 1)
no_wrap:
		STA sys_sp			; eeeeek (*3, 93+ if 0, 120+ if 1) (**97+ if 0, 124+ if 1)
		DEC					; correction needed to allow 0 as disable function (*2, 95+ if 0, 122+ if 1) (**99+ if 0, 126+ if 1)
no_byte:
	STA IOAie				; odd value reenables interrupt (4, 77+ if 0, 104+ if 1) (*99+ if 0, 126+ if 1) (**103+ if 0, 130+ if 1)
disabled:
	PLA						; (4+6, 87+ if 0, 114+ if 1) (*109+ if 0, 136+ if 1) (**113+ if 0, 140+ if 1)
	RTI

; *************************************************
; *** IRQ handler for nanoLink *** total 20t+7t ACK
; *************************************************
rcv_irq:
	INC systmp				; LSB was 0, won't affect anything else (5)
	PLA						; get saved PSR, A was meaningless (4)
	ORA #$04				; disable saved interrupts (2)
	PHA						; restack corrected PSR (3)
	RTI						; (6)
.)
