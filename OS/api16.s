; minimOS·16 generic Kernel API!
; v0.5.1b5, should match kernel16.s
; (c) 2016-2017 Carlos J. Santisteban
; last modified 20170123-1112

; no way for standalone assembly, neither internal calls...

; *** dummy function, non implemented ***
unimplemented:			; placeholder here, not currently used
	.as: .xs: SEP #$30	; *** standard register size ***
	_ERR(UNAVAIL)		; go away!

; ********************************
; *** COUT, output a character ***
; ********************************
; **** Y <- dev, io_c <- char ****
; ********************************
cout:
	.as: .xs: SEP #$30	; *** standard register size ***
; new MUTEX for COUT, 20161121, *per-driver based 161129 **added overhead
#ifdef	MULTITASK
	STY iol_dev			; **keep device temporarily, worth doing here (3)
; CS not needed for MUTEX as per 65816 API
co_loop:
	LDA cio_lock, Y		; *check whether THAT device in use (4)
	BEQ co_lckd			; resume operation if free (3)
; otherwise yield CPU time and repeat
;		_KERNEL(B_YIELD)	; give way... scheduler would switch on interrupts as needed *** direct internal API call!
		LDX #MM_YIELD		; internal multitasking index (2)
		JSR (drv_opt-MM_YIELD, X)	; direct to driver skipping the kernel, note deindexing! (8)
		LDY iol_dev			; restore previous status, *new style (3)
		BRA co_loop			; try again! (3)
co_lckd:
;	_KERNEL(GET_PID)	; **NO internal call, 816 prefers indexed JSR
	LDX #MM_PID			; internal multitasking index (2)
	JSR (drv_opt-MM_PID, X)	; direct to driver skipping the kernel, note deindexing! (8)
	TYA					; **current PID in A (2)
	LDY iol_dev			; **restore device number (3)
	STA cio_lock, Y		; *reserve this (4)
; 65816 API runs on interrupts off, thus no explicit CS exit
#endif
; continue with mutually exclusive COUT
	TYA					; for indexed comparisons (2)
	BNE co_port			; not default (3/2)
		LDA stdout			; new per-process standard device ### apply this to ·65
		BNE co_port			; already a valid device
			LDA default_out		; otherwise get system global (4)
co_port:
	BMI co_phys			; not a logic device (3/2)
		CMP #64				; first file-dev??? ***
			BCC co_win			; below that, should be window manager
; ** optional filesystem access **
#ifdef	FILESYSTEM
		CMP #64+MAX_FILES	; still within file-devs?
			BCS co_log			; that value or over, not a file
; *** manage here output to open file ***
		LDY #NO_RSRC		; not yet implemented ***placeholder***
		BRA cio_unlock		; notyfy error AND unlock device eeeeeek
#endif
; ** end of filesystem access **
co_log:
; investigate rest of logical devices
		CMP #DEV_NULL		; lastly, ignore output
			BNE cio_nfound		; final error otherwise
; /dev/null is always OK, might save some bytes doing CLC & BRA cio_unlock
cio_exitOK:
#ifdef	MULTITASK
		LDX iol_dev			; retrieve driver index
		STZ cio_lock, X		; clear mutex
#endif
		_EXIT_OK			; "/dev/null" is always OK
co_win:
; *** virtual windows manager TO DO ***
	LDY #NO_RSRC		; not yet implemented
	BRA cio_unlock		; notyfy error AND unlock device eeeeeek
co_phys:
; ** new direct indexing **
	ASL					; convert to index (2+2)
	TAX
	JSR (drv_opt, X)	; direct CALL!!! driver should end in RTS as usual via the new DR_ macros
; clear mutex ONLY if multitasking is in use!
cio_unlock:
#ifdef	MULTITASK
	LDX iol_dev			; **need to clear new lock! (3)
	STZ cio_lock, X		; ...because I have to clear MUTEX! *new indexed form (4)
#endif
; ** important routine ending in order to preserve C status after the RTI **
; current version is 6 bytes, 3/11 t minus RTI
; older version was 7 bytes, 10/11 t minus RTI
cio_callend:
	BCC cio_notc		; no need to clear carry
		PLP
		SEC					; otherwise set stored carry
		PHP
cio_notc:
	RTI					; end of call procedure

; *************************************************
; ************* CIN,  get a character *************
; *************************************************
; *** Y <- dev, io_c -> char, C = not available ***
; *************************************************
cin:
	.as: .xs: SEP #$30	; *** standard register size ***
; new MUTEX for CIN, 20161121, *per-driver based 161129 **added overhead
#ifdef	MULTITASK
	STY iol_dev			; **keep device temporarily, worth doing here (3)
; CS not needed for MUTEX as per 65816 API
ci_loop:
	LDA cio_lock, Y		; *check whether THAT device in use (4)
	BEQ ci_lckd			; resume operation if free (3)
; otherwise yield CPU time and repeat
; but first check whether it was me (waiting on binary mode)
;		_KERNEL(GET_PID)	; *NO internal call, 816 prefers indexed JSR
		LDX #MM_PID			; internal multitasking index (2)
		JSR (drv_opt-MM_PID, X)	; direct to driver skipping the kernel, note deindexing! (8)
		TYA					; **current PID in A
		LDY iol_dev			; **retrieve device as index
		CMP cio_lock, Y		; *was it me who locked? (4)
			BEQ ci_lckdd		; *if so, resume execution (3)
; if the above, could first check whether the device is in binary mode, otherwise repeat loop!
; continue with regular mutex
;		_KERNEL(B_YIELD)	; give way... scheduler would switch on interrupts as needed *** direct internal API call!
		LDX #MM_YIELD		; internal multitasking index (2)
		JSR (drv_opt-MM_YIELD, X)	; direct to driver skipping the kernel, note deindexing! (8)
		LDY iol_dev			; *restore previous status (3)
		BRA ci_loop			; try again! (3)
ci_lckd:
;	_KERNEL(B_YIELD)	; **NO internal call, 816 prefers indexed JSR
	LDX #MM_YIELD		; internal multitasking index (2)
	JSR (drv_opt-MM_YIELD, X)	; direct to driver skipping the kernel, note deindexing! (8)
	TYA					; **current PID in A (2)
	LDY iol_dev			; **restore device number (3)
	STA cio_lock, Y		; *reserve this (4)
