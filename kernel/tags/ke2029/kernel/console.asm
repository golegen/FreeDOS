;
; File:
;                          console.asm
; Description:
;                      Console device driver
;
;                       Copyright (c) 1998
;                       Pasquale J. Villani
;                       All Rights Reserved
;
; This file is part of DOS-C.
;
; DOS-C is free software; you can redistribute it and/or
; modify it under the terms of the GNU General Public License
; as published by the Free Software Foundation; either version
; 2, or (at your option) any later version.
;
; DOS-C is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
; the GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public
; License along with DOS-C; see the file COPYING.  If not,
; write to the Free Software Foundation, 675 Mass Ave,
; Cambridge, MA 02139, USA.
;
; $Header$
;

                %include "io.inc"


segment	_IO_FIXED_DATA

                global  ConTable
ConTable        db      0Ah
                dw      _IOExit
                dw      _IOExit
                dw      _IOExit
                dw      _IOCommandError
                dw      ConRead
                dw      CommonNdRdExit
                dw      ConInStat
                dw      ConInpFlush
                dw      ConWrite
                dw      ConWrite
                dw      _IOExit

PRT_SCREEN      equ     7200h
CTL_P           equ     10h

segment	_LOWTEXT

uScanCode	db	0		; Scan code for con: device

;
; Name:
;       ConRead
;
; Function:
;       Read to address in es:di characters from the keyboard.  Cx contains
;       a count of how many characters are to be transferred.
;
; Description:
;       Calls KbdRdChar to read the characters.  Destroys ax.
;
                global  ConRead
ConRead:
                jcxz    ConRead2                ; Exit if read of zero

ConRead1:
                call    KbdRdChar               ; Get a char from kbd in al
                stosb                           ; Store al to es:[di]
                loop    ConRead1                ; Loop until all are read

ConRead2:
                jmp     _IOExit


;
; Name:
;       KbdRdChar
;
; Function:
;       Read a character from the keyboard.
;
; Description:
;       This subroutine reads a character fromthe keyboard.  It also handles
;       a couple of special functions.  It converts the print screen key to
;       a control-P.  It also accounts for extended scan codes by saving off
;       the high byte of the return and returning it if it was non-zero on
;       the previous read.
;
                global  KbdRdChar
KbdRdChar:
                xor     ax,ax                   ; Zero the scratch register
                xchg    [cs:uScanCode],al	; and swap with scan code
                or      al,al                   ; Test to see if it was set
                jnz     KbdRdRtn                ; Exit if it was, returning it
                int     16h                     ; get keybd char in al, ah=scan
                or      ax,ax                   ; Zero ?
                jz      KbdRdChar               ; Loop if it is
                cmp     ax,PRT_SCREEN           ; Print screen?
                jne     KbdRd1                  ; Nope, keep going
                mov     al,CTL_P                        ; Yep, make it ^P
KbdRd1:
                or      al,al                   ; Extended key?
                jnz     KbdRdRtn                ; Nope, just exit
                mov     [cs:uScanCode],ah	; Yep, save the scan code
KbdRdRtn:
                retn



                global  CommonNdRdExit
CommonNdRdExit:
                mov     al,[cs:uScanCode]       ; Test for last scan code
                or      al,al                   ; Was it zero ?
                jnz     ConNdRd2                ; Jump if there's a char waiting
                mov     ah,1
                int     16h                     ; Get status, if zf=0  al=char
                jz      ConNdRd4                ; Jump if no char available
                or      ax,ax                   ; Zero ?
                jnz     ConNdRd1                ; Jump if not zero
                int     16h                     ; get status, if zf=0  al=char
                jmp     short CommonNdRdExit

ConNdRd1:
                cmp     ax,PRT_SCREEN           ; Was print screen key pressed?
                jne     ConNdRd2                ; Jump if not
                mov     al,CTL_P

ConNdRd2:
                lds     bx,[cs:_ReqPktPtr]         ; Set the status
                mov     [bx+0Dh],al

ConNdRd3:
                jmp     _IOExit

ConNdRd4:
                jmp     _IODone



                global  ConInpFlush
ConInpFlush:
                call    KbdInpChar
                jmp     _IOExit



KbdInpChar:
                mov     byte [cs:uScanCode],0
KbdInpCh1:
                mov     ah,1
                int     16h                     ; get status, if zf=0  al=char
                jz      KbdInpRtn               ; Jump if zero
                xor     ah,ah                   ; Zero register
                int     16h                     ; get keybd char in al, ah=scan
                jmp     short KbdInpCh1
KbdInpRtn:
                retn


                global  ConWrite
ConWrite:
                jcxz    ConNdRd3                ; Exit if nothing to write
ConWr1:
                mov     al,[es:di]
                inc     di
                int     29h                     ; Do fast output call
                loop    ConWr1                  ; Loop if more to output
                jmp     _IOExit

CBreak:
                mov     byte [cs:uScanCode],3   ; Put a ^C into the buffer
IntRetn:
                iret


;                global  _cso
;_cso
;                push    bp
;                mov     bp,sp
;                push    ax
;                mov     ax,[bp+4]
;                int     29h
;                pop     ax
;                pop     bp
;                retn

                global  _int29_handler
_int29_handler:
                push    ax
                push    si
                push    di
                push    bp
                push    bx
                mov     ah,0Eh
                mov     bh,0
                mov     bl,7
                int     10h                     ; write char al, teletype mode
                pop     bx
                pop     bp
                pop     di
                pop     si
                pop     ax
                iret


;
; Name:
;       ConInStat
;
; Function:
;       Checks the keybord input buffer.
;
; Description:
;       Calls int 16 (get status). Sets Busy-Flag in status field. Destroys ax.
;
      	  	global  ConInStat
ConInStat:
                mov     al,[cs:uScanCode]       ; Test for last scan code
                or      al,al                   ; Was it zero ?
                jnz     ConCharReady            ; Jump if there's a char waiting
		mov     ah,1
		int     16h                     ; get status, if zf=0  al=char
                jz      ConNoChar               ; Jump if zero

                or      ax,ax                   ; Zero ?
                jnz     ConIS1                  ; Jump if not zero
                int     16h                     ; get status, if zf=0  al=char
                jmp     short ConInStat

ConIS1:
                cmp     ax,PRT_SCREEN           ; Was print screen key pressed?
                jne     ConIS2                  ; Jump if not
                mov     al,CTL_P

ConIS2:
                lds     bx,[cs:_ReqPktPtr]         ; Set the status
                mov     [bx+0Dh],al
ConCharReady:
                jmp     _IOExit                 ; key ready (busy=0)
ConNoChar:
                jmp     _IODone                 ; no key ready (busy=1)

