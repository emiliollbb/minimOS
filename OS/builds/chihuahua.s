; minimOS ROM template
; specific config for CHIHUAHUA
; v0.6b5
; (c) 2012-2020 Carlos J. Santisteban
; last modified 20180114-1548

; create ready-to-blow ROM image
#define		ROM		_ROM

; ***** include files *****
; specific options
#include "options/chihuahua.h"
; common includes from usual.h
#include "macros.h"
#include "abi.h"
.zero
#include "zeropage.h"
.bss
* = SYSRAM		; option defined
; FW & system variables
#include "firmware/chihuahua.h"
#include "sysvars.h"
; static driver variables
#include "drivers/config/chihuahua_plus_std.h"
-user_ram:

; ************************
; ***** ROM contents *****
; ************************
.text
* = ROM_BASE			; as defined in options.h

; *** minimOS volume header, new 20150604 ***
; not final as current (0.6) LOAD_LINK will not recognise it!
; might use NOHEAD option for systems without any filesystem, but current LOAD_LINK needs it

#ifndef	NOHEAD
sysvol:
	BRK					; don't enter here! NUL marks beginning of header
	.asc	"aV"		; minimOS system volume ID, TBD
	.asc	"****", CR	; some flags TBD
	.asc	"sys", 0	; volume name (mandatory)
; *** ROM identification string as comment (highly recommended) ***
	.asc	"minimOS 0.6 for ", MACHINE_NAME	; system version and machine
	.asc	13, "20180112-1114", 0				; build date and time

	.dsb	sysvol + $F8 - *, $FF				; for ready-to-blow ROM, advance to time/date field

	.word	$6800				; time, 13.00
	.word	$4AB8				; date, 2017/05/24

;romsize	=	$FF00 - ROM_BASE	; compute size! excluding header

;	.word	romsize				; volume size (for future support)
;	.word	0					; ROM size in pages
; FAKE file "size" in order to be LOAD_LINK savvy...
	.word	0, 0				; nothing inside, skip to adjacent header
#endif

; **************************************
; *** the GENERIC kernel starts here ***
; **************************************

; mandatory kernel label now defined HERE!
#ifdef	NOHEAD
kernel	= *
#else
kernel	= * + 256	; skip header
#endif

; includes appropriate shell with its own header
#include "kernel.s"

; **************************
; *** I/O device drivers ***
; **************************
; ### should include a standard header here! ###
#ifndef	NOHEAD
	.dsb	$100*((* & $FF) <> 0) - (* & $FF), $FF	; page alignment!!! eeeeek
drv_file:
	BRK
	.asc	"aD"						; driver pack file TBD
	.asc	"****", CR					; flags TBD
	.asc	"dev", 0, 0				; filename and empty comment

	.dsb	drv_file + $F8 - *, $FF		; padding

	.word	$43C0						; time, 08.30
	.word	$4A47						; date, 2017/02/07

drv_size = drv_end - drv_file - $100	; exclude header

	.word	drv_size
	.word	0
#endif
; ### end of minimOS header ###

; after header goes the binary blob
#include "drivers/config/chihuahua_plus_std.s"
drv_end:		; for easier size computation ***should this go into the driver pack file???

; *********************************************
; *** include rest of the supplied software ***
; *********************************************
; with their own headers, these must be page aligned!!!
#include "../apps/ls.s"

#ifndef		LOWRAM
#include "../apps/pmap.s"
#endif

/*
; ****** skip I/O area for more ******
; ##### empty header #####
#ifndef	NOHEAD
	.dsb	$100*((* & $FF) <> 0) - (* & $FF), $FF	; page alignment!!! eeeeek
empty_head:
	BRK						; don't enter here! NUL marks beginning of header
	.asc	"aS****", CR	; just reserved SYSTEM space
	.asc	"[I/O]", 0, 0	; file name (mandatory) and empty comment
; advance to end of header
	.dsb	empty_head + $FC - *, $FF	; for ready-to-blow ROM, advance to size
; *** no valid date & time ***
emptySize	=	afterIO - empty_head -256	; compute size NOT including header!

; filesize in top 32 bits NOT including header, new 20161216
	.word	emptySize		; filesize
	.word	0				; 64K space does not use upper 16-bit
#endif
; ##### end of minimOS header #####

; *** blank space for I/O area skipping ***
afterIO		= $E000				; assume I/O ends at $DFFF
	.dsb	afterIO - *, $FF	; skip I/O and page alignment!!!
;* = afterIO					; should be already there
*/

; *************************************
; ****** more software after I/O ******
; *************************************
; ...could add more software up to $FC00
#include "shell/miniMoDA.s"
; ****** skip rest of unused ROM until firmware ******
; ##### empty header #####
#ifndef	NOHEAD
	.dsb	$100*((* & $FF) <> 0) - (* & $FF), $FF	; page alignment!!! eeeeek
free_head:
	BRK						; don't enter here! NUL marks beginning of header
	.asc	"aS****", CR	; just reserved SYSTEM space
	.asc	"[R", "OM]", 0, 0	; file name (mandatory) and empty comment *** note macro savvy
; advance to end of header
	.dsb	free_head + $FC - *, $FF	; for ready-to-blow ROM, advance to size
; *** no valid date & time ***
freeSize	=	FW_BASE - free_head -256	; compute size NOT including header!

; filesize in top 32 bits NOT including header, new 20161216
	.word	freeSize		; filesize
	.word	0				; 64K space does not use upper 16-bit
; ##### end of minimOS header #####

; ***************************************
; *** make separate room for firmware ***
; ***************************************
	.dsb	FW_BASE - *, $FF	; for ready-to-blow ROM, skip to firmware area
;* = FW_BASE					; should be already there
#endif

; ***********************************
; *** hardware-dependent firmware ***
; ***********************************
#include "firmware/chihuahua.s"

