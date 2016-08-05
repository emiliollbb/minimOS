; minimOS ZX tape interface loader!
; v0.1a2
; (c) 2016 Carlos J. Santisteban
; last modified 20160805-1301

; ***** Load block of bytes at (data_pt), size stored at data_size *****
; ****   ONLY if enabled by setting 'flag' to look for data ($FF) ****
; ****   otherwise will wait for the discarded block to end without loading ****
; ****   because it will keep looking for a header ($00) ****
; ***** If detected, 17 byte header gets loaded at (data_pt) *****
; ****   because flag is set to look for a header ($00) ****

; *** needed data ***
; ddrx = VIA DDRx
; px6in = VIA IORx, easy detection via BIT instruction (V) though not used!
; speedcode = stores CPU speed in fixed point format ($10 = 1 MHz)
 mask = %01000000  ; preset for bit 6 but change otherwise
 
; *** zeropage ***
; pointer (word)
; length (word) is best on ZP
; last will actually hold the relevant bit read from the port
; sys_sp is safe to use when interrupts are disabled

; *** REFERENCE: pulse lengths ***
; guide tone = 619/619 uS
; sync = 191/210 uS
; zero = 244/244 uS
; one = 489/489 uS

; *** ADVICE ***
; wait about 102 uS before entering timing loop
; compare against 686 uS ???
; other looks for 314 uS? (one vs zero?)
; 'ld edge 1' takes 133 uS + 17 for each failed pass
;   and will return with NO Carry if no edge found within 4 mS
;     otherwise wait for a second and continue if TWO edges within time frame (ld edge 2)
;   now accept only guide, timing $9C, but edges must be within 857 uS (B=$C6)
;     needs at least 256 pairs
;   for sync, timing is $C9 waiting for a single short edge (ld edge 1)
;     keep waiting aginst $D4, call 'ld edge 1' again for the other edge
;   reading bits use timing $B0 ($B2 for flag?)
; * two pulses in less than 713 uS means 0, otherwise 1, timeout after 1575 uS *

zx_load:

; disable interrupts!!!
	_ENTER_CS	; actually PHP and SEI
	
; initialise input port
	LDA ddrx	; previous data direction register on VIA
	AND #%10111111	; make sure bit 6 is input
	STA ddrx	; set direction, port is ready
	LDA px6in	; get whole byte
	AND #mask	; filter bit 6 or whatever
	STA last	; set initial value as only transitions will matter

; stub******stub******stub******stub

	LDA px6in	; get whole byte
	AND #mask	; filter bit 6 or whatever
	CMP last	; compare against previous value
	BEQ stay	; did not change, keep waiting and counting
		STA last	; update with new value
		; *** most likely exit loop
stay:
	; *** increase count and check for timeouts