ci_lckdd:
; 65816 API runs on interrupts off, thus no explicit CS exit
#endif
; continue with mutually exclusive CIN
	TYA					; for indexed comparisons
	BNE ci_port			; specified
		LDA std_in			; new per-process standard device ### apply this to ·65
		BNE ci_port			; already a valid device
			LDA default_in		; otherwise get system global
ci_port:
	BPL ci_nph			; logic device
; ** new direct indexing **
		ASL					; convert to index (2+2)
		TAX
		JSR (drv_ipt, X)	; direct CALL!!!
		BCC ci_chkev		; no error, have a look at events
			BRA cio_unlock		; clear MUTEX and return whatever error!

cio_nfound:
	LDY #N_FOUND		; unknown device
	SEC					; eeeeeeeeeeek
	BRA cio_unlock		; notify error code AND unlock device!

; ** EVENT management **
; this might be revised, or supressed altogether!
ci_chkev:
#ifdef	MULTITASK
		LDX iol_dev			; **use device as index! worth doing here (3)
#endif
		LDA io_c			; get received character
		CMP #' '			; printable?
			BCS ci_exitOK		; if so, will not be an event, exit with NO error
; otherwise might be an event ** REVISE
; check for binary mode first
#ifdef	MULTITASK
		LDY cin_mode, X		; *get flag, new sysvar 20150617
#else
		LDY cin_mode		; singletask systems
#endif
		BEQ ci_event		; should process possible event
#ifdef	MULTITASK
			STZ cin_mode, X		; *back to normal mode
#else
			STZ cin_mode		; normal mode for singletask systems!
#endif
ci_exitOK:
#ifdef	MULTITASK
			STZ cio_lock, X		; *otherwise clear mutex!!! (4)
#endif
			_EXIT_OK			; all done without error!
ci_event:
		CMP #16				; is it DLE?
		BNE ci_notdle		; otherwise check next
#ifdef	MULTITASK
			STA cin_mode, X		; *set binary mode! safer and faster!
#else
			STA cin_mode		; single task systems do not set X!!!
#endif
			_ERR(EMPTY)			; and supress received character, ***but will stau locked!
ci_notdle:
		CMP #3				; is it ^C? (TERM)
		BNE ci_noterm		; otherwise check next
			LDA #SIGTERM
			BRA ci_signal		; send signal
ci_noterm:
		CMP #4				; is it ^D? (KILL) somewhat dangerous...
		BNE ci_nokill		; otherwise check next
			LDA #SIGKILL
			BRA ci_signal		; send signal
ci_nokill:
		CMP #26				; is it ^Z? (STOP)
		BNE ci_exitOK		; otherwise there is no more to check
			LDA #SIGSTOP		; last signal to be sent
ci_signal:
			STA b_sig			; set signal as parameter
;			_KERNEL(GET_PID)	; as this will be a self-sent signal! ***NO internal call
			LDX #MM_PID			; internal multitasking index (2)
			JSR (drv_opt-MM_PID, X)	; direct to driver skipping the kernel, note deindexing! (8)
;			_KERNEL(B_SIGNAL)	; send signal to PID in Y ***NO internal call
			LDX #MM_SIGNAL		; internal multitasking index (2)
			JSR (drv_opt-MM_SIGNAL, X)	; direct to driver skipping the kernel, note deindexing! (8)
; a standard 65816 call does... 5 bytes & 12 clocks
;	LDX #GET_PID	; (2) 2 bytes
;	CLC				; (2) 1 byte
;	COP #$FF		; (8) 2 bytes
; while a 'direct' call goes... 9 bytes & 16 clocks
;	PHK				; (3) 1 byte
;	PEA ret_addr	; (5) 3 bytes
;	CLC				; (2) 1 byte
;	PHP				; (3) 1 byte
;	JMP get_pid		; (3) 3 bytes
; ** after any of these, kernel will do (going back thru cio_callend) **
;	LDX #MM_PID			; (2)
;	PEA cio_callend-1	; (5)
;	JMP (drv_opt)		; (5) ...and maybe a BRA somewhere (3)
; ****** definitely NOT worth in 65816 code! ******
; OTOH the 6502 way is... 5 bytes & 8 clocks
;	LDX #GET_PID	; (2) 2 bytes
;	JSR k_call		; (6) 3 bytes
; while its 'direct' call goes... 3 bytes & 6 clocks, well WORTH it!
;	JSR get_pìd		; (6) 3 bytes
; ** the kernel part will be **
;	LDX #MM_PID			; (2)
;	JMP (drv_opt)		; (6) ...and maybe a BRA somewhere (3)
; ************************************************************
; but what about indexed JSR to driver???
;	LDX #MM_PID				; (2) 2 bytes, internal index!
;	JSR (drv_opt-MM_PID, X)	; (8) 3 bytes, note de-indexing!
; THIS was 5 bytes & 10 clocks MINUS 15/18 from SKIPPED kernel!!!
			LDX iol_dev			; **as calls will destroy X
ci_abort:
#ifdef	MULTITASK
		STZ cio_lock, X		; *clear mutex!
#endif
		_ERR(EMPTY)			; no character was received

ci_nph:
	CMP #64				; first file-dev??? ***
		BCC ci_win			; below that, should be window manager
; ** optional filesystem access **
#ifdef	FILESYSTEM
	CMP #64+MAX_FILES	; still within file-devs?
		BCS ci_log			; that or over, not a file
; *** manage here input from open file ***
	LDY #NO_RSRC		; not yet implemented ***placeholder***
	BRA cio_unlock		; unlock and notify
#endif
; ** end of filesystem access **

ci_log:
	CMP #DEV_RND		; getting a random number?
		BEQ ci_rnd			; compute it!
	CMP #DEV_NULL		; lastly, ignore input
		BNE cio_nfound		; final error otherwise
	BRA ci_exitOK

ci_rnd:
; *** generate random number (TO DO) ***
	LDA ticks			; simple placeholder
	STA io_c			; eeeeeeeeeeeeeeeeek
	BRA ci_exitOK

