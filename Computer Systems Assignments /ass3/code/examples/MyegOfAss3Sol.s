# exxample e1

.pos  0x200
  # b = a + 5
ld $a, r0     #r0=&a
ld (r0), r0   # r0= value of a
ld $5, r1     # r1= 5
add r1, r0    # r0= a+b
ld  $b, r1    # r1= & b
st r0, r1     #r1=a+b

 # c[0] = ~(a + c[b])
ld $a, r0    # r0= &a
ld (r0), r0  #r0= value of a
ld $b, r1    #r1= &b
ld (r1), r1  #r1= value b
ld $c, r2    #r2= & c
ld (r2, r1, 4), r1  # r1= c[b]
add r1, r0     #r0= a + c[b]
not r0          #r0= ~(a + c[b])
st  r0, 0(r2)    #r2= ~(a + c[b])

halt

.pos 0x1000
a           .long 0      #a
.pos 0x2000
b           .long 0      #b
.pos 0x300
c           .long 0      #c[0]
            .long 0      #c[1]
            .long 0      #c[2]
            .long 0      #c[3]



# e2


#d[a & 7]
ld $a, r1        #r1= & a
ld 0(r1), r1      #value of a
ld $7, r2        #r2= 7

ld $d, r0        #r0=& d
and r1, r2       #r2= d[a & 7]**

#b[c & 3]
ld $c, r0       # r0= & c
ld (r0), r0     # r0= value r0
ld $3, r1       #r1= 3
and r0, r1      #r1= c& 3
ld $b, r0       #r0= & b
ld (r0, r1, 4), r1   # r1= b[c&3]
ld $42, r3      #r3= 42
and r1, r3      #r3= b[c & 3])&42
add r2, r3      #r3= ((d[a & 7] + b[c & 3])&42)
ld 0(r0), r0    #r0=b[0]
add r0, r3      #r3=b[0]+((d[a & 7] + b[c & 3])&42)
inc r3          #r3=b[0]+((d[a & 7] + b[c & 3])&42) + 1
ld $c, r0       #r0=c
st r3, r0       #c = b[0] + ((d[a & 7] + b[c & 3])&42) + 1






.pos 0x1000
a          .long 0     #a
.pos 0x2000
c          .long 0     #c
.pos 0x3000
b          .long 0     #b[0]
           .long 0     #b[1]
           .long 0     #b[2]
           .long 0     #b[3]

.pos 0x4000
d          .long 0     #d[0]
           .long 0     #d[1]
           .long 0     #d[2]
           .long 0     #d[3]
           .long 0     #d[4]
           .long 0     #d[5]
           .long 0     #d[6]
           .long 0     #d[7]

#e3
ld $d, r0       #r0 = &d
ld 0(r0), r1    #r1= value of d

# ...~c[(d+2) & 3]
ld $2, r2       #r2= 2
add r1, r2      #r2= d+2
ld $3, r3       #r3=3
and r3, r2      #r2=(d+2) & 3
ld $c, r3       #r3= c
ld (r3, r2, 4), r2   # r2=c[(d+2) & 3]
not r2               #~c[(d+2) & 3]

#..a[d & 3] & b[(d+1) & 3])..

ld $1, r3        #r3=1
add r1, r3       #r3=d+1
ld $3, r4        #r4= 3
and r4, r3       #r3=(d+1) & 3
ld $b, r4        #r4= b
ld (r4, r3,4), r3   #r3=b[(d+1) & 3]
ld $3, r4         #r4=3
and r1, r4        #r4=d & 3
ld $a, r5         #r5=a
ld



.pos 0x1000
d           .long 0    #d

.pos 0x2000
a          .long 0     #a[0]
           .long 0     #a[1]
           .long 0     #a[2]
           .long 0     #a[3]

.pos 0x3000
b          .long 0     #b[0]
           .long 0     #b[1]
           .long 0     #b[2]
           .long 0     #b[3]

.pos 0x4000
c          .long 0     #c[0]
           .long 0     #c[1]
           .long 0     #c[2]
           .long 0     #c[3]

















