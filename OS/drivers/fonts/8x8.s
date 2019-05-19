; font definition for minimOS
; (c) 2019 Carlos J. Santisteban
; last modified 20190519-1622

; ASCII $00 - NULL / centre filled square
	.byt	%11111111
	.byt	%10000001
	.byt	%10111101
	.byt	%10111101
	.byt	%10111101
	.byt	%10111101
	.byt	%10000001
	.byt	%11111111

; ASCII $01 - HOML / double arrow left
	.byt	%00000000
	.byt	%00000000
	.byt	%00100100
	.byt	%01001000
	.byt	%11111110
	.byt	%01001000
	.byt	%00100100
	.byt	%00000000

; ASCII $02 - LEFT / left arrow
	.byt	%00000000
	.byt	%00001000
	.byt	%00011110
	.byt	%00111110
	.byt	%01111110
	.byt	%00111110
	.byt	%00011110
	.byt	%00001000

; ASCII $03 - TERM / ball switch
	.byt	%00000000
	.byt	%00010000
	.byt	%01010100
	.byt	%10010010
	.byt	%10010010
	.byt	%01000100
	.byt	%00111000
	.byt	%00000000

; ASCII $04 - ENDT / arrow to SE corner
	.byt	%10000001
	.byt	%01000001
	.byt	%00100101
	.byt	%00010101
	.byt	%00001101
	.byt	%00111101
	.byt	%00000001
	.byt	%11111111

; ASCII $05 - ENDL / double arrow right
	.byt	%00000000
	.byt	%00000000
	.byt	%00100100
	.byt	%00010010
	.byt	%11111111
	.byt	%00010010
	.byt	%00100100
	.byt	%00000000

; ASCII $06 - RIGHT / right arrow
	.byt	%00000000
	.byt	%00010000
	.byt	%01111000
	.byt	%01111100
	.byt	%01111110
	.byt	%01111100
	.byt	%01111000
	.byt	%00010000

; ASCII $07 - BELL / bell

	.byt	%00010000
	.byt	%01111100
	.byt	%01111100
	.byt	%01111100
	.byt	%11111110
	.byt	%00110000
	.byt	%00100000

; ASCII $08 - BKSP / left sign with x
	.byt	%00000000
	.byt	%00011111
	.byt	%00100001
	.byt	%01010101
	.byt	%10001001
	.byt	%01010101
	.byt	%00100001
	.byt	%00011111

; ASCII $09 - HTAB / right arrow to bar
	.byt	%00000000
	.byt	%00000010
	.byt	%00001010
	.byt	%00000110
	.byt	%01111110
	.byt	%00000110
	.byt	%00001010
	.byt	%00000010

; ASCII $0A - DOWN / down arrow
	.byt	%00000000
	.byt	%01111100
	.byt	%01111100
	.byt	%11111110
	.byt	%01111100
	.byt	%00111000
	.byt	%00010000
	.byt	%00000000

; ASCII $0B - UPCU / up arrow
	.byt	%00000000
	.byt	%00010000
	.byt	%00111000
	.byt	%01111100
	.byt	%11111110
	.byt	%01111100
	.byt	%01111100
	.byt	%00000000

; ASCII $0C - FORM / sheet
	.byt	%00000000
	.byt	%11111000
	.byt	%10010100
	.byt	%10010010
	.byt	%10011110
	.byt	%10000010
	.byt	%10000010
	.byt	%11111110

; ASCII $0D - NEWL / curved arrow
	.byt	%00000000
	.byt	%00000100
	.byt	%00000100
	.byt	%00010100
	.byt	%00100100
	.byt	%01111000
	.byt	%00100000
	.byt	%00010000

; ASCII $0E - EMON / imply
	.byt	%00000000
	.byt	%00010000
	.byt	%00001000
	.byt	%11111100
	.byt	%00000010
	.byt	%11111100
	.byt	%00001000
	.byt	%00010000

; ASCII $0F - EMOF / reverse imply
	.byt	%00000000
	.byt	%00010000
	.byt	%00100000
	.byt	%01111110
	.byt	%10000000
	.byt	%01111110
	.byt	%00100000
	.byt	%00010000

; ASCII $10 - DLE / heart
	.byt	%00000000
	.byt	%01101100
	.byt	%11111110
	.byt	%11111110
	.byt	%01111100
	.byt	%00111000
	.byt	%00010000
	.byt	%00000000

; ASCII $11 - XON / star
	.byt	%00000000
	.byt	%00010000
	.byt	%00010000
	.byt	%11010110
	.byt	%00111000
	.byt	%00010000
	.byt	%00101000
	.byt	%01000100

; ASCII $12 - INK / pencil
	.byt	%00000100
	.byt	%00001000
	.byt	%00010001
	.byt	%00100010
	.byt	%01000100
	.byt	%01101000
	.byt	%01110000
	.byt	%00000000

; ASCII $13 - XOFF / diamond suit
	.byt	%00000000
	.byt	%00010000
	.byt	%00111000
	.byt	%01111100
	.byt	%11111110
	.byt	%01111100
	.byt	%00111000
	.byt	%00010000

; ASCII $14 - PAPC / club suit
	.byt	%00000000
	.byt	%00010000
	.byt	%00111000
	.byt	%01010100
	.byt	%11111110
	.byt	%01010100
	.byt	%00010000
	.byt	%00111000

; ASCII $15 - HOME / arrow to NW corner
	.byt	%11111111
	.byt	%10000000
	.byt	%10111100
	.byt	%10110000
	.byt	%10101000
	.byt	%10100100
	.byt	%10000010
	.byt	%10000001

