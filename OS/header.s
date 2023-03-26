; minimOS standard header (Durango-X version)
; (c) 2023 Carlos J. Santisteban
; last modified 20230326-1100

; *** default parameters, if not set just before ***
; file name
#ifndef	FILENAME
#define	FILENAME	"new file"
#endif

; comment (optional)
#ifndef	COMMENT
#define	COMMENT		""
#endif

; version number is %vvvvrrrr (MSB @ $EF), %ppsssbbb or %PPbbbbbb (LSB @ $EE)
; where v=version, r=revision, s=subrevision, b=build, P=phase (%00=alpha, %01=beta, %10=RC, %11=final)
; v.r.Pb or v.r.sPb, like 0.6b27 or 0.6.1a3
#ifndef VERSION
#define	VERSION		0
#endif

; git commit hash in case a library was used (optional) @ $F0, binary coded 8-char hex *** or ASCII @ $E6
#ifndef	LIBCOMMIT1
#define	LIBCOMMIT1	$FFFF
#endif
#ifndef	LIBCOMMIT2
#define	LIBCOMMIT2	$FFFF
#endif

; git commit hash of main code (optional, but pretty helpful) @ $F4, binary coded 8-char hex *** or ASCII @ $F0
#ifndef	COMMIT1
#define	COMMIT1		$FFFF
#endif
#ifndef	COMMIT2
#define	COMMIT2		$FFFF
#endif

; modification time in MS-DOS/FAT format (default is birth of complete Durango-X board, 19.44) @ $F8
#ifndef	H_TIME
#define H_TIME		$9D80
#endif

; modification date in MS-DOS/FAT format (default is birth of complete Durango-X board, 2022.12.23) @ $FA
#ifndef	H_TIME
#define H_TIME		$5597
#endif

; ***********************
; *** standard header *** to be found before ANY ROM image, just after setting PC (* = ...)
; ***********************
rom_start:
; header ID
	.byt	0				; [0]=NUL, first magic number
	.asc	"dX"			; bootable ROM for Durango-X devCart
	.asc	"****"			; reserved
	.byt	13				; [7]=NEWLINE, second magic number
; filename
	.asc	FILENAME		; C-string with filename @ [8], max 238 chars
	.byt	0				; first terminator for filename
	.asc	COMMENT			; optional C-string with comment after filename, filename+comment up to 238 chars
	.byt	0				; second terminator for optional comment, just in case

; advance to end of header
	.dsb	rom_start + $EE - *, $FF

; version number (new)
	.word	VERSION
; library commit (new, optional) *** may consider these in ASCII
	.word	LIBCOMMIT1
	.word	LIBCOMMIT2
; main commit (new, helpful)
	.word	COMMIT1
	.word	COMMIT2
; date & time in MS-DOS format at byte 248 ($F8)
	.word	H_TIME
	.word	H_DATE
; filesize in top 32 bits (@ $FC) now including header ** must be EVEN number of pages because of 512-byte sectors
	.word	$10000-rom_start			; filesize (rom_end is actually $10000)
	.word	0							; 64K space does not use upper 16 bits, [255]=NUL may be third magic number