ci_win:
; *** virtual window manager TO DO ***
	LDY #NO_RSRC		; not yet implemented
	JMP cio_unlock

; *******************************************************************************
; *************************** MALLOC,  reserve memory ***************************
; *******************************************************************************
; ************* ma_rs <- size, ma_pt -> addr, C = not enough memory *************
; *** ma_align <- mask for MSB (0=page/not aligned, 1=512b, $FF=bank aligned) ***
; ************* ma_rs = 0 means reserve as much memory as available *************
; ******* ram_stat & ram_pid (= ram_stat+1) are interleaved in minimOS-16 *******
; *********************** this works on 24-bit addressing ***********************
; ************ uses ma_l as diverse temporary vars, as defined below ************
; *******************************************************************************
ma_siz	= ma_l
ma_ix	= ma_l+2		; might revise this as other architectures prefer separate registers!

malloc:
	.al: REP #$20		; *** 16-bit memory ***
	.xs: SEP #$10		; *** 8-bit indexes ***
	LDX #0				; reset index
	STX ma_align+1		; **clear MSB in cass of a 16-bit BIT!**
	LDY ma_rs			; check individual bytes, just in case
	BEQ ma_nxpg			; no extra page needed
		INC ma_rs+1			; otherwise increase number of pages
		STX ma_rs				; ...and just in case, clear asked bytes!
ma_nxpg:
; default 816 API functions run on interrupts masked, thus no need for CS
	LDA ma_rs+1			; get number of asked pages
	BNE ma_scan			; work on specific size
; otherwise check for biggest available block -- new ram_stat word format 161105
		STZ ma_siz		; ...and found value eeeeeeeeek
ma_biggest:
			LDY ram_stat, X		; get status of block (4)
;			CPY #FREE_RAM		; not needed if FREE_RAM is zero! (2)
			BNE ma_nxbig		; go for next as this one was not free (3/2)
				JSR ma_alsiz		; **compute size according to alignment mask**
				CMP ma_siz			; compare against current maximum (4)
				BCC ma_nxbig		; this was not bigger (3/2)
					STA ma_siz			; otherwise keep track of it... (4)
					STX ma_ix			; ...and its index! (3)
ma_nxbig:
			INX					; advance index (2+2)
			INX
			LDY ram_stat, X		; peek next status (4)
			CPY #END_RAM		; check whether at end (2)
			BNE ma_biggest		; or continue (3/2)
; is there at least one available block?
		LDA ma_siz			; should not be zero
		BNE ma_fill			; there is at least one block to allocate
			_ERR(FULL)		; otherwise no free memory!
; report allocated size
ma_fill:
		STA ma_rs+1			; store allocated size! already computed
		LDX ma_ix			; retrieve index
		BRA ma_updt			; nothing to scan, just update status and return address
ma_scan:
		LDY ram_stat, X		; get state of current entry (4)
;		CPY #FREE_RAM		; looking for a free one (2) not needed if free is zero
			BEQ ma_found		; got one (2/3)
		CPY #END_RAM		; got already to the end? (2)
			BEQ ma_nobank		; could not found anything suitable (2/3)
ma_cont:
		INX					; increase index (2+2)
		INX
		CPX #MAX_LIST*2		; until the end (2+3)
		BNE ma_scan
ma_nobank:
; one end of CS
	_ERR(FULL)			; no room for it!
ma_found:
	JSR ma_alsiz		; **compute size according to alignment mask**
#ifdef	SAFE
	BMI ma_nobad		; no corruption was seen (3/2) **instead of BCS**
		LDA #user_sram	; otherwise take beginning of user RAM...
		LDX #LOCK_RAM	; ...that will become locked (new value)
		STA ram_pos		; create values
		STX ram_stat		; **should it clear the PID field too???**
		LDA #SRAM		; physical top of RAM...
		LDX #END_RAM		; ...as non-plus-ultra
		STA ram_pos+2		; create second set of values
		STX ram_stat+2
		_ERR(CORRUPT)	; report but do not turn system down
ma_nobad:
#endif
	CMP ma_rs+1			; compare (5)
		BCC ma_cont			; smaller, thus continue searching (2/3)
; here we go!
; **first of all create empty block for alignment, if needed**
	PHA					; save current size
	LDA ram_pos, X		; check current address
	AND ma_align		; any misaligned bits set?
	BEQ ma_aok			; already aligned, nothing needed
		JSR ma_adv			; advance and let repeated first entry!
		INX					; let the algnment blank and go for next
		INX
		LDA ram_pos, X		; get repeated address
		ORA ma_align		; set disturbing bits...
		INC					; ...and reset them after increasing the rest
		STA ram_pos, X		; update pointer
ma_aok:
	PLA					; retrieve size
; make room for new entry... if not exactly the same size
	CMP ma_rs			; str_devcompare this block with requested size
	BEQ ma_updt			; was same size, will not generate new entry
		JSR ma_adv			; make room otherwise
ma_updt:
	STZ ma_pt			; clear pointer LSB... plus extra byte
	LDA ram_pos, X		; get address of block to be assigned
	STA ma_pt+1			; note this is address of PAGE
	LDA #USED_RAM		; now is reserved
	STA ram_stat, X		; update table entry, will destroy PID temporarily but no STY abs,X!!!
; ** new 20161106, store PID of caller **
	PHX					; will need this index
;	_KERNEL(GET_PID)	; who asked for this?
	LDX #MM_PID			; internal multitasking index (2)
	JSR (drv_opt-MM_PID, X)	; direct to driver skipping the kernel, note deindexing! (8)
	PLX					; retrieve index
	.as: SEP #$30		; *** back to 8-bit because interleaved array! ***
	TYA					; get into A as no STY abs,X!!!
	STA ram_pid, X		; store PID, interleaved array will apply some offset
; theoretically we are done, end of CS
	_EXIT_OK

	.al					; as routines will be called in 16-bit memory!!!

