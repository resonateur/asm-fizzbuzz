; target: Windows x86-64

global main
extern printf
extern exit
extern GetStdHandle
extern ReadConsoleA

section .data
    fizz db 'Fizz', 0
    buzz db 'Buzz', 0
    fizzbuzz db 'FizzBuzz', 0
    num_format db '%d', 10, 0
    nl db 10, 0
    exit_msg db 'Press any key to exit...', 10, 0

section .bss
    stdin_handle resq 1
    input_buffer resb 1
    chars_read resq 1

section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32     ; shadow space for windows x64 calling convention

    mov r12, 1      ; using r12 as the counter

loop_start:
    cmp r12, 778    ; loop from 1 to 777
    je wait_for_key ; when done, jump to wait for a keypress

    mov rax, r12
    mov rdx, 0
    mov rcx, 15
    div rcx
    cmp rdx, 0
    je print_fizzbuzz

    mov rax, r12
    mov rdx, 0
    mov rcx, 3
    div rcx
    cmp rdx, 0
    je print_fizz

    mov rax, r12
    mov rdx, 0
    mov rcx, 5
    div rcx
    cmp rdx, 0
    je print_buzz

    ; no match, print the number
    mov rdx, r12
    mov rcx, num_format
    call printf
    jmp loop_inc

print_fizzbuzz:
    mov rcx, fizzbuzz
    call printf
    mov rcx, nl
    call printf
    jmp loop_inc

print_fizz:
    mov rcx, fizz
    call printf
    mov rcx, nl
    call printf
    jmp loop_inc

print_buzz:
    mov rcx, buzz
    call printf
    mov rcx, nl
    call printf
    jmp loop_inc

loop_inc:
    inc r12
    jmp loop_start

wait_for_key:
    ; print the 'press any key' message
    mov rcx, exit_msg
    call printf

    ; get a handle to the stdin (the keyboard)
    mov rcx, -10 ; STD_INPUT_HANDLE is -10
    call GetStdHandle
    mov [stdin_handle], rax

    ; call ReadConsoleA to wait for one character
    mov rcx, [stdin_handle]     ; 1st arg: handle to stdin
    mov rdx, input_buffer       ; 2nd arg: buffer to store keypress
    mov r8, 1                   ; 3rd arg: number of chars to read
    mov r9, chars_read          ; 4th arg: pointer to store number of chars read
    push qword 0                ; 5th arg: pInputControl (must be null)
    call ReadConsoleA

    ; exit the program
    mov rcx, 0
    call exit