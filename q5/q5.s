.globl main
.extern fopen
.extern fclose
.extern fseek
.extern ftell
.extern fgetc

.section .rodata
filename: .string "input.txt"
mode_r:   .string "r"
yes_str:  .string "Yes\n"
no_str:   .string "No\n"

.text

main:
    mv s7, sp
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    sd s1, 40(sp)
    sd s2, 32(sp)
    sd s3, 24(sp)

    # fopen("input.txt", "r")
    la a0, filename
    la a1, mode_r
    call fopen
    mv s0, a0          # s0 = FILE*

    # fseek(fp, 0, SEEK_END=2)
    mv a0, s0
    li a1, 0
    li a2, 2
    call fseek

    # ftell(fp) → file length
    mv a0, s0
    call ftell
    mv s1, a0          # s1 = length

    # s2 = left = 0
    # s3 = right = length - 1
    li s2, 0
    addi s3, s1, -1

palindrome_loop:
    bge s2, s3, print_yes

    # read char at left: fseek to s2, fgetc
    mv a0, s0
    mv a1, s2
    li a2, 0           # SEEK_SET
    call fseek
    mv a0, s0
    call fgetc
    mv t0, a0          # t0 = left char

    # read char at right: fseek to s3, fgetc
    mv a0, s0
    mv a1, s3
    li a2, 0           # SEEK_SET
    call fseek
    mv a0, s0
    call fgetc
    mv t1, a0          # t1 = right char

    bne t0, t1, print_no

    addi s2, s2, 1
    addi s3, s3, -1
    j palindrome_loop

print_yes:
    la a0, yes_str
    call printf
    j done

print_no:
    la a0, no_str
    call printf

done:
    mv a0, s0
    call fclose

    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    addi sp, sp, 64

    li a0, 0
    ret

