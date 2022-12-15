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
    number: resd 1  ; currently readed number
;    output: resq 1  ; currently printed out number. tword becau
section .text
global _start

_start:
    mov dword [maximum], 1200    ; proof of concept
    mov dword eax, [maximum]  ; put printing buffer in rax
    call _printINT  ; print result on user screen
    jmp _exit


_printINT:          ; print integer subroutine. prints number from rax, assuming it is not zero (TODO ?)
                    ; printing 8 least significant digits, suited for printing dword (TODO: make it print QWORD)
                    ; If number is less then 8 digits, rest will be filled with NUL (\0) FROM THE RIGHT. IDK why
    xor rdi, rdi    ; clear output register
.loop:              ; do{
    mov rcx, rax    ; save original number
    mul qword [TENTH]   ; divide by 10 using magic number
    shr rdx, 3      ; get int part of result in rdx, shift 3 cause magic number used 67
    mov rax, rdx    ; store result of div for next loop
    lea rdx, [rdx+rdx*4] ;multiply by 5
    shl rdi, 8      ; make room for byte
    lea rdx, [rdx*2 - '0']  ; make it mul by 10, and conver to ascii
    sub rcx, rdx    ; get remainder and it is already ascii (magic)
    add rdi, rcx  ; store this byte
    test rax, rax   ; } while(rax) ; test if original number is reduced to 0
    jnz .loop
    push rdi
    mov rax, rsp ; pointer to the buffer in RAX
    mov rdi, 8     ; number of bytes to print in buffer: 8
    call _printRAX  ; print buffer
    pop rdi
    push 0x0A       ; setup buffer for printing '\n'
    mov rax, rsp    ; put pointer
    mov rdi, 1      ; printing 1 byte
    call _printRAX  ; print '\n'
    pop rax         ; clear stack (or we will get seg fault
    ret


_printRAX:          ; subroutine to print string with pointer in rax,
                    ; number of bytes in rdi
; syscall write remainder: #=1 in RAX, fd (=1 for STDOUT) in RDI, *buff in RSI, bytes count in RDX;
    mov rsi, rax    ; mapping args: buffer pointer in rsi for syscall
    mov rdx, rdi    ; mapping args: bytes count in rdx for syscall
    mov rax, 1      ; syscall write is 1
    mov rdi, 1      ; writing to STDOUT
    syscall
    ret



_exit:                  ; exit gracefully via SYS_EXIT
    mov rax, 60
    mov rdi, 0
    syscall
