; target: Linux x86-64

section .data
    fizz      db  'Fizz'
    fizz_len  equ $ - fizz
    buzz      db  'Buzz'
    buzz_len  equ $ - buzz
    fizzbuzz  db  'FizzBuzz'
    fizzbuzz_len equ $ - fizzbuzz
    newline   db  10
    exit_msg  db  'Press any key to exit...', 10
    exit_msg_len equ $ - exit_msg

section .bss
    num_buffer resb 10 ; buffer for printing numbers
    input_char resb 1  ; 1-byte buffer for the keyboard input

section .text
    global _start

; helper functions below

; prints a string. this fn uses syscall, which clobbers rcx
; input: rsi = address, rdx = length
print_string:
    mov rax, 1      ; syscall 'write'
    mov rdi, 1      ; stdout
    syscall
    ret

; prints the number stored in ecx
print_number:
    mov rdi, num_buffer + 9 ; start from the end of the buffer
    mov eax, ecx            ; use eax for division

.convert_loop:
    xor edx, edx            ; clear edx for 32-bit division
    mov ebx, 10
    div ebx
    add edx, '0'            ; convert remainder to ASCII
    mov [rdi], dl           ; store the digit
    dec rdi                 ; move to the previous position in the buffer
    test eax, eax           ; check if the quotient is zero
    jnz .convert_loop       ; if not zero, continue converting

    inc rdi                 ; point back to the first digit
    mov rsi, rdi
    mov rdx, num_buffer + 10
    sub rdx, rsi            ; calculate the length of the number string
    
    push rcx                ; save rcx because print_string uses syscall
    call print_string
    pop rcx
    ret

; main program below

_start:
    mov ecx, 1              ; init counter to 1

main_loop:
    cmp ecx, 778            ; loop from 1 to 777
    je .wait_for_key        ; when done, jump to wait for a keypress

    ; divisibility by 15
    mov eax, ecx
    xor edx, edx
    mov ebx, 15
    div ebx
    cmp edx, 0
    je .do_fizzbuzz

    ; divisibility by 3
    mov eax, ecx
    xor edx, edx
    mov ebx, 3
    div ebx
    cmp edx, 0
    je .do_fizz

    ; divisibility by 5
    mov eax, ecx
    xor edx, edx
    mov ebx, 5
    div ebx
    cmp edx, 0
    je .do_buzz

    call print_number
    jmp .continue_loop

.do_fizzbuzz:
    mov rsi, fizzbuzz
    mov rdx, fizzbuzz_len
    push rcx
    call print_string
    pop rcx
    jmp .continue_loop

.do_fizz:
    mov rsi, fizz
    mov rdx, fizz_len
    push rcx
    call print_string
    pop rcx
    jmp .continue_loop

.do_buzz:
    mov rsi, buzz
    mov rdx, buzz_len
    push rcx
    call print_string
    pop rcx
    jmp .continue_loop

.continue_loop:
    mov rsi, newline
    mov rdx, 1
    push rcx
    call print_string
    pop rcx

    inc ecx
    jmp main_loop

.wait_for_key:
    ; print the 'press any key' message
    mov rsi, exit_msg
    mov rdx, exit_msg_len
    call print_string

    ; use the 'read' syscall to wait for one byte from stdin (the keyboard)
    mov rax, 0      ; syscall 'read'
    mov rdi, 0      ; stdin file descriptor
    mov rsi, input_char ; buffer to store the character
    mov rdx, 1      ; number of bytes to read
    syscall         ; this call will wait for user input

.exit:
    mov rax, 60     ; syscall for exit
    xor rdi, rdi    ; exit code 0
    syscall