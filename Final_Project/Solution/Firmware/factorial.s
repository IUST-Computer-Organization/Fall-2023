
#    Assembly Program of an ABI function that calculates factorial of n.
#    Value of n is passed to this program as the first function argument.
#    In Conventional RISC-V software, x10 or a0 is used as both the first function argument and return value.


# Initializing the value of n
    addi    a0, zero, 5

factorial:
    addi    a1, zero, 1
    addi    a2, zero, 1
    addi    a3, a0, 1

loop:
    mul     a1, a1, a2
    addi    a2, a2, 1
    bne     a2, a3, loop
    add     a0, a1, zero
    ebreak