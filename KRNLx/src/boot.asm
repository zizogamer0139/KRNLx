; boot.asm - KRNLx Bootloader
[org 0x7C00]

mov ax, 0x0000
mov ds, ax
mov es, ax

; load 6 sectors from disk to 0x8000 (kernel + progress bar + terminal)
mov ah, 0x02        ; BIOS read sectors
mov al, 6           ; number of sectors to read
mov ch, 0            ; cylinder
mov cl, 2            ; sector
mov dh, 0            ; head
mov bx, 0x8000       ; destination address
int 0x13

jmp 0x0000:0x8000    ; jump to kernel

times 510-($-$$) db 0
dw 0xAA55            ; boot signature