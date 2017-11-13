#
# This is the solution to CPSC 213 Assignment 8.
# Do not share this code or any portion of it with anyone in any way.
# Do not remove this comment.
#

.pos 0x0
                 ld   $0x1028, r5         
                 ld   $0xfffffff4, r0     
                 add  r0, r5              # setup stack
                 ld   $0x200, r0          # r0 = &a
                 ld   0x0(r0), r0         # r0 = a
                 st   r0, 0x0(r5)         # push a on stack
                 ld   $0x204, r0          # r0 = &b
                 ld   0x0(r0), r0         # r0 = b
                 st   r0, 0x4(r5)         # push b on stack
                 ld   $0x208, r0          # r0 = &c
                 ld   0x0(r0), r0         # r0 = c
                 st   r0, 0x8(r5)         # push c on stack
                 gpc  $0x6, r6            # r6 = return address
                 j    0x300               # r0 = foo (a,b,c)
                 ld   $0x20c, r1          # r1 = &c
                 st   r0, 0x0(r1)         # c = r0 = foo (a,b,c)
                 halt                     
.pos 0x200
                 .long 0x0                # a
                 .long 0x0                # b
                 .long 0x0                # c
                 .long 0x0                # d
.pos 0x300
                 ld   0x0(r5), r0         # r0 = f
                 ld   0x4(r5), r1         # r1 = i
                 ld   0x8(r5), r2         # r2 = j
                 ld   $0xfffffff6, r3     # r3 = -10
                 add  r3, r0              # r0 = f-10
                 mov  r0, r3              # r3 = f-10
                 not  r3                  
                 inc  r3                  # r3 = 10-f
                 bgt  r3, default         # goto L6 if f<10
                 mov  r0, r3              # r3 = f-10
                 ld   $0xfffffff8, r4     # r4 = -8
                 add  r4, r3              # r3 = f-18
                 bgt  r3, default         # goto L5 if f>18
                 ld   $0x400, r3          # r3 = jt
                 j    *(r3, r0, 4)        # goto ht [f-10]
.pos 0x330
case_10:         add  r1, r2              # j = j + 1
                 br   L7                  # break
case_12:         not  r2                  
                 inc  r2                  # r2 = -j
                 add  r1, r2              # j = i - j
                 br   L7                  # break
case_14:         not  r2                  
                 inc  r2                  # r2 = -j
                 add  r1, r2              # r2 = i - j
                 bgt  r2, L0              # goto L0 if i > j
                 ld   $0x0, r2            # j = 0 if i<=j
                 br   L1                  
L0:              ld   $0x1, r2            # j = 1 if i> j
L1:              br   L7                  # break
case_16:         not  r1                  
                 inc  r1                  # r1 = -i
                 add  r2, r1              # r1 = j - i
                 bgt  r1, L2              # goto L2 if j > i
                 ld   $0x0, r2            # j = 0 if j <= i
                 br   L3                  
L2:              ld   $0x1, r2            # j = 1 if j > 1
L3:              br   L7                  # break
case_18:         not  r2                  
                 inc  r2                  # r2 = -j
                 add  r1, r2              # r2 = i-j
                 beq  r2, L4              # goto L4 if i==j
                 ld   $0x0, r2            # j = 0 if i != j
                 br   L5                  
L4:              ld   $0x1, r2            # j = 1 if i == j
L5:              br   L7                  # break
default:         ld   $0x0, r2            # j = 0
                 br   L7                  # break
L7:              mov  r2, r0              # return value is j
                 j    0x0(r6)             
.pos 0x400                                # jt
                 .long 0x330
                 .long 0x384              
                 .long 0x334              
                 .long 0x384              
                 .long 0x33c              
                 .long 0x384              
                 .long 0x354              
                 .long 0x384              
                 .long 0x36c              # stack
.pos 0x1000
                 .long 0x0
                 .long 0x0                
                 .long 0x0                
                 .long 0x0                
                 .long 0x0                
                 .long 0x0                
                 .long 0x0                
                 .long 0x0                
                 .long 0x0                
                 .long 0x0                
