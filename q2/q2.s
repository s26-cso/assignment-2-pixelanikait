.globl main
.extern printf
.extern atoi

.section .rodata
fmt_first: .string "%d"
fmt_rest:  .string " %d"
fmt_last: .string " %d\n"
nl:        .byte 10

.text

main:
    mv s7, sp

    addi sp, sp, -128
    sd ra, 120(sp)
    sd s0, 112(sp)
    sd s8, 104(sp)
    sd s1, 96(sp)
    sd s2, 88(sp)
    sd s3, 80(sp)
    sd s4, 72(sp)
    sd s5, 64(sp)
    sd s6, 56(sp)

    mv s0, a0         
    mv s1, a1          

    addi t0, s0, -1    
    mv s2, t0          

    slli t1, s2, 3      

    li   t2, 3
    mul  t1, t1, t2
    addi t1, t1, 15
    andi t1, t1, -16  
    sub  sp, sp, t1     

    mv s3, sp          
    slli t2, s2, 3
    add  s4, s3, t2     
    add  s5, s4, t2    

    li s6, -1
    li s8, 1

    ble s2, zero, print_done

parse_loop:
    bge s8, s0, parse_done
    slli t3, s8, 3
    add t4, s1, t3
    ld a0, 0(t4)
    call atoi
    addi t5, s8, -1
    slli t5, t5, 3
    add t6, s3, t5
    sd a0, 0(t6)
    addi s8, s8, 1
    j parse_loop

parse_done:
    addi t0, s2, -1  

nge_loop:
    blt t0, zero, nge_done

while_loop:
    blt s6, zero, while_done

    slli t1, s6, 3
    add t2, s5, t1
    ld t3, 0(t2)     

    slli t4, t3, 3
    add t5, s3, t4
    ld t6, 0(t5)      

    slli t1, t0, 3
    add t2, s3, t1
    ld t3, 0(t2)      

    bgt t6, t3, while_done

    addi s6, s6, -1
    j while_loop

while_done:
    slli t1, t0, 3
    add t2, s4, t1     

    blt s6, zero, set_minus

    slli t3, s6, 3
    add t4, s5, t3
    ld t5, 0(t4)

    sd t5, 0(t2)  
    j push_stack

set_minus:
    li t1, -1
    sd t1, 0(t2)

push_stack:
    addi s6, s6, 1
    slli t1, s6, 3
    add t2, s5, t1
    sd t0, 0(t2)

    addi t0, t0, -1
    j nge_loop

nge_done:
    li t0, 0

print_loop:
    bge t0, s2, print_done

    slli t1, t0, 3
    add t2, s4, t1
    ld a1, 0(t2)

    beq t0, zero, first_elem

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
    mv s9, t0
    call printf
    mv t0, s9

    addi t0, t0, 1
    j print_loop

print_done:
    ld ra, 120(sp)
    ld s0, 112(sp)
    ld s8, 104(sp)
    ld s1, 96(sp)
    ld s2, 88(sp)
    ld s3, 80(sp)
    ld s4, 72(sp)
    ld s5, 64(sp)
    ld s6, 56(sp)

    mv sp, s7

    li a0, 0
    li a7, 93     # exit syscall
    ecall

