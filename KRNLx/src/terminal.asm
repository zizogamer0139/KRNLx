bits 16

terminal_start:

mov si,welcome
call print_string

terminal_loop:

mov si,prompt
call print_string

call read_line

mov si,input_buffer
call process_command

jmp terminal_loop


; -----------------
; read_line
; -----------------

read_line:

mov di,input_buffer

.read_loop

mov ah,0
int 16h

cmp al,13
je .done

cmp al,8
je .backspace

stosb

mov ah,0Eh
int 10h

jmp .read_loop


.backspace

cmp di,input_buffer
jbe .read_loop

dec di

mov ah,0Eh
mov al,8
int 10h
mov al,' '
int 10h
mov al,8
int 10h

jmp .read_loop


.done

mov al,0
stosb

mov ah,0Eh
mov al,13
int 10h
mov al,10
int 10h

ret


; -----------------
; process_command
; -----------------

process_command:

mov si,input_buffer
mov di,cmd_help
call strcmp
cmp ax,1
je cmd_help_run

mov si,input_buffer
mov di,cmd_clear
call strcmp
cmp ax,1
je cmd_clear_run

mov si,input_buffer
mov di,cmd_echo
call strcmp
cmp ax,1
je cmd_echo_run

mov si,unknown
call print_string
ret


; -----------------
; help
; -----------------

cmd_help_run:

mov si,help_msg
call print_string
ret


; -----------------
; clear
; -----------------

cmd_clear_run:

mov ax,0003h
int 10h
ret


; -----------------
; echo
; -----------------

cmd_echo_run:

mov si,input_buffer
add si,5
call print_string

mov ah,0Eh
mov al,13
int 10h
mov al,10
int 10h

ret


; -----------------
; strcmp
; -----------------

strcmp:

.compare

mov al,[si]
mov bl,[di]

cmp al,0
je .check_end

cmp al,bl
jne .not_equal

inc si
inc di
jmp .compare

.check_end

cmp byte [di],0
jne .not_equal

mov ax,1
ret

.not_equal

mov ax,0
ret


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
; data
; -----------------

welcome db "KRNLx Terminal v0.2",13,10,0
prompt db "KRNLx> ",0

cmd_help db "help",0
cmd_clear db "clear",0
cmd_echo db "echo ",0

help_msg db "Commands: help clear echo",13,10,0
unknown db "Unknown command",13,10,0

input_buffer times 64 db 0