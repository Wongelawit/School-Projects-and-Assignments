.pos 0x0
ld   $sb, r5 		   # initialize a stack pointer
inca r5				   # inca the stack pointer for saving the wasted 4-bytes
gpc  $6, r6            # return address = PC + 6
j    0x300             # gpto 0x300
halt                   # end
.pos 0x100
.long 0x00001000       # p = 0x1000 = &s[0]
.pos 0x200
ld   0x0(r5), r0       # r0 = a1
ld   0x4(r5), r1       # r1 = a2
ld   $0x100, r2        # r2 = 0x100 = &p
ld   0x0(r2), r2       # r2 = p = &s[0]
ld   (r2, r1, 4), r3   # r3 = s[a2]
add  r3, r0            # r0 = a1 + s[a2]
st   r0, (r2, r1, 4)   # s[a2] += a1
j    0x0(r6)           # return
.pos 0x300
ld   $0xfffffff4, r0   # r0 = -12
add  r0, r5            # r5 -= 12
st   r6, 0x8(r5)       # ra = 8(r5) = r6
ld   $0x1, r0          # r0 = 1
st   r0, 0x0(r5)       # local1 = 0(r5) = 1
ld   $0x2, r0          # r0 = 2
st   r0, 0x4(r5)       # local2 = 4(r5) = 2
ld   $0xfffffff8, r0   # r0 = -8
add  r0, r5            # r5 -= 8
ld   $0x3, r0          # r0 = 3
st   r0, 0x0(r5)       # a1 = 0(r5) = 3
ld   $0x4, r0          # r0 = 4
st   r0, 0x4(r5)       # a2 = 4(r5) = 4
gpc  $6, r6            # r6 = pc + 6
j    0x200			   # goto 0x200
ld   $0x8, r0          # r0 = 8
add  r0, r5            # r5 += 8
ld   0x0(r5), r1       # r1 = local1
ld   0x4(r5), r2       # r2 = local2
ld   $0xfffffff8, r0   # r0 = -8
add  r0, r5            # r5 += 8
st   r1, 0x0(r5)       # a3 = r1
st   r2, 0x4(r5)       # a4 = r2
gpc  $6, r6            # r6 = pc + 6
j    0x200			   # goto 0x200
ld   $0x8, r0          # r0 = 8
add  r0, r5            # r5 += 8
ld   0x8(r5), r6       # r6 = ra
ld   $0xc, r0          # r0 = 12
add  r0, r5            # r5 += 12
j    0x0(r6)           # return
.pos 0x1000
.long 0x00000000       # s[0]
.long 0x00000000       # s[1]
.long 0x00000000       # s[2]
.long 0x00000000       # s[3]
.long 0x00000000       # s[4]
.long 0x00000000       # s[5]
.long 0x00000000       # s[6]
.long 0x00000000       # s[7]
.long 0x00000000       # s[8]
.long 0x00000000       # s[9]
.pos 0x8000
# These are here so you can see (some of) the stack contents.
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
sb: .long 0