; ASCII $16 - PGDN / double arrow down
	.byt	%00000000
	.byt	%00010000
	.byt	%01010100
	.byt	%00111000
	.byt	%00010000
	.byt	%01010100
	.byt	%00111000
	.byt	%00010000

; ASCII $17 - ATYX / spades suit
	.byt	%00000000
	.byt	%00010000
	.byt	%00111000
	.byt	%01111100
	.byt	%11111110
	.byt	%01010100
	.byt	%00010000
	.byt	%00111000

; ASCII $18 - BKTB / left arrow to bar
	.byt	%00000000
	.byt	%01000000
	.byt	%01010000
	.byt	%01100000
	.byt	%01111110
	.byt	%01100000
	.byt	%01010000
	.byt	%01000000

; ASCII $19 - PGUP / double arrow up
	.byt	%00000000
	.byt	%00010000
	.byt	%00111000
	.byt	%01010100
	.byt	%00010000
	.byt	%00111000
	.byt	%01010100
	.byt	%00010000

; ASCII $1A - STOP / no entry
	.byt	%00011000
	.byt	%01111110
	.byt	%11111111
	.byt	%10000001
	.byt	%10000001
	.byt	%11111111
	.byt	%01111110
	.byt	%00011000

; ASCII $1B - ESC / NW arrow
	.byt	%00000000
	.byt	%01111100
	.byt	%01111000
	.byt	%01111100
	.byt	%01111110
	.byt	%01011111
	.byt	%00001110
	.byt	%00000100

; ASCII $1C
	.byt	%00000001
	.byt	%00000011
	.byt	%00000111
	.byt	%00001111
	.byt	%00011111
	.byt	%00111111
	.byt	%01111111
	.byt	%11111111

; ASCII $1D
	.byt	%10000000
	.byt	%11000000
	.byt	%11100000
	.byt	%11110000
	.byt	%11111000
	.byt	%11111100
	.byt	%11111110
	.byt	%11111111

; ASCII $1E - light pattern
	.byt	%00000000
	.byt	%00100010
	.byt	%00000000
	.byt	%10001000
	.byt	%00000000
	.byt	%00100010
	.byt	%00000000
	.byt	%10001000

; ASCII $1F - mid pattern
	.byt	%01010101
	.byt	%10101010
	.byt	%01010101
	.byt	%10101010
	.byt	%01010101
	.byt	%10101010
	.byt	%01010101
	.byt	%10101010

; ASCII $20 - SPACE, simple definition!
	.byt	0, 0, 0, 0, 0, 0, 0, 0

; ASCII $21 - !
	.byt	%00000000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00000000
	.byt	%00010000
	.byt	%00000000

; ASCII $22 - "
	.byt	%00000000
	.byt	%00100100
	.byt	%00100100
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $23 - #
	.byt	%00000000
	.byt	%00100100
	.byt	%01111110
	.byt	%00100100
	.byt	%00100100
	.byt	%01111110
	.byt	%00100100
	.byt	%00000000

; ASCII $24 - $
	.byt	%00000000
	.byt	%00001000
	.byt	%00111110
	.byt	%00101000
	.byt	%00111110
	.byt	%00001010
	.byt	%00111110
	.byt	%00001000
	.byt	%00000000

; ASCII $25 - %
	.byt	%00000000
	.byt	%01100010
	.byt	%01100100
	.byt	%00001000
	.byt	%00010000
	.byt	%00100110
	.byt	%01000110
	.byt	%00000000

; ASCII $26 - &
	.byt	%00000000
	.byt	%00010000
	.byt	%00101000
	.byt	%00010000
	.byt	%00101010
	.byt	%01000100
	.byt	%00111010
	.byt	%00000000

; ASCII $27 - ' (different from ZX)
	.byt	%00000000
	.byt	%00010000
	.byt	%00010000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $28 - (
	.byt	%00000000
	.byt	%00000100
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00000100
	.byt	%00000000

; ASCII $29 - )
	.byt	%00000000
	.byt	%00100000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00100000
	.byt	%00000000

; ASCII $2A - *
	.byt	%00000000
	.byt	%00000000
	.byt	%00010100
	.byt	%00001000
	.byt	%00111110
	.byt	%00001000
	.byt	%00010100
	.byt	%00000000

; ASCII $2B - +
	.byt	%00000000
	.byt	%00000000
	.byt	%00001000
	.byt	%00001000
	.byt	%00111110
	.byt	%00001000
	.byt	%00001000
	.byt	%00000000

; ASCII $2C - ,
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00001000
	.byt	%00001000
	.byt	%00010000

; ASCII $2D - -
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00111110
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $2E - .
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00011000
	.byt	%00011000
	.byt	%00000000

; ASCII $2F - /
	.byt	%00000000
	.byt	%00000000
	.byt	%00000010
	.byt	%00000100
	.byt	%00001000
	.byt	%00010000
	.byt	%00100000
	.byt	%00000000

; ASCII $30 - 0
	.byt	%00000000
	.byt	%00111100
	.byt	%01000110
	.byt	%01001010
	.byt	%01010010
	.byt	%01100010
	.byt	%00111100
	.byt	%00000000

; ASCII $31 - 1
	.byt	%00000000
	.byt	%00011000
	.byt	%00101000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00111110
	.byt	%00000000

; ASCII $32 - 2
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%00000010
	.byt	%00111100
	.byt	%01000000
	.byt	%01111110
	.byt	%00000000

; ASCII $33 - 3
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%00001100
	.byt	%00000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $34 - 4
	.byt	%00000000
	.byt	%00001000
	.byt	%00011000
	.byt	%00101000
	.byt	%01001000
	.byt	%01111110
	.byt	%00001000
	.byt	%00000000

