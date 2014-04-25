extern _GetStdHandle@4
extern _WriteConsoleA@20
extern _ExitProcess@4
extern _malloc

section .bss
        numCharsWritten:        resb 1

section .text

; Allocates eax bytes of memory. Pointer to allocated memory returned in eax.
    global __malloc
__malloc:
	push	eax			; Arg1 : push desired number of bytes
    call 	_malloc
	add		esp,	4	; restore stack pointer
    cmp 	eax, 0   	; on error, exit with code 22
    jne 	ok
    mov 	eax, 22
    call 	__debexit
ok:
    ret

; Debugging exit: ends the process, returning the value of
; eax as the exit code.
    global __debexit
__debexit:
	push    eax         ; Arg1: push exit code
	call    _ExitProcess@4

; Exceptional exit: ends the process with exit code 13.
; Call this in cases where the Joos code would throw an exception.
    global __exception
__exception:
    push 	dword 13
	call    _ExitProcess@4

; Implementation of java.io.OutputStream.nativeWrite method.
; Outputs the low-order byte of eax to standard output.
    global NATIVEjava.io.OutputStream.nativeWrite
NATIVEjava.io.OutputStream.nativeWrite:
	; get std handle
	mov 	[char], 	al ; save the low order byte in memory
	push    dword -11
	call	_GetStdHandle@4
	push    dword 0         ; Arg5: Unused so just use zero
	push    numCharsWritten ; Arg4: push pointer to numCharsWritten
	push    dword 1		    ; Arg3: push length of output string
	push    char            ; Arg2: push pointer to output string
	push    eax             ; Arg1: push handle returned from _GetStdHandle
	call    _WriteConsoleA@20
	mov eax, 0     			; return 0
    ret

section .data

char:
    dd 0
