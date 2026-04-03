.globl main
.extern printf
.extern atoi

.section .rodata
fmt_first: .string "%d"
fmt_rest:  .string " %d"
fmt_last:  .string " %d\n"

.text

main:
    mv s7, sp

    addi sp, sp, -128
    sd ra, 120(sp)
    sd s1, 104(sp)
    sd s2, 96(sp)
    sd s3, 88(sp)
    sd s4, 80(sp)
    sd s5, 72(sp)
    sd s6, 64(sp)

    mv s1, a1
    addi s2, a0, -1

    slli t1, s2, 2
    li t2, 3
    mul t1, t1, t2
    addi t1, t1, 15
    andi t1, t1, -16
    sub sp, sp, t1

    mv s3, sp
    slli t2, s2, 2
    add s4, s3, t2
    add s5, s4, t2

    li s6, -1

    li t0, 0
parse_loop:
    bge t0, s2, parse_done

    addi t3, t0, 1
    slli t3, t3, 3
    add t3, s1, t3
    ld a0, 0(t3)
    
    sd t0, 56(s7)
    call atoi
    ld t0, 56(s7)

    slli t1, t0, 2
    add t2, s3, t1
    sw a0, 0(t2)

    addi t0, t0, 1
    j parse_loop

parse_done:
    addi t0, s2, -1
    li s6, -1

nge_loop:
    blt t0, zero, nge_done

while_loop:
    blt s6, zero, while_done

    slli t1, s6, 2
    add t2, s5, t1
    lw t3, 0(t2)

    slli t4, t3, 2
    add t5, s3, t4
    lw t6, 0(t5)

    slli t1, t0, 2
    add t2, s3, t1
    lw t3, 0(t2)

    bgt t6, t3, while_done

    addi s6, s6, -1
    j while_loop

while_done:
    slli t1, t0, 2
    add t2, s4, t1

    blt s6, zero, set_minus

    slli t3, s6, 2
    add t4, s5, t3
    lw t5, 0(t4)
    sw t5, 0(t2)
    j push_stack

set_minus:
    li t1, -1
    sw t1, 0(t2)

push_stack:
    addi s6, s6, 1
    slli t1, s6, 2
    add t2, s5, t1
    sw t0, 0(t2)

    addi t0, t0, -1
    j nge_loop

nge_done:
    li t0, 0

print_loop:
    bge t0, s2, print_done

    slli t1, t0, 2
    add t2, s4, t1
    lw a1, 0(t2)

    beqz t0, first_elem

    addi t3, s2, -1
    beq t0, t3, last_elem

    la a0, fmt_rest
    j print_call

first_elem:
    addi t3, s2, -1
    beq t0, t3, last_elem
    la a0, fmt_first
    j print_call

last_elem:
    la a0, fmt_last

print_call:
    sd t0, 56(s7)
    call printf
    ld t0, 56(s7)

    addi t0, t0, 1
    j print_loop

print_done:
    addi sp, s7, -128
    ld ra, 120(sp)
    ld s1, 104(sp)
    ld s2, 96(sp)
    ld s3, 88(sp)
    ld s4, 80(sp)
    ld s5, 72(sp)
    ld s6, 64(sp)
    mv sp, s7

    li a0, 0
    ret


