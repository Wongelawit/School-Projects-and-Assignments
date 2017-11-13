## This is the solution to CPSC 213 Assignment 6
## Do not distribute any part of this file to anyone for any reason
## Do not remove this comment

.pos 0x1000
    ld  $0, r0
    ld  $0, r1
    ld  $0, r2
    ld  $0, r3
    ld  $0, r4
    ld  $0, r5
    ld  $0, r6
    ld  $-1, r7
    br  L0
    nop
    nop
    L1: br  L2
    nop
    nop
L0: br  L1
L2: ld $1, r0
    j L3

.pos 0x2000
L3: ld  $1, r1
    beq r1, L4
    ld  $1, r2
L4: ld  $1, r3
    bgt r1, L5
    ld  $0, r3
L5: beq r6, L6
    ld  $0, r2
L6: bgt r6, L7
    br  L8
L7: ld  $0, r3
L8: bgt r7, L8
    br  L9
    ld  $0, r3
L9: j   LA

.pos 0x3000
LA: gpc $4, r4
    ld  $LB, r5
    j   4(r5)
    halt
LB: halt
    halt
    ld  $1, r5
    halt


## br  works if r0 is 1
## j   works if r1 is 1
## beq works if r2 is 1
## bgt works if r3 is 1
## gpc works if r4 is 0x3006
## j() works if r5 is 1

