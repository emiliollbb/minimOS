; minimOS ROM template
; v0.6.1a1
; (c) 2012-2020 Carlos J. Santisteban
; last modified 20190213-0836

; create ready-to-blow ROM image
#define		ROM		_ROM

; ***** include files *****
; *** options.h is machine-dependent, copy or link appropriate file from options/ ***
#include "usual.h"

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
	.asc	"minimOS 0.6.1 for ", MACHINE_NAME	; system version and machine
	.asc	13, "20190213-0845", 0				; build date and time

	.dsb	sysvol + $F8 - *, $FF				; for ready-to-blow ROM, advance to time/date field

	.word	$45A0				; time, 8.45
	.word	$4E4D				; date, 2019/02/13

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
#ifndef	C816
#include "kernel.s"
#else
#include "kernel16.s"
#endif

; **************************
; *** I/O device drivers ***
; **************************
; ### should include a standard header here! ###
#ifndef	NOHEAD
	.dsb	$100*((* & $FF) <> 0) - (* & $FF), $FF	; page alignment!!! eeeeek
drv_file:
	BRK
	.asc	"aD"				; driver pack file TBD
	.asc	"****", CR			; flags TBD
	.asc	"dev", 0, 0			; filename and empty comment

	.dsb	drv_file + $F8 - *, $FF		; padding

	.word	$45A0				; time, 8.45
	.word	$4E4D				; date, 2019/02/13

drv_size = drv_end - drv_file - $100	; exclude header

	.word	drv_size
	.word	0
#endif
; ### end of minimOS header ###

; after header goes the binary blob
#include DRIVER_PACK_s
drv_end:				; for easier size computation ***should this go into the driver pack file?

; *********************************************
; *** include rest of the supplied software ***
; *********************************************
; with their own headers, these must be page aligned!!!
#include "../apps/ls.s"

#include "../forge/eh_basic/ehbasic.s"		; *** NEW ***

; select specific pmap version according to architecture!
#ifndef C816
#ifndef		LOWRAM
#include "../apps/pmap.s"
#else
#include "shell/monitor.s"
#endif
#else
#include "../apps/pmap16.s"
#include "../apps/crasm/80asm.s"	; relocated here
#endif

#include "../apps/minized.s"
#include "../apps/sigtest.s"

; ************************************
; ****** skip I/O area for more ******
; ************************************
; ##### empty header #####
#ifndef	NOHEAD
	.dsb	$100*((* & $FF) <> 0) - (* & $FF), $FF	; page alignment!!! eeeeek
empty_head:
	BRK							; don't enter here! NUL marks beginning of header
	.asc	"aS****", CR		; just reserved SYSTEM space
	.asc	"[I/O]", 0, 0		; file name (mandatory) and empty comment
; advance to end of header
	.dsb	empty_head + $F8 - *, $FF	; for ready-to-blow ROM, advance to time

	.word	$45A0				; time, 8.45
	.word	$4E4D				; date, 2019/02/13

emptySize	=	afterIO - empty_head -256	; compute size NOT including header!

; filesize in top 32 bits NOT including header, new 20161216
	.word	emptySize			; filesize
	.word	0					; 64K space does not use upper 16-bit
#endif
; ##### end of minimOS header #####

; *** blank space for I/O area skipping ***
afterIO		= $E000				; assume I/O ends at $DFFF
	.dsb	afterIO - *, $FF	; skip I/O and page alignment!!!

* = afterIO						; should be already there

; *************************************
; ****** more software after I/O ******
; *************************************
;#include "shell/monitor.s"
#ifdef	C816
;#include "../apps/crasm/80asm.s"
#include "../apps/crasm/63asm.s"
#else
#include "shell/miniMoDA.s"
#endif

; ****************************************************
; ****** skip rest of unused ROM until firmware ******
; ****************************************************
; ##### empty header #####
#ifndef	NOHEAD
	.dsb	$100*((* & $FF) <> 0) - (* & $FF), $FF	; page alignment!!! eeeeek
free_head:
	BRK							; don't enter here! NUL marks beginning of header
	.asc	"aS****", CR		; just reserved SYSTEM space
	.asc	"[R", "OM]", 0, 0	; file name (mandatory) and empty comment *** note macro savvy
; advance to end of header
	.dsb	free_head + $F8 - *, $FF	; for ready-to-blow ROM, advance to time

	.word	$45A0				; time, 8.45
	.word	$4E4D				; date, 2019/02/13

freeSize	=	FW_BASE - free_head -256	; compute size NOT including header!

; filesize in top 32 bits NOT including header, new 20161216
	.word	freeSize			; filesize
	.word	0					; 64K space does not use upper 16-bit
#endif
; ##### end of minimOS header #####

; ***************************************
; *** make separate room for firmware ***
; ***************************************
	.dsb	FW_BASE - *, $FF	; for ready-to-blow ROM, skip to firmware area

; ***********************************
; *** hardware-dependent firmware ***
; ***********************************
#include ARCH_s

; *******************************************
; *** SPECIAL TEST, soft after kernel ROM ***
; *******************************************
#ifdef	C816
; 816-only software!
#include "shell/miniMoDA16.s"
#endif