; routine for aligned-block size computation
ma_alsiz:
	LDA ram_pos, X		; get bottom address (5)
	BIT ma_align		; check for set bits from mask (5)
	BEQ ma_fit			; none was set, thus already aligned (3/2)
		ORA ma_align		; set masked bits... (4)
		INC					; ...and increase address for alignment (2)
ma_fit:
	EOR #$FFFF			; invert bits as will be subtracted to next entry (3)
	SEC					; needs one more for twos-complement (2)
	ADC ram_pos+2, X	; compute size from top ptr MINUS bottom one (5)
	RTS
; *** non-aligned version ***
;	LDA ram_pos+2, X	; get end position (5)
;	SEC
;	SBC ram_pos, X		; subtract current for size! (2+5)
; *** end of non-aligned version ***

; routine for making room for an entry
ma_adv:
	STX ma_ix			; store current index
ma_2end:
		INX					; previous was free, thus check next
		INX
		CPX #MAX_LIST-1		; just in case, check offset!!!
		BCC ma_notend		; could expand
			PLA					; discard return address (still in 16-bit mode)
			JMP ma_nobank		; notice error
ma_notend:
		LDY ram_stat, X		; check status of block
		CPY #END_RAM		; scan for the end-of-memory marker
		BNE ma_2end			; hope will eventually finish!
ma_room:
		LDA ram_pos, X		; get block address
		STA ram_pos+2, X	; one position forward
		LDA ram_stat, X		; get block status **plus new PID field, new 161106**
		STA ram_stat+2, X	; advance it **would use LDY/STY if not storing PID**
		DEX					; down one entry
		DEX
		CPX ma_ix			; position of updated entry
		BNE ma_room			; continue until done
; create at the beginning of the moved block a FREE entry!
	LDA ram_pos+2, X	; newly assigned slice will begin here
	CLC
	ADC ma_rs+1			; add number of assigned pages
	STA ram_pos+2, X	; update value
	LDA #FREE_RAM		; let us mark it as free, PID is irrelevant!
	STA ram_stat+2, X	; next to the assigned one, no STY abs,X!!!
	RTS

; *******************************
; **** FREE,  release memory ****
; *******************************
; ******** ma_pt <- addr ********
; *** C -> no such used block ***
; *******************************
free:
	.al: REP #$20		; *** 16-bit memory ***
	.xs: SEP #$10		; *** 8-bit indexes ***
	LDX #0				; reset index
	LDA ma_pt			; get comparison term
fr_loop:
		CMP ram_pos, X		; is what we are looking for?
			BEQ fr_found		; go free it!
		LDY ram_stat, X		; otherwise check status
		INX					; advance index
		INX
		CPY #END_RAM		; no more in list?
		BNE fr_loop			; continue until end
; this could be one end of CS
fr_no:
	_ERR(N_FOUND)		; no such block!
fr_found:
#ifdef	SAFE
	LDY ram_stat, X		; only used blocks can be freed!
	CPY #USED_RAM		; was it in use?
		BNE fr_no			; if not, cannot free it!
#endif
	LDA #FREE_RAM		; most likely zero, could I use STZ in 16-bit mode??? irrelevant PID
	STA ram_stat, X		; no STY abs,Y... this block is now free, but...
; really should join possible adjacent free blocks
	LDY ram_stat+2, X	; check status of following entry
;	CPY #FREE_RAM		; was it free? could be supressed if value is zero
	BNE fr_ok			; was not free, thus nothing to optimize
; loop for obliterating the following empty entry
fr_join:
		INX					; go for next entry
		INX
		LDA ram_pos+2, X	; get following address
		STA ram_pos, X		; store one entry below
		LDA ram_stat+2, X	; check status of following! **but PID field too**
		STA ram_stat, X		; store one entry below **otherwise LDY/STY**
		TAY					; **will transfer just status, PID will be ripped off**
		CPY #END_RAM		; end of list?
		BNE fr_join			; repeat until done
; we are done
fr_ok:
	_EXIT_OK

; ********************************************************************
; ****************** OPEN_W, get I/O port or window ******************
; ********************************************************************
; *** Y -> dev, w_rect <- size+pos*64K, str_pt <- pointer to title ***
; ********************************************************************
open_w:
	.al: REP #$20		; *** 16-bit memory size ***
	.xs: SEP #$10		; *** 8-bit register, just in case ***
	LDA w_rect			; asking for some size? includes BOTH bytes
	BEQ ow_no_window	; wouldn't do it
		_ERR(NO_RSRC)str_dev
ow_no_window:
	LDY #DEVICE			; constant default device, REVISE
;	EXIT_OK on subsequent system calls!

; ********************************************************
; **************** CLOSE_W,  close window ****************
; *** FREE_W, release window, will be closed by kernel ***
; ********************************************************
; *********************** Y <- dev ***********************
; ********************************************************
close_w:				; doesn't do much
free_w:					; doesn't do much, either
	_EXIT_OK


; *** UPTIME, get approximate uptime ***
; up_ticks -> ticks, new standard format 20161006
; up_sec -> 32-bit uptime in seconds

uptime:
	.al: REP #$20		; *** optimum 16-bit memory ***
; default 816 API functions run on interrupts masked, thus no need for CS
		LDA ticks		; get system variable word (5)
		STA up_ticks	; and store them in output parameter (4)
		LDA ticks+2		; get system variable uptime (5)
		STA up_sec		; and store it in output parameter (4)
		LDA ticks+4		; another word, as per new format (5)
		STA up_sec+2	; store that (4)
; end of CS
	_EXIT_OK


; *** LOAD_LINK, get address once in RAM/ROM (in development) ***
; ex_pt -> addr, str_pt <- *path, cpu_ll -> architecture (N if it was non-XIP)
; now supports 24-bit addressing! but only for 65816 code

load_link:
; *** first look for that filename in ROM headers ***
	.al: REP #$20		; *** 16-bit memory ***
	.xs: SEP #$10		; *** standard index size ***
; first of all, correct parameter pointer as will be aligned with header!
	LDA str_pt			; get whole pointer (minus bank)
	SEC
	SBC #8				; subtract name position in header!
	STA str_pt			; modified value
	BCS ll_reset		; nothing else to do if no borrow
		DEC str_pt+2		; otherwise will point to previous BANK (may affect fourth byte)
