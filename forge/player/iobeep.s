; music player for breadboard!
; (c) 2021 Carlos J. Santisteban
; last modified 20210303-1638

; *** required variables (not necessarily in ZP) ***

	.zero

	* = 3					; minimOS-savvy ZP address

cur		.byt	0			; current score position

	.text

; *** player code ***

	* = $400				; downloadable version

	SEI						; standard init
	CLD
	LDX #$FF
	TXS

	STX $FFF0				; turn off display, just in case

; *** experimntal code ***
; sweep for pacman eating ghost ** OK
/*	LDA #0
	STA cur
sweep:
		LDX #8
		JSR mt_beep
		DEC cur
		DEC cur
		DEC cur
		DEC cur
		LDA cur
		CMP #16
		BNE sweep
*/
; pacman death
	LDA #100	; initial freq
	LDY #86		; top freq
	LDX #36		; length
	JSR squeak
	LDA #118	; initial freq
	LDY #104	; top freq
	LDX #32		; length
	JSR squeak
	LDA #127
	LDY #111
	LDX #28
	JSR squeak
	LDA #136
	LDY #117
	LDX #24
	JSR squeak
	LDA #144
	LDY #124
	LDX #22
	JSR squeak
; last two sweeps ** OK
	LDA #2
	STA cur+1	; iteration
d_rpt:
	LDA #255
	STA cur
send:
		LDX #10
		JSR mt_beep
		LDA cur
		SEC
		SBC #24
		STA cur
		CMP #15
		BCS send
	JSR ms74
; next iteration
	DEC cur+1
	BNE d_rpt
	JMP end
; ************************
	INX						; now it's zero
	STX cur					; reset cursor (or use STZ)
loop:
		LDY cur				; get index
		LDA len, Y			; get length from duration array
			BEQ end			; length=0 means END of score
		TAX
		LDA note, Y			; get note period (10A+20 t) from its array
		BEQ rest			; if zero, no sound!

		JSR mt_beep			; call beep! (no longer inlined)

		BEQ next			; go for next note

; **************************
; *** ** rest routine ** *** inlined
; ***     X = length     ***
; ***    t = X 1.28 ms   ***
; **************************
rest:
		TAY					; if period is zero for rests, this resets the counter
r_loop:
			INY
			BNE r_loop		; this will take ~ 1.28 ms
		DEX					; continue
		BNE rest
; **************************

next:
		INC cur				; advance cursor to next note
		BNE loop
end:
	LDA #%01100101			; put dashes on display
	STA $FFF0
	BNE end					; *** repeats at the end ***

; support routines
; *****************************
; *** ** beeping routine ** *** no longer inlined
; *** X = length, A = freq. ***
; *** tcyc = 10 A + 20      ***
; *****************************
mt_beep:
		TAY				; determines frequency (2)
		STX $BFF0		; send X's LSB to beeper (4)
rb_zi:
			DEY			; count pulse length (y*2)
			BNE rb_zi	; stay this way for a while (y*3-1)
		DEX				; toggles even/odd number (2)
		BNE mt_beep		; new half cycle (3)
	STX $BFF0			; turn off the beeper!
	RTS
; *****************************

; ~74 ms delay
ms74:
	LDY #198
delay:
		INX
		BNE delay
		INY
		BNE delay
	RTS

; squeak, get higher then lower
; cur=current, cur+1=initial, cur+2=final, cur+3=length
squeak:
	STA cur+1
	STA cur		; and current
	STY cur+2
	STX cur+3
peak1:
		LDX cur+3
		JSR mt_beep
		DEC cur
		DEC cur
		LDA cur
		CMP cur+2
		BNE peak1
peak:
		LDX cur+3
		JSR mt_beep
		INC cur
		INC cur
		LDA cur
		CMP cur+1
		BNE peak
	RTS

; *******************
; *** music score ***
; *******************
; PacMan theme for testing

; array of lengths (rests are computed like G5)
len:
	.byt	 70,  52, 140,  52, 104,  52,  88,  52, 140, 104, 104, 176, 104
	.byt	 74,  52, 148,  52, 110,  52,  92,  52, 148, 110, 104, 184, 104
	.byt	 70,  52, 140,  52, 104,  52,  88,  52, 140, 104, 104, 176, 104
	.byt	 82,  88,  92,  52,  92,  98, 104,  52, 104, 110, 116,  52, 255, 130,   0	; *** end of score ***

; array of notes (rests are 0)
note:
	.byt	190,   0,  94,   0, 126,   0, 150,   0,  94, 126,   0, 150,   0
	.byt	179,   0,  88,   0, 118,   0, 141,   0,  88, 118,   0, 141,   0
	.byt	190,   0,  94,   0, 126,   0, 150,   0,  94, 126,   0, 150,   0
	.byt	159, 150, 141,   0, 141, 133, 126,   0, 126, 118, 112,   0,  94,   0		; no need for extra byte as will be discarded
