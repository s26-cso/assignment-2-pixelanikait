.globl main
.extern printf
.extern atoi
.extern putchar

.section .rodata
fmt_first: .string "%d"
fmt_rest:  .string " %d"
fmt_nl:    .string "\n"

.text

main:
    mv s7, sp

    addi sp, sp, -128
    sd ra, 120(sp)
    sd s0, 112(sp)
    sd s8, 104(sp)

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

    addi t3, s7, -128
    sd t0, 96(t3)

    beqz t0, print_first    # if t0==0, use fmt_first
    la a0, fmt_rest
    j print_call
print_first:
    la a0, fmt_first
print_call:
    call printf

    addi t3, s7, -128
    ld t0, 96(t3)
    addi t0, t0, 1
    j print_loop
    
print_done:
    addi sp, s7, -128
    ld ra, 120(sp)
    ld s0, 112(sp)
    ld s8, 104(sp)
    mv sp, s7

    addi sp, sp, -16
    sd ra, 0(sp)
    li a0, 10
    call putchar
    ld ra, 0(sp)
    addi sp, sp, 16

    li a0, 0
    ret