ll_reset:
; get initial address! beacuse of the above, no longer adds filename offset!
	LDA #ROM_BASE		; begin of ROM contents
	STA	rh_scan			; set local pointer
	STZ rh_scan+2		; standard bank for long pointer!
ll_geth:
; ** check whether we are on a valid header!!! **
		.as: SEP #$20		; *** back to standard memory ***
		LDA [rh_scan]		; get first byte in header
			BNE ll_nfound		; link was lost, no more to scan
		LDY #7				; after type and size, a CR is expected
		LDA [rh_scan], Y	; get eigth byte in header!
		CMP #13				; was it a CR?
			BNE ll_nfound		; if not, go away
; look for the name
		INY					; reset scanning index (now at name position, was @7)
ll_nloop:
			LDA [rh_scan], Y	; get character in found name
			CMP [str_pt], Y		; compare with what we are looking for
				BNE ll_nthis		; difference found
			ORA [str_pt], Y		; otherwise check whether at EOL
				BEQ ll_found		; all were zero, both ended names are the same!
			INY					; otherwise continue search
			BNE ll_nloop		; will not do forever, no need for BRA
ll_nthis:
; not this one, correct local pointer for the next header
		LDY #252			; relative offset to size eeeeeeeek
		LDA [rh_scan], Y	; get LSB
		TAX					; keep it
		INY					; advance to number of pages!
		.al: REP #$20		; *** back to 16-bit memory for a moment ***
		LDA [rh_scan], Y	; get number of pages to skip (24-bit pointer)
		TXY					; check that LSB
		BEQ ll_nwad			; if page is not full...
			INC					; ...advance to next boundary EEEEEEEEK
ll_nwad:
		SEC					; ...plus header itself! eeeeeeek
		ADC rh_scan+1		; add to previous value
		STA rh_scan+1		; update pointer
		BCC ll_geth			; inspect new header (if no wrap! 24-bit addressing)
ll_nfound:
	_ERR(N_FOUND)		; all was scanned and the query was not found
ll_found:
; this was the original load_link code prior to 20161202, will be executed after the header was found!
	.as: .xs: SEP #$30	; *** standard register size ***
	LDY #1				; offset for filetype
	LDA [rh_scan], Y	; check filetype
	CMP #'m'			; must be minimOS app!
		BNE ll_wrap			; error otherwise
	INY					; next byte is CPU type then
	LDA [rh_scan], Y	; get it
	CMP #'V'			; Rockwell is the only unsupported type! but look for any other 65xx option
		BEQ ll_native		; native 65816 is OK *AND* will allow 24-bit addressing this far 
	CMP #'B'			; generic 65C02
		BEQ ll_valid		; also OK but will NOT support 24-bit (for now)	
	CMP #'N'			; old NMOS
		BEQ ll_valid		; if neither this one, unsupported CPU type!
ll_wrap:
	_ERR(INVALID)		; unsupported CPU
ll_valid:
; CPU-type is compatible but has 8-bit code, should install 64-byte wrapper at end of bank, or limit to bank zero!
	LDX rh_scan+2			; check THIRD byte, still not supported in 8-bit code
	BEQ ll_native			; still in bank 0, OK to proceed
		_ERR(FULL)				; somewhat confusing error...
ll_native:
; either is 65816 code or 02 into bank zero
	STA cpu_ll			; set CPU type, positive because it is XIP!
	.al: REP #$20		; *** 16-bit memory again ***
	LDA rh_scan+1		; get pointer MSB+BANK
	INC					; start from next page
	STA ex_pt+1			; save execution pointer
	LDX #0				; eeeeeeeeeeeeeeek
	STX ex_pt			; *** assume all headers are page-aligned *** do not touch second byte!
	_EXIT_OK


; *** SU_POKE, write to protected addresses ***
; might be deprecated, not sure if of any use in other architectures
; Y <- value, zpar <- addr
; destroys A (and maybe Y on NMOS)

su_poke:
	.as: .xs: SEP #$30	; *** standard register size ***
	TYA					; transfer value
	STA (zpar)			; store value
	_EXIT_OK


; *** SU_PEEK, read from protected addresses ***
; might be deprecated, not sure if of any use in other architectures
; Y -> value, zpar <- addr
; destroys A

su_peek:
	.as: .xs: SEP #$30	; *** standard register size ***
	LDA (zpar)			; store value
	TAY					; transfer value
	_EXIT_OK


; *** STRING, prints a C-string *** optimized loop 20161004, should port to ·65
; Y <- dev, str_pt <- *string (.w in current version)
; uses str_dev AND iol_dev
; calls cout, but now directly at driver code ***
; included mutex 20161130 eeeeeeeeeeeeeek

string:
; ** actual code from COUT here, might save space using a common routine, but adds a bit of overhead
	.as: .xs: SEP #$30	; *** standard register size ***
; new MUTEX eeeeeeek, *per-driver way **added overhead
#ifdef	MULTITASK
	STY iol_dev			; **keep device temporarily, worth doing here (3)
; CS not needed for MUTEX as per 65816 API
str_wait:
	LDA cio_lock, Y		; *check whether THAT device in use (4)
	BEQ str_lckd		; resume operation if free (3)
; otherwise yield CPU time and repeat
;		_KERNEL(B_YIELD)	; give way... scheduler would switch on interrupts as needed *** direct internal API call!
		LDX #MM_YIELD		; internal multitasking index (2)
		JSR (drv_opt-MM_YIELD, X)	; direct to driver skipping the kernel, note deindexing! (8)
		LDY iol_dev			; restore previous status, *new style (3)
		BRA str_wait		; try again! (3)
str_lckd:
;	_KERNEL(GET_PID)	; **NO internal call, 816 prefers indexed JSR
	LDX #MM_PID			; internal multitasking index (2)
	JSR (drv_opt-MM_PID, X)	; direct to driver skipping the kernel, note deindexing! (8)
	TYA					; **current PID in A (2)
	LDY iol_dev			; **restore device number (3)
	STA cio_lock, Y		; *reserve this (4)
