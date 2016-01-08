; minimOS 0.4a2 zero-page system variables - SDx, 6502
; (c) 2012-2013 Carlos J. Santisteban
; last modified 2013.02.06

.zero

; user space
* = 0

reserved	.word	0	; reserved for 6510
zp_used		.byt	0	; user-reserved space in ZP
user:				; user space starts here... 

; kernel parameters
* = $EC

z10		.dsb	4	; up to 4 bytes, including older z10L and z10W
z6		.dsb	4
z2		.dsb	4
sysvec		.word	0	; ZP pointer for interrupts etc
sysvar		.byt	0	; variable for interrupts etc
sys_sp		.byt	0	; stack pointer for context switch
signature	.asc	"mOS*"	; process' short name

