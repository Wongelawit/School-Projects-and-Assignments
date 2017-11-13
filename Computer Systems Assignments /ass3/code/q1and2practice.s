.pos 100

ld $i, r0       #r0= &i
ld $a, r1       #r1=&a

ld $3, r2       #r2=3
ld (r1,3,4),r2  #r2= a[3]
st r2, r0       #r0=a[3]






.pos 1000
i   .long 0             #i
.pos 2000
j   .long 0             #j
.pos 3000
p   .long 0             #p
.pos 4000
a   .long 0             #a[0]
    .long 0             # a[1]
    .long 0             # a[2]
    .long 0             # a[3]
    .long 0             # a[4]
    .long 0             # a[5]
    .long 0             # a[6]
    .long 0             # a[7]
    .long 0             # a[8]
    .long 0             # a[9]
