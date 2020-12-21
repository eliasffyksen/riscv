start:
    addi $1, $0, 5
    addi $2, $1, 4
    beq $1, $2, start
    bne $1, $2, start
