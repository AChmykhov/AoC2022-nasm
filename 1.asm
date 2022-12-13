; Advent of Code 2022 task 1



section .data
    stopsym: db '@'     ; symbol that indicates that file has ended. Not 0x00 cause i need
                        ; to be able to add this symbol manually.

section .bss
    maximum: dd 0x0     ; max sum for each elf, at the end of the program there will be the answer
    number: resw 1      ; currently readed number
    newlinef: db 0x01   ; new line flag, indicates that last readed symbol was 0x0a

section .text
global _start

_start:
    mov maximum, 1337000 ; proof of concept
    call _print          ; print result on user screen
    jmp _exit


_print:                 ; print integer subroutine. prints number from maximum.
    

_exit:                  ; exit gracefully via SYS_EXIT
    mov rax, 60
    mov rdi, 0
    syscall
