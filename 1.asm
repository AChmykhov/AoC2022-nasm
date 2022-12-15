; Adven of Code 2022 task 1



section .data
    stopsym: db '@'     ; symbol that indicates that file has ended. Not 0x00 cause i need
                        ; to be able to add this symbol manually.
    ;display: dt 0x00    ; integer to print
    maximum: dd 0x00    ; max sum for each elf, at the end of the program there will be the answer
    newlinef: db 0x01   ; new line flag, indicates that last readed symbol was 0x0a

    TENTH: dq  0xcccccccccccccccd   ; magic number devision by invariant multiplicaton. (2**67)/10+1
                                    ; not equ BECAUSE MUL DOUES NOT TAKE imm64

section .bss
    number: resd 1      ; currently readed number

section .text
global _start

_start:
    mov dword [maximum], 3 ; proof of concept
    mov dword eax, [maximum]  ; put printing buffer in rax
    call _printINT      ; print result on user screen
    jmp _exit


_printINT:          ; print integer subroutine. prints number from rax, assuming it is not zero (TODO)
    xor rdi, rdi    ; zero out result register
    xor rbx, rbx    ; zero out count how many characters was processed
.loop:
    mov rcx, rax    ; save original number
    mul qword [TENTH]   ; divide by 10 using magic number
    shr rdx, 3      ; get int part of result in rdx, shift 3 cause magic number used 67
    mov rax, rdx    ; store result of div for next loop
    lea rdx, [rdx+rdx*4] ;multiply by 5
    shl rdi, 8      ; make room for byte
    lea rdx, [rdx*2 - '0']  ; make it mul by 10, and conver to ascii
    sub rcx, rdx    ; get remainder and it is already ascii (magic)
    lea rdi, [rdi+rcx]  ; store this byte
;    inc rbx         ; increment numbers count
;    cmp rbx, 8 ; test if result string at max capacity
;    jz .print8
    push rax
    call _printRDI
    pop rax
;.ending:
    test rax, rax   ; test if original number is reduced to 0
    jnz .loop
    ;call _printRDI  ; call print if we are done
    ret

;.print8:
;    test rax, rax
;    jz .ending  ;prevent double printing if this was called on last iteration
;
;    push rax    ; save original number
;    call _printRDI
;    pop rax     ; restore original number
;    jmp .ending ; return to main loop


_printRDI:              ; subroutine to print string in rdi, number of bytes is in rbx, this is done for speed
    push rcx            ; expecting to get buffer in rax, moving it in right place for syscall
;    mov rdx, rbx        ; move number of bytes from rbx
    mov rax, 1          ; syscall write is 1
    mov rdi, 1          ; writing to STDOUT
    mov rsi, rsp        ; put pointer to to-print buffer in rsi
    mov rdx, 1          ; printing one byte
    syscall
    pop rcx
    ret



_exit:                  ; exit gracefully via SYS_EXIT
    mov rax, 60
    mov rdi, 0
    syscall
