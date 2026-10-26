# Program : Melakukan While loop hingga mencapai 10 loop (RISC-V RV32I, Venus)
main:
    ADDI x5 x0 1 # Initialize it to 1
    ADDI x6 x0 0 # Initialize sum to 0
    ADDI x7 x0 10 # Maximum value of i
    While:
    BLT x7 x5 End # Checking if 10 < i 
    ADD x6 x6 x5 # sum = sum + i
    ADDI x5 x5 1 # i = i + 1
    j While # Jumps to the end
    End:
    ADDI x10 x0 0 # return 0


