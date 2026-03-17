[org 0x8000]
bits 16

%include "terminal.asm"

start:

; clear screen
mov ax,0003h
int 10h

; boot message
mov si,boot_msg
call print_string

; wait ~3 seconds
call delay

; clear again
mov ax,0003h
int 10h

; start terminal
call terminal_start

jmp $

; -----------------
; print_string
; -----------------

print_string:

.next
lodsb
cmp al,0
je .done

mov ah,0Eh
int 10h
jmp .next

.done
ret


; -----------------
; delay (~3 sec)
; -----------------

delay:

push ax
push bx
push dx

mov ah,00h
int 1Ah
mov bx,dx

.wait
mov ah,00h
int 1Ah
mov ax,dx
sub ax,bx
cmp ax,54
jl .wait

pop dx
pop bx
pop ax
ret


; -----------------
; data
; -----------------

boot_msg db "Successfully Booted Into KRNLx!",13,10,0