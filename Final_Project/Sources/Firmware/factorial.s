
#    Assembly Program of an ABI function that calculates factorial of n.
#    Value of n is passed to this program as the first function argument.
#    In Conventional RISC-V software, x10 or a0 is used as both the first function argument and return value.


# Initializing the value of n
    addi    a0, zero, 5

factorial:
    # Setup code, to be executed once
loop:
    # Main code implementing the factorial calculation
    ebreak