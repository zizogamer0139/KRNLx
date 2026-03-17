@echo off
REM Compile KRNLx
C:\Users\ZizoM\AppData\Local\bin\NASM\nasm.exe src\boot.asm -f bin -o build\boot.bin
C:\Users\ZizoM\AppData\Local\bin\NASM\nasm.exe src\kernel.asm -f bin -o build\kernel.bin

REM Merge files into KRNLx image
copy /b build\boot.bin+build\kernel.bin build\krnlx.img

REM Run in QEMU
qemu-system-x86_64 build\krnlx.img