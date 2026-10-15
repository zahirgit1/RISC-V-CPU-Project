# Directed pipeline regression: forwarding, load-use stall, branches, and JAL.
ADDI x1, x0, 64       # data-memory base (word index 16)
ADDI x2, x0, 7
ADDI x3, x0, 5
ADDI x17, x0, 0       # initialize registers used to detect skipped writes
ADDI x20, x0, 0

ADD x4, x2, x3        # forwarding into EX: x4 = 12
ADD x5, x4, x3        # EX/MEM forwarding: x5 = 17
SUB x6, x5, x2        # forwarding: x6 = 10
AND x7, x5, x4        # x7 = 0
OR x8, x5, x4         # x8 = 29
SLT x9, x6, x5        # x9 = 1

ADDI x10, x0, 42
SW x10, 0(x1)         # store-data forwarding; memory[16] = 42
LW x11, 0(x1)
ADD x12, x11, x2      # immediate load-use dependency; expected one stall, x12 = 49
ADDI x13, x0, 49

BEQ x12, x13, taken_branch
ADDI x14, x0, 111     # skipped by taken branch
taken_branch:
ADDI x14, x0, 14

BEQ x2, x3, branch_bad # not taken (7 != 5)
ADDI x15, x0, 15
JAL x16, after_jal
ADDI x17, x0, 117     # skipped by JAL
branch_bad:
ADDI x20, x0, 99      # skipped when the not-taken branch behaves correctly
after_jal:
ADD x18, x16, x0      # verify JAL link forwarding; x18 = x16
ADDI x0, x0, 99        # x0 must remain zero
ADDI x19, x0, 1
done:
JAL x0, done          # stop in a stable loop