; 65816 API runs on interrupts off, thus no explicit CS exit
#endif
; continue with mutually exclusive COUT code
	TYA					; for indexed comparisons (2)
	BNE str_port		; not default (3/2)
		LDA stdout			; new per-process standard device ### apply this to ·65
		BNE str_port		; already a valid device
			LDA default_out		; otherwise get system global (4)
str_port:
	BMI str_phys		; not a logic device (3/2)
		CMP #64				; first file-dev??? ***
			BCC str_win			; below that, should be window manager
; ** optional filesystem access **
#ifdef	FILESYSTEM
		CMP #64+MAX_FILES	; still within file-devs?
			BCS str_log			; that value or over, not a file
; *** manage here output to open file ***
		LDY #NO_RSRC		; not yet implemented ***placeholder***
		BRA str_abort		; notify error code AND unlock device!
#endif
; ** end of filesystem access **
str_log:
; investigate rest of logical devices
		CMP #DEV_NULL		; lastly, ignore output
			BNE str_nfound		; final error otherwise
str_exit:
#ifdef	MULTITASK
		LDX iol_dev			; retrieve driver index
		STZ cio_lock, X		; clear mutex
#endif
		_EXIT_OK			; "/dev/null" is always OK
str_win:
; *** virtual windows manager TO DO ***
	LDY #NO_RSRC		; not yet implemented
	SEC					; eeeek
	BRA str_abort		; notify error code AND unlock device!
str_nfound:
	LDY #N_FOUND		; unknown device
	SEC					; eeeek
	BRA str_abort		; notify error code AND unlock device!

str_phys:
; ** new direct indexing, revamped 20160407 **
	ASL					; convert to index (2+2)
	STA str_dev			; store for indexed call! (3)
	LDY #0				; eeeeeeeek! (2)
; ** the actual printing loop **
str_loop:
		PHY					; save just in case COUT destroys it (3)
		LDA (str_pt), Y		; get character from string, new approach (5)
		BNE str_cont		; not terminated! (3/2)
			PLA					; otherwise discard saved Y (4) eeeeeeeek
			BRA str_exit		; and go away!
str_cont:
		STA io_c			; store output character for COUT (3)
		LDX str_dev			; get driver pointer position (3)
		JSR (drv_opt, X)	; go at stored pointer (...6)
			BCS str_err			; return error from driver
		PLY					; restore index (4)
		INY					; eeeeeeeeeeeek (2)
		BNE str_loop		; still within same page
	INC str_pt+1		; otherwise increase, parameter has changed! should I save it?
	BRA str_loop		; continue, will check for termination later (3)
str_err:
	PLA					; discard saved Y while keeping error code eeeeeeeeeek^2
str_abort:
	JMP cio_unlock		; otherwise return code AND clear MUTEX eeeeeeeeeek^2

; ******************************
; *** READLN, buffered input *** new 20161223
; ******************************
; Y <- dev, str_pt <- *buffer (24-bit mandatory), ln_siz <- max offset
; uses iol_dev, rl_cur

readLN:
	.as: .xs: SEP #$30	; *** standard register size ***

	STY iol_dev			; preset device ID!
lda #'&';why is this print needed?????
sta io_c
ldy iol_dev
_KERNEL(COUT)
	STZ rl_cur			; reset variable
rl_l:
		_KERNEL(B_YIELD)	; always useful
		LDY iol_dev			; use device
		_KERNEL(CIN)		; get one character
		BCC rl_rcv			; got something
			CPY #EMPTY			; otherwise is just waiting?
		BEQ rl_l			; continue then
			LDA #0				; no indirect STZ
			STA [str_pt]		; if any other error, terminate string at the beginning
			JMP cio_callend		; and return whatever error*/
rl_rcv:
		LDA io_c			; get received
		LDY rl_cur			; retrieve index
		CMP #CR				; hit CR?
			BEQ rl_cr			; all done then
		CMP #BS				; is it backspace?
		BNE rl_nbs			; delete then
			TYA					; check index
				BEQ rl_l			; ignore if already zero
			DEC rl_cur			; otherwise reduce index
			BRA rl_echo			; and resume operation
rl_nbs:
		CPY ln_siz			; overflow? eeeeeeeeeeeek
			BCS rl_l			; ignore if so
		STA [str_pt], Y		; store into buffer
		INC	rl_cur			; update index
rl_echo:
		LDY iol_dev			; retrieve device
		_KERNEL(COUT)		; echo received character
		BRA rl_l			; and continue
rl_cr:
	LDA #CR				; newline
	LDY iol_dev			; retrieve device
	_KERNEL(COUT)		; print newline (ignoring errors)
	LDY rl_cur			; retrieve cursor!!!!!
	LDA #0				; no STZ indirect indexed
	STA [str_pt], Y		; terminate string
	_EXIT_OK			; and all done!

; *** SU_SEI, disable interrupts ***
; C -> not authorized (?)
; probably not needed on 65xx, _CS macros are much more interesting anyway
su_sei:
	SEI					; disable interrupts
	_EXIT_OK			; no error so far


; *** SU_CLI, enable interrupts ***
; probably not needed on 65xx, _CS macros are much more interesting anyway

su_cli:					; not needed for 65xx, even with protection hardware
	CLI					; enable interrupts
	_EXIT_OK			; no error


; *** SET_FG, enable/disable frequency generator (Phi2/n) on VIA ***
; ** should use some firmware interface, just in case it doesn't affect jiffy-IRQ! **
; should also be Phi2-rate independent... input as Hz, or 100uS steps?
; zpar.W <- dividing factor (times two?), C -> busy
; destroys A, X...

; *******TO BE REVISED*********
set_fg:
	LDA zpar
	ORA zpar+1
		BEQ fg_dis			; if zero, disable output
	LDA VIA+ACR			; get current configuration
		BMI fg_busy			; already in use
	LDX VIA+T1LL		; get older T1 latch values
	STX old_t1			; save them
	LDX VIA+T1LH
	STX old_t1+1
; *** TO_DO - should compare old and new values in order to adjust quantum size accordingly ***
	LDX zpar			; get new division factor
	STX VIA+T1LL		; store it
	LDX zpar+1
	STX VIA+T1LH
	STX VIA+T1CH		; get it running!
	ORA #$C0			; enable free-run PB7 output
	STA VIA+ACR			; update config