; ASCII $35 - 5
	.byt	%00000000
	.byt	%01111110
	.byt	%01000000
	.byt	%01111100
	.byt	%00000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $36 - 6
	.byt	%00000000
	.byt	%00111100
	.byt	%01000000
	.byt	%01111100
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $37 - 7
	.byt	%00000000
	.byt	%01111110
	.byt	%00000010
	.byt	%00000100
	.byt	%00001000
	.byt	%00010000
	.byt	%00010000
	.byt	%00000000

; ASCII $38 - 8
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%00111100
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $39 - 9
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%01000010
	.byt	%00111110
	.byt	%00000010
	.byt	%00111100
	.byt	%00000000

; ASCII $3A - :
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00010000
	.byt	%00000000
	.byt	%00000000
	.byt	%00010000
	.byt	%00000000

; ASCII $3B - ;
	.byt	%00000000
	.byt	%00000000
	.byt	%00010000
	.byt	%00000000
	.byt	%00000000
	.byt	%00010000
	.byt	%00010000
	.byt	%00100000

; ASCII $3C - <
	.byt	%00000000
	.byt	%00000000
	.byt	%00000100
	.byt	%00001000
	.byt	%00010000
	.byt	%00001000
	.byt	%00000100
	.byt	%00000000

; ASCII $3D - =
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00111110
	.byt	%00000000
	.byt	%00111110
	.byt	%00000000
	.byt	%00000000

; ASCII $3E - >
	.byt	%00000000
	.byt	%00000000
	.byt	%00010000
	.byt	%00001000
	.byt	%00000100
	.byt	%00001000
	.byt	%00010000
	.byt	%00000000

; ASCII $3F - ?
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%00000100
	.byt	%00001000
	.byt	%00000000
	.byt	%00001000
	.byt	%00000000

; ASCII $40 - @
	.byt	%00000000
	.byt	%00111100
	.byt	%01001010
	.byt	%01010110
	.byt	%01011110
	.byt	%01000000
	.byt	%00111100
	.byt	%00000000

; ASCII $41 - A
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%01000010
	.byt	%01111110
	.byt	%01000010
	.byt	%01000010
	.byt	%00000000

; ASCII $42 - B
	.byt	%00000000
	.byt	%01111100
	.byt	%01000010
	.byt	%01111100
	.byt	%01000010
	.byt	%01000010
	.byt	%01111100
	.byt	%00000000

; ASCII $43 - C
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%01000000
	.byt	%01000000
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $44 - D
	.byt	%00000000
	.byt	%01111000
	.byt	%01000100
	.byt	%01000010
	.byt	%01000010
	.byt	%01000100
	.byt	%01111000
	.byt	%00000000

; ASCII $45 - E
	.byt	%00000000
	.byt	%01111110
	.byt	%01000000
	.byt	%01111100
	.byt	%01000000
	.byt	%01000000
	.byt	%01111110
	.byt	%00000000

; ASCII $46 - F
	.byt	%00000000
	.byt	%01111110
	.byt	%01000000
	.byt	%01111100
	.byt	%01000000
	.byt	%01000000
	.byt	%01000000
	.byt	%00000000

; ASCII $47 - G
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%01000000
	.byt	%01001110
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $48 - H
	.byt	%00000000
	.byt	%01000010
	.byt	%01000010
	.byt	%01111110
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00000000

; ASCII $49 - I
	.byt	%00000000
	.byt	%00111110
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00111110
	.byt	%00000000

; ASCII $4A - J
	.byt	%00000000
	.byt	%00000010
	.byt	%00000010
	.byt	%00000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $4B - K
	.byt	%00000000
	.byt	%01000100
	.byt	%01001000
	.byt	%01110000
	.byt	%01001000
	.byt	%01000100
	.byt	%01000010
	.byt	%00000000

; ASCII $4C - L
	.byt	%00000000
	.byt	%01000000
	.byt	%01000000
	.byt	%01000000
	.byt	%01000000
	.byt	%01000000
	.byt	%01111110
	.byt	%00000000

; ASCII $4D - M
	.byt	%00000000
	.byt	%01000010
	.byt	%01100110
	.byt	%01011010
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00000000

; ASCII $4E - N
	.byt	%00000000
	.byt	%01000010
	.byt	%01100010
	.byt	%01010010
	.byt	%01001010
	.byt	%01000110
	.byt	%01000010
	.byt	%00000000

; ASCII $4F - O
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $50 - P
	.byt	%00000000
	.byt	%01111100
	.byt	%01000010
	.byt	%01000010
	.byt	%01111100
	.byt	%01000000
	.byt	%01000000
	.byt	%00000000

; ASCII $51 - Q (different from ZX)
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%01000010
	.byt	%01001010
	.byt	%01000100
	.byt	%00111010
	.byt	%00000000

; ASCII $52 - R
	.byt	%00000000
	.byt	%01111100
	.byt	%01000010
	.byt	%01000010
	.byt	%01111100
	.byt	%01000100
	.byt	%01000010
	.byt	%00000000

; ASCII $53 - S
	.byt	%00000000
	.byt	%00111100
	.byt	%01000000
	.byt	%00111100
	.byt	%00000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $54 - T
	.byt	%00000000
	.byt	%01111100
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00000000

; ASCII $55 - U
	.byt	%00000000
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $56 - V
	.byt	%00000000
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00100100
	.byt	%00011000
	.byt	%00000000

; ASCII $57 - W
	.byt	%00000000
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%01011010
	.byt	%00100100
	.byt	%00000000

; ASCII $58 - X
	.byt	%00000000
	.byt	%01000010
	.byt	%00100100
	.byt	%00011000
	.byt	%00011000
	.byt	%00100100
	.byt	%01000010
	.byt	%00000000

; ASCII $59 - Y
	.byt	%00000000
	.byt	%10000010
	.byt	%01000100
	.byt	%00101000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00000000

