.globl make_node
.globl insert
.globl get
.globl getAtMost

.extern malloc

make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd a0, 0(sp)

    mv t0, a0

    li a0, 24          
    call malloc       

    ld t0, 0(sp)
    sw t0, 0(a0)
    sd zero, 8(a0)     
    sd zero, 16(a0)

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

insert:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd a0, 8(sp)

    beqz a0, insert_create

    lw t0, 0(a0)

    blt a1, t0, insert_left
    bgt a1, t0, insert_right

    # equal → return root
    ld a0, 8(sp)
    j insert_end

insert_left:
    ld t1, 8(a0)
    mv a0, t1
    call insert

    ld t2, 8(sp)    
    sd a0, 8(t2) 
    mv a0, t2
    j insert_end

insert_right:
    ld t1, 16(a0)
    mv a0, t1
    call insert

    ld t2, 8(sp)
    sd a0, 16(t2)
    mv a0, t2
    j insert_end

insert_create:
    mv a0, a1
    call make_node

insert_end:
    ld ra, 16(sp)
    addi sp, sp, 24
    ret

get:
    addi sp, sp, -16
    sd ra, 8(sp)

    beqz a0, get_not_found

    lw t0, 0(a0)
    beq a1, t0, get_found

    blt a1, t0, get_left

    # go right
    ld a0, 16(a0)
    call get
    j get_end

get_left:
    ld a0, 8(a0)
    call get
    j get_end

get_found:
    # a0 already has root
    j get_end

get_not_found:
    li a0, 0

get_end:
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

getAtMost:
    addi sp, sp, -16
    sd ra, 8(sp)

    li t0, -1        

loop_getAtMost:
    beqz a1, done_getAtMost

    lw t1, 0(a1)     

    ble t1, a0, valid_case

    # go left
    ld a1, 8(a1)
    j loop_getAtMost

valid_case:
    mv t0, t1        
    ld a1, 16(a1)      
    j loop_getAtMost

done_getAtMost:
    mv a0, t0

    ld ra, 8(sp)
    addi sp, sp, 16
    ret