fg_none:
	_EXIT_OK			; finish anyway
fg_dis:
	LDA VIA+ACR			; get current configuration
		BPL fg_none			; it wasn't playing!
	AND #$7F			; disable PB7 only
	STA VIA+ACR			; update config
	LDA old_t1			; older T1L_L
	STA VIA+T1LL		; restore old value
	LDA old_t1+1
	STA VIA+T1LH		; it's supposed to be running already
; *** TO_DO - restore standard quantum ***
		BRA fg_none
fg_busy:
	_ERR(BUSY)			; couldn't set


; *** GO_SHELL, launch default shell *** REVISE
; no interface needed
go_shell:
	JMP shell			; simply... *** SHOULD initialise SP and other things anyway ***


; *** SHUTDOWN, proper shutdown, with or without poweroff ***
; Y <- subfunction code
; C -> couldn't poweroff or reboot (?)

shutdown:
	.as: .xs: SEP #$30	; *** standard register size ***
	CPY #PW_CLEAN		; from scheduler only!
		BEQ sd_2nd			; continue with second stage
	CPY #PW_STAT		; is it going to suspend?
		BEQ sd_stat			; don't shutdown system then!
	STY sd_flag			; store mode for later, first must do proper system shutdown
; ask all braids to terminate
	LDY #0				; PID=0 means ALL braids
	LDA #SIGTERM		; will be asked to terminate
	STA b_sig			; store signal type
;	_KERNEL(B_SIGNAL)	; ask braids to terminate
	LDX #MM_SIGNAL		; internal multitasking index (2)
	JSR (drv_opt-MM_SIGNAL, X)	; direct to driver skipping the kernel, note deindexing! (8)
	PLP					; original mask is buried in stack
	CLI					; make sure all will keep running!
	PHP					; restore for subsequent RTI
	_EXIT_OK		; *** should need some flag to indicate XIP or not! stack frame is different
	; actually RTI for 816

; firmware interface
sd_off:
	LDY #PW_OFF			; poweroff
sd_fw:
	_ADMIN(POWEROFF)	; except for suspend, shouldn't return...
	JMP cio_callend			; just in case was not implemented!
sd_stat:
	LDY #PW_STAT		; suspend
	BNE sd_fw			; no need for BRA
sd_cold:
	LDY #PW_COLD		; cold boot
	BNE sd_fw			; will reboot, shared code, no need for BRA
sd_warm:
	SEP #9				; disable interrupts and set carry...
	XCE					; ...to set emulation mode for a moment
	CLD					; clear decimal mode
	JMP warm			; firmware no longer should take pointer, generic kernel knows anyway

; the scheduler will wait for NO braids active
; now let's disable all drivers
sd_2nd:
	LDA sd_flag			; check what was pending
	BNE sd_shut			; something to do
		_PANIC("{sched}")	; otherwise it is an error!
sd_shut:
	SEI					; disable interrupts (forever)
#ifdef	SAFE
	STZ dpoll_mx		; disable interrupt queues, just in case
	STZ dreq_mx
	STZ dsec_mx
#endif
; call each driver's shutdown routine
	LDX #0				; reset index
	.al: REP #$20		; *** 16-bit memory ***
; first get the pointer to each driver table
sd_loop:
; get address index
		LDA drivers_ad, X	; get address from original list
			BEQ sd_done			; no more drivers to shutdown!
		STA sysptr			; store temporarily
; check here whether the driver was successfully installed, get ID as index for drv_opt/ipt
		LDY #D_ID			; point to ID of driver
		LDA (sysptr), Y		; get ID... plus extra byte
		ASL					; convert to index
;			BCC sd_next			; invalid device ID!
		TAY					; use as index, LSB only
		LDA #dr_error		; installed address at unused drivers
		CMP drv_opt, Y		; check pointer
		BNE sd_msb			; OK to shutdown
			CMP drv_ipt, Y		; check if not installed!
				BEQ sd_next			; nothing to shutoff
sd_msb:
		PHX					; save index for later
		PHP					; and register size, just in case!
		LDY #D_BYE			; shutdown MSB offset
		JSR dr_call			; call routine from generic code!!!
		PLP					; back to original size, will ignore error code anyway
		PLX					; retrieve index
sd_next:
		INX					; advance to next entry (2+2)
		INX
		BRA sd_loop			; repeat
; system cleanly shut, time to let the firmware turn-off or reboot
sd_done:
	LDX sd_flag			; retrieve mode as index!
	JMP (sd_tab-2, X)	; do as appropriate *** please note that X=0 means scheduler ran off of tasks!


; *** B_FORK, reserve available PID ***
; Y -> PID

b_fork:
	.as: .xs: SEP #$30	; *** standard register size ***
	LDX #MM_FORK		; subfunction code
	BRA sig_call		; go for the driver


; *** B_EXEC, launch new loaded process ***
; API still subject to change... (default I/O, rendez-vous mode TBD)
; Y <- PID, ex_pt <- addr (was z2L), cpu_ll <- architecture, def_io <- std_in & stdout
; *** should need some flag to indicate XIP or not! stack frame is different

b_exec:
	.as: .xs: SEP #$30	; *** standard register size ***
	LDX #MM_EXEC		; subfunction code
	BRA sig_call		; go for the driver


; *** B_SIGNAL, send UNIX-like signal to a braid ***
; b_sig <- signal to be sent , Y <- addressed braid
; don't know of possible errors

signal:
	.as: .xs: SEP #$30	; *** standard register size ***
	LDX #MM_SIGNAL		; subfunction code
	BRA sig_call		; go for the driver


; *** B_STATUS, get execution flags of a braid ***
; Y <- addressed braid
; Y -> flags, TBD
; don't know of possible errors, maybe just a bad PID

status:
	.as: .xs: SEP #$30	; *** standard register size ***
	LDX #MM_STATUS		; subfunction code
	BRA sig_call		; go for the driver


; *** GET_PID, get current braid PID ***
; Y -> PID, TBD

