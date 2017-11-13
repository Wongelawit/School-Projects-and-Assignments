

.pos 0x100

ld $array, r0      # r0=array
ld (r0), r1        # r1= array[0]
ld 4(r1), r2       # r2= array[1]
ld $t ,   r3       # r3= & t
ld (r3), r3        # r3= value of t
st r1, r4          # t = array[0]
st r2, r5         # array[0] = array[1];
st r3, r2






.pos 0x21000
t:             .long 0xffffffff      #t

.pos 0x2000
array:         .long 0xffffffff       #array[0]
               .long 0xffffffff       #array[1]
