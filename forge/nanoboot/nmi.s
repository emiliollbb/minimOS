; nanoBoot NMI handler for 6502 v0.3a1
; (c) 2018-2020 Carlos J. Santisteban
; last modified 20201226-1234

nb_nmi:
; received bits should be LSB first!
	SEC					; bits are on by default (2)
	PHA					; preserve A, as ISR will change it! (3)
	CLI					; enable interrupts for a moment (2...)
; if /IRQ was low, ISR will clear C, thus injecting a zero
	SEI					; what happened? (2)
	PLA					; retrieve A, but C won't be affected (4)
	ROR nb_rcv			; inject C into byte, LSB first (5)
	DEC nb_flag			; this will turn 0 when done, if preloaded with 8 (5)
	RTI					; (6) total 29, plus ISR
; ISR takes 7 clocks to acknowledge, plus 17 clocks itself, that's 24 for a grand total (including NMI ack) of 60 clocks per bit worst case

