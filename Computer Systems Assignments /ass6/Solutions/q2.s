## This is the solution to CPSC 213 Assignment 6
## Do not distribute any part of this file to anyone for any reason
## Do not remove this comment

.pos 0x1000
    ld    $5, r0            # r0 = 5 = i'
    ld    $i, r1            # r1 = &i
    st    r0, (r1)          # i = 5
    ld    $a, r1            # r1 = a
    ld    $0, r2            # r2 = 0 = s'
L0: beq   r0, L9            # goto L9 if i' == 0
    dec   r0                # i'--
    ld    (r1, r0, 4), r3   # r3 = a[i']
    bgt   r3, L1            # goto L1 if a[i'] > 0
    br    L2                # goto L2 if a[i'] <= 0
L1: add   r3, r2            # s' += a[i']
L2: br    L0                # goto L0
L9: ld    $s, r0            # r0 = &s
    st    r2, (r0)          # s = s'
    halt


.pos 0x2000
i:  .long 10
s:  .long 0
a:  .long 10
    .long -30
    .long -12
    .long 4
    .long 8
    .long 999
