; *******************************
; *** scancode to ASCII tables***
; *******************************
; (c) 2012-2020 Carlos J. Santisteban
; last modified 20200306-0953

; cols 0...14, and inside rows 0...3
; note standard labels!

; unshifted
ak_traw:
	.byt	$20, $3C, $09, $BA,  $7A, $61, $71, $31,  $78, $73, $77, $32
	.byt	$63, $64, $65, $33,  $76, $66, $72, $34,  $62, $67, $74, $35
	.byt	$6E, $68, $79, $36,  $6D, $6A, $75, $37,  $2C, $6B, $69, $38
	.byt	$2E, $6C, $6F, $39,  $2D, $F1, $70, $30,  $0 , $B4, $60, $27
	.byt	$0 , $E7, $2B, $A1,  $0A, $0B, $0D, $08,  $0C, $0 , $7F, $1B

; caps lock
ak_tu:
	.byt	$20, $3C, $09, $BA,  $5A, $41, $51, $31,  $58, $53, $57, $32
	.byt	$43, $44, $45, $33,  $56, $46, $52, $34,  $42, $47, $54, $35
	.byt	$4E, $48, $59, $36,  $4D, $4A, $55, $37,  $2C, $4B, $49, $38
	.byt	$2E, $4C, $4F, $39,  $2D, $D1, $50, $30,  $0 , $B4, $60, $27
	.byt	$0 , $C7, $2B, $A1,  $0A, $0B, $0D, $08,  $0C, $0 , $7F, $1B

; shift (with or without caps lock)
ak_ts:
ak_tsu:
	.byt	$0 , $3E, $0 , $AA,  $5A, $41, $51, $21,  $58, $53, $57, $22
	.byt	$43, $44, $45, $B7,  $56, $46, $52, $24,  $42, $47, $54, $25
	.byt	$4E, $48, $59, $26,  $4D, $4A, $55, $2F,  $2C, $4B, $49, $28
	.byt	$2E, $4C, $4F, $29,  $2D, $D1, $50, $3D,  $0 , $A8, $5E, $3F
	.byt	$0 , $C7, $2A, $BF,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0

; alt
ak_ta:
	.byt	$A0, $96, $0 , $5C,  $99, $E5, $93, $7C,  $0 , $DF, $B8, $40
	.byt	$A2, $F0, $A4, $23,  $91, $0 , $B6, $A2,  $90, $BE, $97, $9C
	.byt	$0 , $0 , $A5, $AC,  $B5, $E6, $0 , $F7,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $F8, $0 ,  $AF, $7E, $FE, $AD,  $0 , $7B, $5B, $0
	.byt	$0 , $7D, $5D, $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0

; caps lock & alt
ak_tua:
	.byt	$A0, $96, $0 , $5C,  $99, $C5, $93, $7C,  $0 , $DF, $9A, $40
	.byt	$A2, $D0, $A4, $23,  $91, $0 , $B6, $A2,  $90, $BE, $97, $9C
	.byt	$0 , $0 , $A5, $AC,  $B5, $C6, $0 , $F7,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $D8, $0 ,  $AF, $7E, $DE, $AD,  $0 , $7B, $5B, $0
	.byt	$0 , $7D, $5D, $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0

; shift & alt (with or without caps lock)
ak_tsa:
ak_tsua:
	.byt	$0 , $98, $0 , $B0,  $9F, $C5, $9B, $A6,  $0 , $A7, $9A, $B2
	.byt	$A9, $D0, $9E, $BC,  $B9, $0 , $AE, $A3,  $95, $92, $0 , $0
	.byt	$0 , $0 , $0 , $B3,  $94, $C6, $0 , $0 ,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $D8, $0 ,  $0 , $0 , $DE, $9D,  $0 , $AB, $BD, $0
	.byt	$0 , $BB, $B1, $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0

; control (with or without caps lock or shift)
ak_tc:
ak_tuc:
ak_tsc:
ak_tsuc:
	.byt	$00, $00, $00, $00,  $1A, $01, $11, $00,  $18, $13, $17, $00
	.byt	$03, $04, $05, $00,  $16, $06, $12, $00,  $02, $07, $14, $00
	.byt	$0E, $08, $19, $00,  $0D, $0A, $15, $00,  $00, $0B, $09, $00
	.byt	$00, $0C, $0F, $00,  $00, $00, $10, $00,  $0 , $00, $00, $00
	.byt	$0 , $00, $00, $00,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0

; alt & control (maybe & caps & shift) *** preliminary ***
ak_tac:
ak_tuac:
ak_tsac:
ak_tsuac:
	.byt	$00, $00, $00, $00,  $1A, $01, $11, $00,  $18, $13, $17, $00
	.byt	$03, $04, $05, $00,  $16, $06, $12, $00,  $02, $07, $14, $00
	.byt	$0E, $08, $19, $00,  $0D, $0A, $15, $00,  $00, $0B, $09, $00
	.byt	$00, $0C, $0F, $00,  $00, $00, $10, $00,  $0 , $00, $00, $00
	.byt	$0 , $00, $00, $00,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0

#ifdef	DEADKEY
; ** tables for deadkey(s), just one in Spanish **
; acute unshifted
ak_acu:
	.byt	$B4, $0 , $0 , $0 ,  $0 , $E1, $0 , $0 ,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $E9, $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $FD, $0 ,  $0 , $0 , $FA, $0 ,  $0 , $0 , $ED, $0
	.byt	$0 , $0 , $F3, $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0

; acute with shift and/or caps lock
ak_acs:
	.byt	$B4, $0 , $0 , $0 ,  $0 , $C1, $0 , $0 ,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $C9, $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $DD, $0 ,  $0 , $0 , $DA, $0 ,  $0 , $0 , $CD, $0
	.byt	$0 , $0 , $D3, $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0

; diaeresis unshifted
ak_umu:
	.byt	$A8, $0 , $0 , $0 ,  $0 , $E4, $0 , $0 ,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $EB, $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $FF, $0 ,  $0 , $0 , $FC, $0 ,  $0 , $0 , $EF, $0
	.byt	$0 , $0 , $F6, $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0

; diaeresis with shift and/or caps lock
ak_ums:
	.byt	$A8, $0 , $0 , $0 ,  $0 , $C4, $0 , $0 ,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $CB, $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $BE, $0 ,  $0 , $0 , $DC, $0 ,  $0 , $0 , $CF, $0
	.byt	$0 , $0 , $B6, $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0
	.byt	$0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0 ,  $0 , $0 , $0 , $0
#endif

