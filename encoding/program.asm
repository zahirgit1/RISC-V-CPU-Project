# RISC-V Program: Basic CPU Test
# This program tests I-type, S-type, R-type, and B-type instructions

ADDI x1, x0, 12      # x1 = 12 (address for store/load)
ADDI x2, x0, 10      # x2 = 10 (data to store)
SLT x7, x2, x1       # x7 = (x2<x1) = (10<12) = 1 (R-type)
ADDI x4, x0, 5       # x4 = 5 (for logic operations)
BEQ x1, x2, 16       # if x1==x2 branch (NOT taken, 12≠10)
SW x2, 48(x1)         # Store x2 at memory[x1]=12
LW x3, 0(x1)         # Load from memory[x1] into x3
ADD x4, x1, x2       # x4 = 22 (R-type, 12+10)
SUB x6, x1, x2       # x6 = 2 (R-type, 12-10)
AND x8, x4, x7       # x8 = 22 & 1 = 0 (R-type)
OR x10, x4, x7       # x10 = 22 | 1 = 23 (R-type)
ADD x0, x0, x0       # NOP
ADD x0, x0, x0       # NOP
