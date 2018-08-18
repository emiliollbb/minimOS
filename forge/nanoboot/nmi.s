; nanoBoot NMI handler for 6502
; (c) 2018 Carlos J. Santisteban
; last modified 20180818-1016

-nb_nmi:
	SEC
	ROL nb_rcv			; prepare for next bit, initially on (2+5)
	CLI					; enable IRQ for a moment... (2)
;	SEI					; ...and disable it back! (2)
; do not know if keeping IRQ low will retrigger the interrupt
; perhaps ISR should alter saved status masking I, thus this SEI is not needed
; will affect X, not sure if worth saving it
	ROR nb_flag			; this will set bit 7 accordingly (5)
	RTI					; (6) total 22 clocks + ISR
