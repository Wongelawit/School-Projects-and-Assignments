.pos 0x100
#b= a+5
ld $a, r0     #r0=&a
ld (r0),r1    #r1=value of a
ld $b, r0     #r0=&b
ld $5, r3     #r3=5
add r3, r1    #r1=a+5
st r1, r0   #r0= b= a+5

#c[0]=~(a+c[b])

ld $a, r1    #r1=&a
ld (r1), r2  #r2=r1= value of a
ld $c, r1    #r1= &c
st (r1, r0, 4), r1  # r1= c[b]









.pos 0x1000
a:    long 0x0
.pos 0x2000
b:    long 0x1
.pos 0x3000
c:    long 0x2
      long 0x3
      long 0x4
      long 0x5
