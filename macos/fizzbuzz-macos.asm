; target: macOS arm64

.section __DATA, __data
    fizz:       .asciz 'Fizz\n'
    buzz:       .asciz 'Buzz\n'
    fizzbuzz:   .asciz 'FizzBuzz\n'
    num_format: .asciz '%d\n'
    exit_msg:   .asciz 'Press any key to exit...'

.section __TEXT, __text
.globl _main
.align 2

_main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    mov x19, 1                ; using x19 as the loop counter

loop_start:
    cmp x19, 778              ; loop from 1 to 777
    b.eq wait_for_key

    ; divisibility by 15
    mov x1, 15
    udiv x2, x19, x1
    msub x3, x2, x1, x19
    cmp x3, #0
    b.eq print_fizzbuzz

    ; divisibility by 3
    mov x1, 3
    udiv x2, x19, x1
    msub x3, x2, x1, x19
    cmp x3, #0
    b.eq print_fizz

    ; divisibility by 5
    mov x1, 5
    udiv x2, x19, x1
    msub x3, x2, x1, x19
    cmp x3, #0
    b.eq print_buzz

    ; no match, print the number
    adrp x0, num_format@PAGE
    add x0, x0, num_format@PAGEOFF
    mov x1, x19
    stp x19, x30, [sp, -16]!  ; SAVE counter (x19) and link register (x30)
    bl _printf
    ldp x19, x30, [sp], 16    ; RESTORE counter and link register
    b loop_inc

print_fizzbuzz:
    adrp x0, fizzbuzz@PAGE
    add x0, x0, fizzbuzz@PAGEOFF
    stp x19, x30, [sp, -16]!
    bl _printf
    ldp x19, x30, [sp], 16
    b loop_inc

print_fizz:
    adrp x0, fizz@PAGE
    add x0, x0, fizz@PAGEOFF
    stp x19, x30, [sp, -16]!
    bl _printf
    ldp x19, x30, [sp], 16
    b loop_inc

print_buzz:
    adrp x0, buzz@PAGE
    add x0, x0, buzz@PAGEOFF
    stp x19, x30, [sp, -16]!
    bl _printf
    ldp x19, x30, [sp], 16
    b loop_inc

loop_inc:
    add x19, x19, 1           ; increment counter
    b loop_start

wait_for_key:
    adrp x0, exit_msg@PAGE
    add x0, x0, exit_msg@PAGEOFF
    bl _printf                ; this printf call doesn't need saving around it
                              ; because the loop is over and x19 is not used again.
    bl _getchar

    mov x0, 0
    ldp x29, x30, [sp], 16    ; standard function epilogue
    bl _exit