; ASCII $5A - Z
	.byt	%00000000
	.byt	%01111110
	.byt	%00000100
	.byt	%00001000
	.byt	%00010000
	.byt	%00100000
	.byt	%01111110
	.byt	%00000000

; ASCII $5B - [
	.byt	%00000000
	.byt	%00001110
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001110
	.byt	%00000000

; ASCII $5C - \
	.byt	%00000000
	.byt	%00000000
	.byt	%01000000
	.byt	%00100000
	.byt	%00010000
	.byt	%00001000
	.byt	%00000100
	.byt	%00000000

; ASCII $5D - ]
	.byt	%00000000
	.byt	%01110000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%01110000
	.byt	%00000000

; ASCII $5E - ^ (different from ZX)
	.byt	%00000000
	.byt	%00010000
	.byt	%00101000
	.byt	%01000100
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $5F - _
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%11111111

; ASCII $60 - ` (not in ZX)
	.byt	%00000000
	.byt	%00010000
	.byt	%00001000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $61 - a
	.byt	%00000000
	.byt	%00000000
	.byt	%00111000
	.byt	%00000100
	.byt	%00111100
	.byt	%01000100
	.byt	%00111100
	.byt	%00000000

; ASCII $62 - b
	.byt	%00000000
	.byt	%00100000
	.byt	%00100000
	.byt	%00111100
	.byt	%00100010
	.byt	%00100010
	.byt	%00111100
	.byt	%00000000

; ASCII $63 - c
	.byt	%00000000
	.byt	%00000000
	.byt	%00011100
	.byt	%00100000
	.byt	%00100000
	.byt	%00100000
	.byt	%00011100
	.byt	%00000000

; ASCII $64 - d
	.byt	%00000000
	.byt	%00000100
	.byt	%00000100
	.byt	%00111100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111100
	.byt	%00000000

; ASCII $65 - e
	.byt	%00000000
	.byt	%00000000
	.byt	%00111000
	.byt	%01000100
	.byt	%01111000
	.byt	%01000000
	.byt	%00111100
	.byt	%00000000

; ASCII $66 - f
	.byt	%00000000
	.byt	%00001100
	.byt	%00010000
	.byt	%00011000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00000000

; ASCII $67 - g
	.byt	%00000000
	.byt	%00000000
	.byt	%00111100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111100
	.byt	%00000100
	.byt	%00111000

; ASCII $68 - h
	.byt	%00000000
	.byt	%01000000
	.byt	%01000000
	.byt	%01111000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00000000

; ASCII $69 - i
	.byt	%00000000
	.byt	%00010000
	.byt	%00000000
	.byt	%00110000
	.byt	%00010000
	.byt	%00010000
	.byt	%00111000
	.byt	%00000000

; ASCII $6A - j
	.byt	%00000000
	.byt	%00001000
	.byt	%00000000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%01001000
	.byt	%00110000

; ASCII $6B - k (different from ZX)
	.byt	%00000000
	.byt	%00100000
	.byt	%00100000
	.byt	%00101000
	.byt	%00110000
	.byt	%00110000
	.byt	%00101000
	.byt	%00000000

; ASCII $6C - l
	.byt	%00000000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00001100
	.byt	%00000000

; ASCII $6D - m
	.byt	%00000000
	.byt	%00000000
	.byt	%01101000
	.byt	%01010100
	.byt	%01010100
	.byt	%01010100
	.byt	%01010100
	.byt	%00000000

; ASCII $6E - n
	.byt	%00000000
	.byt	%00000000
	.byt	%01111000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00000000

; ASCII $6F - o
	.byt	%00000000
	.byt	%00000000
	.byt	%00111000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111000
	.byt	%00000000

; ASCII $70 - p
	.byt	%00000000
	.byt	%00000000
	.byt	%01111000
	.byt	%01000100
	.byt	%01000100
	.byt	%01111000
	.byt	%01000000
	.byt	%01000000

; ASCII $71 - q
	.byt	%00000000
	.byt	%00000000
	.byt	%00111100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111100
	.byt	%00000100
	.byt	%00000110

; ASCII $72 - r
	.byt	%00000000
	.byt	%00000000
	.byt	%00011100
	.byt	%00100000
	.byt	%00100000
	.byt	%00100000
	.byt	%00100000
	.byt	%00000000

; ASCII $73 - s
	.byt	%00000000
	.byt	%00000000
	.byt	%00111000
	.byt	%01000000
	.byt	%00111000
	.byt	%00000100
	.byt	%01111000
	.byt	%00000000

; ASCII $74 - t
	.byt	%00000000
	.byt	%00010000
	.byt	%00111000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00001100
	.byt	%00000000

; ASCII $75 - u
	.byt	%00000000
	.byt	%00000000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111000
	.byt	%00000000

; ASCII $76 - v
	.byt	%00000000
	.byt	%00000000
	.byt	%01000100
	.byt	%01000100
	.byt	%00101000
	.byt	%00101000
	.byt	%00010000
	.byt	%00000000

; ASCII $77 - w
	.byt	%00000000
	.byt	%00000000
	.byt	%01000100
	.byt	%01010100
	.byt	%01010100
	.byt	%01010100
	.byt	%00101000
	.byt	%00000000

; ASCII $78 - x
	.byt	%00000000
	.byt	%00000000
	.byt	%01000100
	.byt	%00101000
	.byt	%00010000
	.byt	%00101000
	.byt	%01000100
	.byt	%00000000

; ASCII $79 - y
	.byt	%00000000
	.byt	%00000000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111100
	.byt	%00000100
	.byt	%00111000

; ASCII $7A - z
	.byt	%00000000
	.byt	%00000000
	.byt	%01111100
	.byt	%00001000
	.byt	%00010000
	.byt	%00100000
	.byt	%01111100
	.byt	%00000000

; ASCII $7B - { (different from ZX)
	.byt	%00000000
	.byt	%00000010
	.byt	%00000100
	.byt	%00011000
	.byt	%00000100
	.byt	%00000100
	.byt	%00000010
	.byt	%00000000

; ASCII $7C - | (different from ZX)
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000

; ASCII $7D - } (different from ZX)
	.byt	%00000000
	.byt	%01000000
	.byt	%00100000
	.byt	%00011000
	.byt	%00100000
	.byt	%00100000
	.byt	%01000000
	.byt	%00000000

; ASCII $7E - ~
	.byt	%00000000
	.byt	%00010100
	.byt	%00101000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $7F - DEL (not in ZX)
	.byt	%00000000
	.byt	%11111110
	.byt	%10000010
	.byt	%10101010
	.byt	%10010010
	.byt	%10101010
	.byt	%10000010
	.byt	%11111110

; ASCII $80 - block space
	.byt	0, 0, 0, 0, 0, 0, 0, 0

; ASCII $81 - continue with ZX Spectrum blocks
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $82
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $83
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $84
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111

; ASCII $85
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111

; ASCII $86
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111

; ASCII $87
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111

; ASCII $88
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000

; ASCII $89
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000

; ASCII $8A
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000

; ASCII $8B
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000

; ASCII $8C
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111

; ASCII $8D
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%00001111
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111

; ASCII $8E
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%11110000
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111

; ASCII $8F - whole square, last of ZX glyphs
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111
	.byt	%11111111

; ASCII $90 - alpha
	.byt	%00000000
	.byt	%00000000
	.byt	%00110100
	.byt	%01001000
	.byt	%01001000
	.byt	%00110100
	.byt	%00000000
	.byt	%00000000

; ASCII $91 - check
	.byt	%00000000
	.byt	%00000000
	.byt	%00000010
	.byt	%00000100
	.byt	%00001000
	.byt	%01010000
	.byt	%00100000
	.byt	%00000000

; ASCII $92 - gamma
	.byt	%00000000
	.byt	%01111100
	.byt	%01000000
	.byt	%01000000
	.byt	%01000000
	.byt	%01000000
	.byt	%01000000
	.byt	%00000000

; ASCII $93 - pi
	.byt	%00000000
	.byt	%00000000
	.byt	%00000010
	.byt	%01111100
	.byt	%10101000
	.byt	%00101000
	.byt	%00101000
	.byt	%00000000

; ASCII $94 - upper sigma
	.byt	%01111110
	.byt	%00100000
	.byt	%00010000
	.byt	%00001000
	.byt	%00010000
	.byt	%00100000
	.byt	%01111110
	.byt	%00000000

; ASCII $95 - rho
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00111100
	.byt	%01001000
	.byt	%01001000
	.byt	%00110000
	.byt	%00000000

; ASCII $96 - less or equal
	.byt	%00000000
	.byt	%00000100
	.byt	%00001000
	.byt	%00010000
	.byt	%00100000
	.byt	%01111100
	.byt	%00000000
	.byt	%01111100

; ASCII $97 - tau
	.byt	%00000000
	.byt	%00000000
	.byt	%00000010
	.byt	%01111100
	.byt	%10010000
	.byt	%00010000
	.byt	%00001000
	.byt	%00000000

; ASCII $98 - more or equal
	.byt	%00000000
	.byt	%01000000
	.byt	%00100000
	.byt	%00010000
	.byt	%00001000
	.byt	%01111100
	.byt	%00000000
	.byt	%01111100

; ASCII $99 - theta
	.byt	%00000000
	.byt	%00011000
	.byt	%00100100
	.byt	%01000010
	.byt	%01111110
	.byt	%01000010
	.byt	%00100100
	.byt	%00011000

; ASCII $9A - upper omega
	.byt	%00111000
	.byt	%01000100
	.byt	%10000010
	.byt	%10000010
	.byt	%01000100
	.byt	%00101000
	.byt	%11101110
	.byt	%00000000

; ASCII $9B - lower delta
	.byt	%00010000
	.byt	%00010000
	.byt	%00001000
	.byt	%00111000
	.byt	%01000100
	.byt	%01000100
	.byt	%00111000
	.byt	%00000000

; ASCII $9C - infinity
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%01101100
	.byt	%10010010
	.byt	%10010010
	.byt	%01101100
	.byt	%00000000

; ASCII $9D - approximate
	.byt	%00000000
	.byt	%00000000
	.byt	%00110010
	.byt	%01001100
	.byt	%00000000
	.byt	%00110010
	.byt	%01001100
	.byt	%00000000

; ASCII $9E - belongs
	.byt	%00000000
	.byt	%00011110
	.byt	%00100000
	.byt	%01000000
	.byt	%01111110
	.byt	%01000000
	.byt	%00100000
	.byt	%00011110

; ASCII $9F - arc
	.byt	%00000000
	.byt	%00000000
	.byt	%00011000
	.byt	%00100100
	.byt	%00100100
	.byt	%00100100
	.byt	%00000000
	.byt	%00000000

; ASCII $A0 - hollow square
	.byt	%11111111
	.byt	%10000001
	.byt	%10000001
	.byt	%10000001
	.byt	%10000001
	.byt	%10000001
	.byt	%10000001
	.byt	%11111111

; ASCII $A1 - ¡
	.byt	%00000000
	.byt	%00001000
	.byt	%00000000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00000000

; ASCII $A2 - cent
	.byt	%00000000
	.byt	%00001000
	.byt	%00011100
	.byt	%00101000
	.byt	%00101000
	.byt	%00101000
	.byt	%00011100
	.byt	%00001000

; ASCII $A3 - pound
	.byt	%00000000
	.byt	%00011100
	.byt	%00100010
	.byt	%01111000
	.byt	%00100000
	.byt	%00100000
	.byt	%01111110
	.byt	%00000000

; ASCII $A4 - €
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%11111000
	.byt	%01000000
	.byt	%11111000
	.byt	%01000010
	.byt	%00111100

; ASCII $A5 - yen
	.byt	%00000000
	.byt	%01000100
	.byt	%00101000
	.byt	%01111100
	.byt	%00010000
	.byt	%01111100
	.byt	%00010000
	.byt	%00000000

; ASCII $A6 - broken pipe
	.byt	%00000000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00000000
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000

; ASCII $A7 - section
	.byt	%00000000
	.byt	%00001100
	.byt	%00010000
	.byt	%00111100
	.byt	%01000010
	.byt	%00111100
	.byt	%00001000
	.byt	%00110000

; ASCII $A8 - umlaut
	.byt	%00000000
	.byt	%00100100
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $A9 - copyright
	.byt	%00111100
	.byt	%01000010
	.byt	%10011001
	.byt	%10100001
	.byt	%10100001
	.byt	%10011001
	.byt	%01000010
	.byt	%00111100

; ASCII $AA - ª
	.byt	%01100000
	.byt	%00010000
	.byt	%01110000
	.byt	%01110000
	.byt	%00000000
	.byt	%01110000
	.byt	%00000000
	.byt	%00000000

; ASCII $AB - left chevron
	.byt	%00000000
	.byt	%00000000
	.byt	%00010010
	.byt	%00100100
	.byt	%01001000
	.byt	%00100100
	.byt	%00010010
	.byt	%00000000

; ASCII $AC - not
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%01111110
	.byt	%00000010
	.byt	%00000010
	.byt	%00000000
	.byt	%00000000

; ASCII $AD - not equal
	.byt	%00000000
	.byt	%00000000
	.byt	%00001000
	.byt	%01111100
	.byt	%00010000
	.byt	%01111100
	.byt	%00100000
	.byt	%00000000

; ASCII $AE - registered
	.byt	%00111100
	.byt	%01000010
	.byt	%10111001
	.byt	%10100101
	.byt	%10111001
	.byt	%10100101
	.byt	%01000010
	.byt	%00111100

; ASCII $AF - macron
	.byt	%11111111
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $B0 - degrees
	.byt	%00110000
	.byt	%01001000
	.byt	%00110000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $B1 - plus minus
	.byt	%00000000
	.byt	%00000000
	.byt	%00010000
	.byt	%00111000
	.byt	%00010000
	.byt	%00000000
	.byt	%00111000
	.byt	%00000000

; ASCII $B2 - power of 2
	.byt	%01110000
	.byt	%00010000
	.byt	%01110000
	.byt	%01000000
	.byt	%01110000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $B3 - power of three
	.byt	%01110000
	.byt	%00010000
	.byt	%01110000
	.byt	%00010000
	.byt	%01110000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $B4 - acute
	.byt	%00001000
	.byt	%00010000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $B5 - mju
	.byt	%00000000
	.byt	%00000000
	.byt	%01001000
	.byt	%01001000
	.byt	%01110100
	.byt	%01000000
	.byt	%01000000
	.byt	%00000000

; ASCII $B6 - paragraph
	.byt	%00000000
	.byt	%00111111
	.byt	%01001010
	.byt	%00111010
	.byt	%00001010
	.byt	%00001010
	.byt	%00001010
	.byt	%00000000

; ASCII $B7 - interpunct
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00010000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $B8 - lowercase omega
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%01000100
	.byt	%10000010
	.byt	%10010010
	.byt	%01101100
	.byt	%00000000

; ASCII $B9 - delta
	.byt	%00000000
	.byt	%00000000
	.byt	%00010000
	.byt	%00101000
	.byt	%01000100
	.byt	%11111110
	.byt	%00000000
	.byt	%00000000

; ASCII $BA - º
	.byt	%01110000
	.byt	%01110000
	.byt	%00000000
	.byt	%01110000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000

; ASCII $BB - right chevron
	.byt	%00000000
	.byt	%00000000
	.byt	%01001000
	.byt	%00100100
	.byt	%00010010
	.byt	%00100100
	.byt	%01001000
	.byt	%00000000

; ASCII $BC - bullet
	.byt	%00000000
	.byt	%00111100
	.byt	%01111110
	.byt	%01111110
	.byt	%01111110
	.byt	%01111110
	.byt	%00111100
	.byt	%00000000

; ASCII $BD - oe ligature
	.byt	%00000000
	.byt	%00000000
	.byt	%01101100
	.byt	%10010010
	.byt	%10011100
	.byt	%10010000
	.byt	%01101110
	.byt	%00000000

; ASCII $BE - eng
	.byt	%00000000
	.byt	%00000000
	.byt	%01111000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00000100
	.byt	%00001000

; ASCII $BF - ¿
	.byt	%00000000
	.byt	%00010000
	.byt	%00000000
	.byt	%00010000
	.byt	%00100000
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $C0 - À
	.byt	%00010000
	.byt	%00001000
	.byt	%00111100
	.byt	%01000010
	.byt	%01111110
	.byt	%01000010
	.byt	%01000010
	.byt	%00000000

; ASCII $C1 - Á
	.byt	%00001000
	.byt	%00010000
	.byt	%00111100
	.byt	%01000010
	.byt	%01111110
	.byt	%01000010
	.byt	%01000010
	.byt	%00000000

; ASCII $C2 - Â
	.byt	%00011000
	.byt	%00100100
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%01111110
	.byt	%01000010
	.byt	%00000000

; ASCII $C3 - A tilde
	.byt	%00010100
	.byt	%00101000
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%01111110
	.byt	%01000010
	.byt	%00000000

; ASCII $C4 - Ä
	.byt	%00100100
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%01111110
	.byt	%01000010
	.byt	%01000010
	.byt	%00000000

; ASCII $C5 - A with circle
	.byt	%00011000
	.byt	%00100100
	.byt	%00011000
	.byt	%00111100
	.byt	%01000010
	.byt	%01111110
	.byt	%01000010
	.byt	%00000000

; ASCII $C6 - Æ
	.byt	%00000000
	.byt	%01111110
	.byt	%10010000
	.byt	%11111100
	.byt	%10010000
	.byt	%10010000
	.byt	%10011110
	.byt	%00000000

; ASCII $C7 - Ç
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%01000000
	.byt	%01000010
	.byt	%00111100
	.byt	%00001000
	.byt	%00010000

; ASCII $C8 - È
	.byt	%00010000
	.byt	%00001000
	.byt	%01111110
	.byt	%01000000
	.byt	%01111100
	.byt	%01000000
	.byt	%01111110
	.byt	%00000000

; ASCII $C9 - É
	.byt	%00001000
	.byt	%00010000
	.byt	%01111110
	.byt	%01000000
	.byt	%01111100
	.byt	%01000000
	.byt	%01111110
	.byt	%00000000

; ASCII $CA - Ê
	.byt	%00011000
	.byt	%00100100
	.byt	%00000000
	.byt	%01111110
	.byt	%01000000
	.byt	%01111100
	.byt	%01000000
	.byt	%01111110

; ASCII $CB -Ë
	.byt	%00100100
	.byt	%00000000
	.byt	%01111110
	.byt	%01000000
	.byt	%01111100
	.byt	%01000000
	.byt	%01111110
	.byt	%00000000

; ASCII $CC - Ì
	.byt	%00010000
	.byt	%00001000
	.byt	%00111110
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00111110
	.byt	%00000000

; ASCII $CD - Í
	.byt	%00000100
	.byt	%00001000
	.byt	%00111110
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00111110
	.byt	%00000000

; ASCII $CE - Î
	.byt	%00001000
	.byt	%00010100
	.byt	%00000000
	.byt	%00111110
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00111110

; ASCII $CF - Ï
	.byt	%00010100
	.byt	%00000000
	.byt	%00111110
	.byt	%00001000
	.byt	%00001000
	.byt	%00001000
	.byt	%00111110
	.byt	%00000000

; ASCII $D0 - ETH
	.byt	%00000000
	.byt	%01111000
	.byt	%01000100
	.byt	%11100010
	.byt	%01000010
	.byt	%01000100
	.byt	%01111000
	.byt	%00000000

; ASCII $D1 - Ñ
	.byt	%00010100
	.byt	%00101000
	.byt	%01000010
	.byt	%01100010
	.byt	%01010010
	.byt	%01001010
	.byt	%01000110
	.byt	%01000010

; ASCII $D2 - Ò
	.byt	%00010000
	.byt	%00001000
	.byt	%00111100
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $D3 - Ó
	.byt	%00001000
	.byt	%00010000
	.byt	%00111100
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $D4 - Ô
	.byt	%00011000
	.byt	%00100100
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100

; ASCII $D5 - O tilde
	.byt	%00010100
	.byt	%00101000
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100

; ASCII $D6 - Ö
	.byt	%00100100
	.byt	%00000000
	.byt	%00111100
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $D7 - product
	.byt	%00000000
	.byt	%00000000
	.byt	%00000000
	.byt	%00101000
	.byt	%00010000
	.byt	%00101000
	.byt	%00000000
	.byt	%00000000

; ASCII $D8 - empty set
	.byt	%00000001
	.byt	%00111110
	.byt	%01000110
	.byt	%01001010
	.byt	%01010010
	.byt	%01100010
	.byt	%01111100
	.byt	%10000000

; ASCII $D9 - Ù
	.byt	%00010000
	.byt	%01001010
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $DA - Ú
	.byt	%00001000
	.byt	%01010010
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $DB - Û
	.byt	%00011000
	.byt	%00100100
	.byt	%00000000
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100

; ASCII $DC - Ü
	.byt	%01000010
	.byt	%00000000
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%01000010
	.byt	%00111100
	.byt	%00000000

; ASCII $DD - Ý
	.byt	%00001000
	.byt	%10010010
	.byt	%01000100
	.byt	%00101000
	.byt	%00010000
	.byt	%00010000
	.byt	%00010000
	.byt	%00000000

; ASCII $DE - upper thorn
	.byt	%00000000
	.byt	%01000000
	.byt	%01000000
	.byt	%01111100
	.byt	%01000010
	.byt	%01111100
	.byt	%01000000
	.byt	%01000000

; ASCII $DF -esszett
	.byt	%00000000
	.byt	%00110000
	.byt	%01001000
	.byt	%01010000
	.byt	%01001000
	.byt	%01001000
	.byt	%01010000
	.byt	%00000000

; ASCII $E0 - à
	.byt	%00010000
	.byt	%00001000
	.byt	%00111000
	.byt	%00000100
	.byt	%00111100
	.byt	%01000100
	.byt	%00111100
	.byt	%00000000

; ASCII $E1 - á
	.byt	%00001000
	.byt	%00010000
	.byt	%00111000
	.byt	%00000100
	.byt	%00111100
	.byt	%01000100
	.byt	%00111100
	.byt	%00000000

; ASCII $E2 - â
	.byt	%00010000
	.byt	%00101000
	.byt	%00000000
	.byt	%00111000
	.byt	%00000100
	.byt	%00111100
	.byt	%01000100
	.byt	%00111100

; ASCII $E3 - a tilde
	.byt	%00010100
	.byt	%00101000
	.byt	%00000000
	.byt	%00111000
	.byt	%00000100
	.byt	%00111100
	.byt	%01000100
	.byt	%00111100

; ASCII $E4 - ä
	.byt	%00101000
	.byt	%00000000
	.byt	%00111000
	.byt	%00000100
	.byt	%00111100
	.byt	%01000100
	.byt	%00111100
	.byt	%00000000

; ASCII $E5 - a with circle
	.byt	%00010000
	.byt	%00101000
	.byt	%00010000
	.byt	%00111000
	.byt	%00000100
	.byt	%00111100
	.byt	%01000100
	.byt	%00111100

; ASCII $E6 - æ
	.byt	%00000000
	.byt	%00000000
	.byt	%01101100
	.byt	%00010010
	.byt	%01111100
	.byt	%10010000
	.byt	%01111110
	.byt	%00000000

; ASCII $E7 - ç
	.byt	%00000000
	.byt	%00011100
	.byt	%00100000
	.byt	%00100000
	.byt	%00100000
	.byt	%00011100
	.byt	%00001000
	.byt	%00010000

; ASCII $E8 - è
	.byt	%00010000
	.byt	%00001000
	.byt	%00111000
	.byt	%01000100
	.byt	%01111000
	.byt	%01000000
	.byt	%00111100
	.byt	%00000000

; ASCII $E9 - é
	.byt	%00001000
	.byt	%00010000
	.byt	%00111000
	.byt	%01000100
	.byt	%01111000
	.byt	%01000000
	.byt	%00111100
	.byt	%00000000

; ASCII $EA - ê
	.byt	%00010000
	.byt	%00101000
	.byt	%00000000
	.byt	%00111000
	.byt	%01000100
	.byt	%01111000
	.byt	%01000000
	.byt	%00111100

; ASCII $EB - ë
	.byt	%00101000
	.byt	%00000000
	.byt	%00111000
	.byt	%01000100
	.byt	%01111000
	.byt	%01000000
	.byt	%00111100
	.byt	%00000000

; ASCII $EC - ì
	.byt	%00100000
	.byt	%00010000
	.byt	%00000000
	.byt	%00110000
	.byt	%00010000
	.byt	%00010000
	.byt	%00111000
	.byt	%00000000

; ASCII $ED - í
	.byt	%00001000
	.byt	%00010000
	.byt	%00000000
	.byt	%00110000
	.byt	%00010000
	.byt	%00010000
	.byt	%00111000
	.byt	%00000000

; ASCII $EE - î
	.byt	%00010000
	.byt	%00101000
	.byt	%00000000
	.byt	%00110000
	.byt	%00010000
	.byt	%00010000
	.byt	%00111000
	.byt	%00000000

; ASCII $EF - ï
	.byt	%00000000
	.byt	%00101000
	.byt	%00000000
	.byt	%00110000
	.byt	%00010000
	.byt	%00010000
	.byt	%00111000
	.byt	%00000000

; ASCII $F0 - eth
	.byt	%00000000
	.byt	%00000100
	.byt	%00001110
	.byt	%00000100
	.byt	%00111100
	.byt	%01000100
	.byt	%00111100
	.byt	%00000000

; ASCII $F1 - ñ
	.byt	%00111000
	.byt	%00000000
	.byt	%01111000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00000000

; ASCII $F2 - ò
	.byt	%00010000
	.byt	%00001000
	.byt	%00111000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111000
	.byt	%00000000
	.byt	%00000000

; ASCII $F3 - ó
	.byt	%00001000
	.byt	%00010000
	.byt	%00111000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111000
	.byt	%00000000

; ASCII $F4 - ô
	.byt	%00010000
	.byt	%00101000
	.byt	%00000000
	.byt	%00111000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111000

; ASCII $F5 - o tilde
	.byt	%00010100
	.byt	%00101000
	.byt	%00000000
	.byt	%00111000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111000

; ASCII $F6 - ö
	.byt	%00101000
	.byt	%00000000
	.byt	%00111000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111000
	.byt	%00000000

; ASCII $F7 - division
	.byt	%00000000
	.byt	%00000000
	.byt	%00010000
	.byt	%00000000
	.byt	%01111100
	.byt	%00000000
	.byt	%00010000
	.byt	%00000000

; ASCII $F8 - o with bar
	.byt	%00000000
	.byt	%00000010
	.byt	%00111100
	.byt	%01001100
	.byt	%01010100
	.byt	%01100100
	.byt	%01111000
	.byt	%10000000

; ASCII $F9 - ù
	.byt	%00100000
	.byt	%00010000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111000
	.byt	%00000000

; ASCII $FA - ú
	.byt	%00001000
	.byt	%00010000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111000
	.byt	%00000000

; ASCII $FB - û
	.byt	%00010000
	.byt	%00101000
	.byt	%00000000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111000

; ASCII $FC - ü
	.byt	%00101000
	.byt	%00000000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111000
	.byt	%00000000

; ASCII $FD - ý
	.byt	%00001000
	.byt	%00010000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111100
	.byt	%00000100
	.byt	%00111000

; ASCII $FE - lower thorn
	.byt	%00000000
	.byt	%00100000
	.byt	%00111000
	.byt	%00100100
	.byt	%00100100
	.byt	%00111000
	.byt	%00100000
	.byt	%00000000

; ASCII $FF - ÿ
	.byt	%00101000
	.byt	%00000000
	.byt	%01000100
	.byt	%01000100
	.byt	%01000100
	.byt	%00111100
	.byt	%00000100
	.byt	%00111000
