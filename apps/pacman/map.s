; initial map for Pacman
; (c) 2021 Carlos J. Santisteban
; last modified 20210318-1350

/*
; old format
; stored in 31 rows of 32 columns (28 cols actually used)
; 128=wall, 64=dot, 32=pill, +1=base

	.dsb	32, 128			; top row is all wall
	.byt	128, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,128,128, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,128,0,0,0,0	; 2
	.byt	128, 64,128,128,128,128, 64,128,128,128,128,128, 64,128,128, 64,128,128,128,128,128, 64,128,128,128,128, 64,128,0,0,0,0 ; 3
	.byt	128, 32,128,128,128,128, 64,128,128,128,128,128, 64,128,128, 64,128,128,128,128,128, 64,128,128,128,128, 32,128,0,0,0,0 ;*4
	.byt	128, 64,128,128,128,128, 64,128,128,128,128,128, 64,128,128, 64,128,128,128,128,128, 64,128,128,128,128, 64,128,0,0,0,0 ; 5
	.byt	128, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,128,0,0,0,0 ; 6
	.byt	128, 64,128,128,128,128, 64,128,128, 64,128,128,128,128,128,128,128,128, 64,128,128, 64,128,128,128,128, 64,128,0,0,0,0 ; 7
	.byt	128, 64,128,128,128,128, 64,128,128, 64,128,128,128,128,128,128,128,128, 64,128,128, 64,128,128,128,128, 64,128,0,0,0,0 ; 8
	.byt	128, 64, 64, 64, 64, 64, 64,128,128, 64, 64, 64, 64,128,128, 64, 64, 64, 64,128,128, 64, 64, 64, 64, 64, 64,128,0,0,0,0 ; 9
	.byt	128,128,128,128,128,128, 64,128,128,128,128,128,  0,128,128,  0,128,128,128,128,128, 64,128,128,128,128,128,128,0,0,0,0 ; 10
	.byt	128,128,128,128,128,128, 64,128,128,128,128,128,  0,128,128,  0,128,128,128,128,128, 64,128,128,128,128,128,128,0,0,0,0 ; 11
	.byt	128,128,128,128,128,128, 64,128,128,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,128, 64,128,128,128,128,128,128,0,0,0,0 ; 12
	.byt	128,128,128,128,128,128, 64,128,128,  0,128,128,128,129,129,128,128,128,  0,128,128, 64,128,128,128,128,128,128,0,0,0,0 ; 13
	.byt	128,128,128,128,128,128, 64,128,128,  0,128,129,129,129,129,129,129,128,  0,128,128, 64,128,128,128,128,128,128,0,0,0,0 ; 14
	.byt	  0,  0,  0,  0,  0,  0, 64,  0,  0,  0,128,129,129,129,129,129,129,128,  0,  0,  0, 64,  0,  0,  0,  0,  0,  0,0,0,0,0 ;=15
	.byt	128,128,128,128,128,128, 64,128,128,  0,128,129,129,129,129,129,129,128,  0,128,128, 64,128,128,128,128,128,128,0,0,0,0 ; 16
	.byt	128,128,128,128,128,128, 64,128,128,  0,128,128,128,128,128,128,128,128,  0,128,128, 64,128,128,128,128,128,128,0,0,0,0 ; 17
	.byt	128,128,128,128,128,128, 64,128,128,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,128,128, 64,128,128,128,128,128,128,0,0,0,0 ; 18
	.byt	128,128,128,128,128,128, 64,128,128,  0,128,128,128,128,128,128,128,128,  0,128,128, 64,128,128,128,128,128,128,0,0,0,0 ; 19
	.byt	128,128,128,128,128,128, 64,128,128,  0,128,128,128,128,128,128,128,128,  0,128,128, 64,128,128,128,128,128,128,0,0,0,0 ; 20
	.byt	128, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,128,128, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,128,0,0,0,0	; 21
	.byt	128, 64,128,128,128,128, 64,128,128,128,128,128, 64,128,128, 64,128,128,128,128,128, 64,128,128,128,128, 64,128,0,0,0,0 ; 22
	.byt	128, 64,128,128,128,128, 64,128,128,128,128,128, 64,128,128, 64,128,128,128,128,128, 64,128,128,128,128, 64,128,0,0,0,0 ; 23
	.byt	128, 32, 64, 64,128,128, 64, 64, 64, 64, 64, 64, 64,  0,  0, 64, 64, 64, 64, 64, 64, 64,128,128, 64, 64, 32,128,0,0,0,0 ;*24
	.byt	128,128,128, 64,128,128, 64,128,128, 64,128,128,128,128,128,128,128,128, 64,128,128, 64,128,128, 64,128,128,128,0,0,0,0 ; 25
	.byt	128,128,128, 64,128,128, 64,128,128, 64,128,128,128,128,128,128,128,128, 64,128,128, 64,128,128, 64,128,128,128,0,0,0,0 ; 26
	.byt	128, 64, 64, 64, 64, 64, 64,128,128, 64, 64, 64, 64,128,128, 64, 64, 64, 64,128,128, 64, 64, 64, 64, 64, 64,128,0,0,0,0	; 27
	.byt	128, 64,128,128,128,128,128,128,128,128,128,128, 64,128,128, 64,128,128,128,128,128,128,128,128,128,128, 64,128,0,0,0,0	; 28
	.byt	128, 64,128,128,128,128,128,128,128,128,128,128, 64,128,128, 64,128,128,128,128,128,128,128,128,128,128, 64,128,0,0,0,0	; 29
	.byt	128, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,128,0,0,0,0 ; 30
	.dsb	32, 128			; bottom row is all wall
*/

