; Advent of Code 2022 task 1



section .data
    stopsym: db '@'     ; symbol that indicates that file has ended. Not 0x00 cause i need
                        ; to be able to add this symbol manually.

    maximum: dd 0x00    ; max sum for each elf, at the end of the program there will be the answer
    newlinef: db 0x01   ; new line flag, indicates that last readed symbol was 0x0a

    TENTH: equ 1844674407370955162  ; magic number devision by invariant multiplicaton. (2**63)/10+1

section .bss
    number: resd 1      ; currently readed number

section .text
global _start

_start:
    mov dword [maximum], 1337000d ; proof of concept
    call _print          ; print result on user screen
    jmp _exit


_print:                 ; print integer subroutine. prints number from maximum.
   mov rax, '9'         ; proof of concept
   call _printRAX
   mov rax, 0xa
   call _printRAX
   ret


_printRAX:              ; subroutine to print one symbol
    push rax            ; expecting to get buffer in rax, moving it in right place for syscall
    mov rax, 1          ; syscall write is 1
    mov rdi, 1          ; writing to STDOUT
    mov rsi, rsp        ; put pointer to to-print buffer in rsi
    mov rdx, 1          ; printing one byte
    syscall
    pop rax
    ret



_exit:                  ; exit gracefully via SYS_EXIT
    mov rax, 60
    mov rdi, 0
    syscall
