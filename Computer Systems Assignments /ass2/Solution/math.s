
.pos 0x100
ld   $0x1, r0            # r0 = 1
ld   $0x4, r1            # r1 = 4
ld   $0x2, r2            # r2 = 2


ld   $a, r3           # r3 = address of a
ld   $b, r4           # r4 = address of b
ld 0x0(r4), r5        # r5 = b
mov r5, r6
add r0, r5            #r5 = b+1
add r1, r5            #r5 = b + 1 + 4
shr $1, r5           #r5 = (b + 1 + 4)/2
and r5, r6            #r5 = ((b + 1 + 4)/2 )& b
shl $2, r5           #r5 = ((b + 1 + 4)/2 )& b <<2
ld 0x0(r3), r5        #r3= r5= ((b + 1 + 4)/2 )& b << 2







.pos 0x1000
a:               .long 0xffffffff         #a

.pos 0x2000
b:               .long 0xffffffff         #b