; NEW format, two tiles per byte, 16 colums per row (14 actually used)
; 128=wall-even, 64=dot-even, 32=pill-even, 16=base/tunnel-even
; 8=wall-odd, 4=dot-odd, 2=pill-odd, 1=base/tunnel-odd

	.dsb	16, %10001000	; top row is all wall
	.byt	%10000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01001000, %10000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01001000,136,136	; 2
	.byt	%10000100, %10001000, %10001000, %01001000, %10001000, %10001000, %01001000, %10000100, %10001000, %10001000, %10000100, %10001000, %10001000, %01001000,136,136	; 3
	.byt	%10000010, %10001000, %10001000, %01001000, %10001000, %10001000, %01001000, %10000100, %10001000, %10001000, %10000100, %10001000, %10001000, %00101000,136,136	;*4
	.byt	%10000100, %10001000, %10001000, %01001000, %10001000, %10001000, %01001000, %10000100, %10001000, %10001000, %10000100, %10001000, %10001000, %01001000,136,136	; 5
	.byt	%10000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01001000,136,136	; 6
	.byt	%10000100, %10001000, %10001000, %01001000, %10000100, %10001000, %10001000, %10001000, %10001000, %01001000, %10000100, %10001000, %10001000, %01001000,136,136	; 7
	.byt	%10000100, %10001000, %10001000, %01001000, %10000100, %10001000, %10001000, %10001000, %10001000, %01001000, %10000100, %10001000, %10001000, %01001000,136,136	; 8
	.byt	%10000100, %01000100, %01000100, %01001000, %10000100, %01000100, %01001000, %10000100, %01000100, %01001000, %10000100, %01000100, %01000100, %01001000,136,136	; 9
	.byt	%10001000, %10001000, %10001000, %01001000, %10001000, %10001000, %00001000, %10000000, %10001000, %10001000, %10000100, %10001000, %10001000, %10001000,136,136	; 10
	.byt	%10001000, %10001000, %10001000, %01001000, %10001000, %10001000, %00001000, %10000000, %10001000, %10001000, %10000100, %10001000, %10001000, %10001000,136,136	; 11
	.byt	%10001000, %10001000, %10001000, %01001000, %10000000, %00000000, %00000000, %00000000, %00000000, %00001000, %10000100, %10001000, %10001000, %10001000,136,136	; 12
	.byt	%10001000, %10001000, %10001000, %01001000, %10000000, %10001000, %10001001, %10011000, %10001000, %00001000, %10000100, %10001000, %10001000, %10001000,136,136	; 13
	.byt	%10001000, %10001000, %10001000, %01001000, %10000000, %10001001, %10011001, %10011001, %10011000, %00001000, %10000100, %10001000, %10001000, %10001000,136,136	; 14
	.byt	%00010001, %00010001, %00010001, %01000000, %00000000, %10001001, %10011001, %10011001, %10011000, %00000000, %00000100, %00010001, %00010001, %00010001, 17, 17	;=15
	.byt	%10001000, %10001000, %10001000, %01001000, %10000000, %10001001, %10011001, %10011001, %10011000, %00001000, %10000100, %10001000, %10001000, %10001000,136,136	; 16
	.byt	%10001000, %10001000, %10001000, %01001000, %10000000, %10001000, %10001000, %10001000, %10001000, %00001000, %10000100, %10001000, %10001000, %10001000,136,136	; 17
	.byt	%10001000, %10001000, %10001000, %01001000, %10000000, %00000000, %00000000, %00000000, %00000000, %00001000, %10000100, %10001000, %10001000, %10001000,136,136	; 18
	.byt	%10001000, %10001000, %10001000, %01001000, %10000000, %10001000, %10001000, %10001000, %10001000, %00001000, %10000100, %10001000, %10001000, %10001000,136,136	; 19
	.byt	%10001000, %10001000, %10001000, %01001000, %10000000, %10001000, %10001000, %10001000, %10001000, %00001000, %10000100, %10001000, %10001000, %10001000,136,136	; 20
	.byt	%10000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01001000, %10000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01001000,136,136	; 21
	.byt	%10000100, %10001000, %10001000, %01001000, %10001000, %10001000, %01001000, %10000100, %10001000, %10001000, %10000100, %10001000, %10001000, %01001000,136,136	; 22
	.byt	%10000100, %10001000, %10001000, %01001000, %10001000, %10001000, %01001000, %10000100, %10001000, %10001000, %10000100, %10001000, %10001000, %01001000,136,136	; 23
	.byt	%10000010, %01000100, %10001000, %01000100, %01000100, %01000100, %01000000, %00000100, %01000100, %01000100, %01000100, %10001000, %01000100, %00101000,136,136	;*24
	.byt	%10001000, %10000100, %10001000, %01001000, %10000100, %10001000, %10001000, %10001000, %10001000, %01001000, %10000100, %10001000, %01001000, %10001000,136,136	; 25
	.byt	%10001000, %10000100, %10001000, %01001000, %10000100, %10001000, %10001000, %10001000, %10001000, %01001000, %10000100, %10001000, %01001000, %10001000,136,136	; 26
	.byt	%10000100, %01000100, %01000100, %01001000, %10000100, %01000100, %01001000, %10000100, %01000100, %01001000, %10000100, %01000100, %01000100, %01001000,136,136	; 27
	.byt	%10000100, %10001000, %10001000, %10001000, %10001000, %10001000, %01001000, %10000100, %10001000, %10001000, %10001000, %10001000, %10001000, %01001000,136,136	; 28
	.byt	%10000100, %10001000, %10001000, %10001000, %10001000, %10001000, %01001000, %10000100, %10001000, %10001000, %10001000, %10001000, %10001000, %01001000,136,136	; 29
	.byt	%10000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01000100, %01001000,136,136	; 30
	.dsb	16, %10001000	; bottom row is all wall