get_pid:
	.as: .xs: SEP #$30	; *** standard register size ***
	LDX #MM_PID		; subfunction code
; * unified calling procedure, get subfunction code in X * new faster interface 20161102
sig_call:
; new code is 6 bytes, 10 clocks! old code was 8 bytes, 13 clocks
	PEA cio_callend-1	; push correct return address!
	JMP (drv_opt)		; as will be the first one in list, best to use non-indexed indirect


; *** SET_HNDL, set SIGTERM handler, default is like SIGKILL ***
; Y <- PID, ex_pt <- SIGTERM handler routine (ending in RTI)
; ** so far only bank 0 routines supported **
; uses locals[0] too
; bad PID is probably the only feasible error

set_handler:
	.as: .xs: SEP #$30	; *** standard register size ***
	LDX #MM_HANDL		; subfunction code
	BRA sig_call		; go for the driver


; *** B_YIELD, Yield CPU time to next braid *** REVISE
; supposedly no interface needed, don't think I need to tell if ignored

yield:
	.as: .xs: SEP #$30	; *** standard register size ***
	LDX #MM_YIELD		; subfunction code
	BRA sig_call	; go for the driver

; *** TS_INFO, get taskswitching info for multitasking driver *** new API 20161019
; Y -> number of bytes, ex_pt -> pointer to the proposed stack frame

ts_info:
#ifdef	MULTITASK
	.xs: SEP #$10			; *** standard index size ***
	.al: REP #$20			; *** 16-bit memory ***
	LDA #tsi_str			; pointer to proposed stack frame
	STA ex_pt				; store output word
	LDY #tsi_end-tsi_str	; number of bytes
	_EXIT_OK
#else
	.xs: REP #$10			; *** standard index size for error handling ***
	_ERR(UNAVAIL)			; non-supporting kernel!
#endif


; *** RELEASE, release ALL memory for a PID, new 20161115
; Y <- PID

release:
	.xs: SEP #$30		; *** 8-bit sizes ***
	TYA					; as no CPY abs,X
	XBA					; exchange...
	LDA #USED_RAM		; the status we will be looking for! PID @ MSB
	.al: REP #$20		; *** 16-bit memory ***
	LDX #0				; reset index
rls_loop:
		CMP ram_stat, X		; will check both stat (LSB) AND PID (MSB) of this block
		BNE rls_oth			; it is not mine and/or not in use
			PHA					; otherwise save status
			PHX
			LDA ram_pos, X		; get pointer to targeted block
			STA ma_pt			; will be used by FREE
			_KERNEL(FREE)		; release it! ***by NO means a direct call might be used here***
			PLX					; retrieve status
			PLA
			BCC rls_next		; keep index IF current entry was deleted!
rls_oth:
		INX					; advance to next block
		INX
rls_next:
		LDY ram_stat, X		; look status only
		CPY #END_RAM		; are we done?
		BNE rls_loop		; continue if not yet
	_EXIT_OK			; no errors...

; *******************************
; *** end of kernel functions ***
; *******************************

; ****debug code*****
hexdebug:		; print A in hex
.as:sep#$20
	PHA			; keep whole value
	LSR			; shift right four times (just the MSB)
	LSR
	LSR
	LSR
	JSR hxd_ascii	; convert and print this cipher
	PLA			; retrieve full value
	AND #$0F	; keep just the LSB... and repeat procedure
hxd_ascii:
	CMP #10		; will be a letter?
	BCC hxd_num	; just a number
		ADC #6			; convert to letter (plus carry)
hxd_num:
	ADC #'0'	; convert to ASCII (carry is clear)
	JSR $c0c2	; direct print
	RTS
; *******************

; other data and pointers
sd_tab:					; check order in abi.h!
	.word	sd_stat		; suspend
	.word	sd_warm		; warm boot direct by kernel
	.word	sd_cold		; cold boot via firmware
	.word	sd_off		; poweroff system

tsi_str:
; pre-created reversed stack frame for firing tasks up, regardless of multitasking driver implementation
	.word	isr_sched_ret-1	; corrected reentry address **standard label**
	.byt	0				; stored X value, best if multitasking driver is the first one
	.word	0, 0, 0			; irrelevant Y, X, A values
tsi_end:
; end of stack frame for easier size computation

; **************************************************
; *** jump table, if not in separate 'jump' file ***
; **************************************************

#ifndef		DOWNLOAD
k_vec:
	.word	cout		; output a character
	.word	cin			; get a character
	.word	malloc		; reserve memory
	.word	free		; release memory
	.word	open_w		; get I/O port or window
	.word	close_w		; close window
	.word	free_w		; will be closed by kernel
	.word	uptime		; approximate uptime in ticks
	.word	b_fork		; get available PID
	.word	b_exec		; launch new process
	.word	load_link	; get addr. once in RAM/ROM
	.word	su_poke		; write protected addresses
	.word	su_peek		; read protected addresses
	.word	string		; prints a C-string
	.word	readLN		; buffered input, INSERTED 20170113
	.word	su_sei		; disable interrupts, aka dis_int
	.word	su_cli		; enable interrupts (not needed for 65xx) aka en_int
	.word	set_fg		; enable frequency generator (VIA T1@PB7)
	.word	go_shell	; launch default shell, INSERTED 20150604
	.word	shutdown	; proper shutdown procedure, new 20150409, renumbered 20150604
	.word	signal		; send UNIX-like signal to a braid, new 20150415, renumbered 20150604
	.word	status		; get execution flags of a braid, EEEEEEEEEEEEEEEK
	.word	get_pid		; get PID of current braid, new 20150415, renumbered 20150604
	.word	set_handler	; set SIGTERM handler, new 20150417, renumbered 20150604
	.word	yield		; give away CPU time for I/O-bound process, new 20150415, renumbered 20150604
	.word	ts_info		; get taskswitching info, new 20150507-08, renumbered 20150604
	.word	release		; release ALL memory for a PID, new 20161115

#else
#include "drivers.s"	; this package will be included with downloadable kernels
.data
#include "sysvars.h"	; donwloadable systems have all vars AND drivers after the kernel itself
#include "drivers.h"
user_sram = *			; the rest of SRAM
#endif
