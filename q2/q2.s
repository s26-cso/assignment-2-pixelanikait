.globl next_greater

next_greater:
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
    mv sp, s3
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