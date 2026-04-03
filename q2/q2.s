.globl main
.globl next_greater

next_greater:
    # a0 = arr, a1 = n, a2 = result
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    sd s1, 40(sp)
    sd s2, 32(sp)
    sd s3, 24(sp)
    sd s4, 16(sp)
    sd s5, 8(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    slli t0, s1, 2
    addi t0, t0, 15
    andi t0, t0, -16
    sub sp, sp, t0
    mv s3, sp
    li s4, -1
    addi s5, s1, -1

nge_loop:
    blt s5, zero, nge_done

while_loop:
    blt s4, zero, while_done

    slli t0, s4, 2
    add t1, s3, t0
    lw t2, 0(t1)

    slli t3, t2, 2
    add t4, s0, t3
    lw t5, 0(t4)

    slli t0, s5, 2
    add t1, s0, t0
    lw t6, 0(t1)

    bgt t5, t6, while_done
    addi s4, s4, -1
    j while_loop

while_done:
    slli t0, s5, 2
    add t1, s2, t0

    blt s4, zero, set_minus

    slli t2, s4, 2
    add t3, s3, t2
    lw t4, 0(t3)
    sw t4, 0(t1)
    j push_stack

set_minus:
    li t0, -1
    sw t0, 0(t1)

push_stack:
    addi s4, s4, 1
    slli t0, s4, 2
    add t1, s3, t0
    sw s5, 0(t1)
    addi s5, s5, -1
    j nge_loop

nge_done:
    slli t0, s1, 2
    addi t0, t0, 15
    andi t0, t0, -16
    add sp, sp, t0

    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    ld s4, 16(sp)
    ld s5, 8(sp)
    addi sp, sp, 64
    ret

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

    # allocate arr and result
    slli t1, s2, 2
    li t2, 2
    mul t1, t1, t2
    addi t1, t1, 15
    andi t1, t1, -16
    sub sp, sp, t1

    mv s3, sp
    slli t2, s2, 2
    add s4, s3, t2

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
    mv a0, s3
    mv a1, s2
    mv a2, s4
    sd ra, 120(s7)
    call next_greater
    ld ra, 120(s7)

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