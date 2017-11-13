#
# This is the solution to CPSC 213 Assignment 4.
# Do not distribute this code or any portion of it to anyone in any manner.
# Do not remove this comment.
#

# struct S {
#   int       x[2];
#   int*      y;
#   struct S* z;
# };
#
# int      i;
# int      v0, v1, v2, v3;
# struct S s;

#void foo () {
#    v0 = s.x[i];
#    v1 = s.y[i];
#    v2 = s.z->x[i];
#    v3 = s.z->z->y[i];
#}

#    v0 = s.x[i];

ld $i, r0           #r0 = &i
ld (r0), r1         #r1= value of i
ld $s, r2           #r2 = &s
ld (r2, r1, 4), r4  #r4= s.x[i]
ld $v0, r2          #r2= v0
st r4, (r2)         #v0= s.x[i];

#    v1 = s.y[i];
ld 8(r1), r3               #r3= s.y
ld (r3, r0,4), r4          #r1= s.y[i]
ld $v1, r2                 #r2= v0
st r4, (r2)                #v0= s.x[i];

#    v2 = s.z->x[i];
ld 12(r1), r3               #r3= s.z
ld (r3, r0,4), r4          #r1= s.y[i]
ld $v2, r2                 #r2= v0
st r4, (r2)                # v2 = s.z->x[i]

#    v3 = s.z->z->y[i];

ld 12(r1), r3              # r3 = s.z
ld 12(r3), r3              # r3 = s.z->z
ld 8(r3),  r3              # r3 = s.z->z->y
ld (r3,r0, 4), r4          # r4 = s.z->z->y[i]
ld $v3, r2                 # r2= v3
st r4, (r2)                # v3 = s.z->z->y[i]
halt









.pos 0x2000
static:
i:      .long 0
v0:     .long 0
v1:     .long 0
v2:     .long 0
v3:     .long 0
s:      .long 0         # s.x[0]
        .long 0         # s.x[1]
        .long s_y       # s.y
        .long s_z       # s.z

.pos 0x3000
heap:
s_z:     .long 0
         .long 0
         .long s_z_y
         .long s_z_z
s_z_z:   .long 0
         .long 0
         .long s_z_z_y
         .long 0
s_y:     .long 0
         .long 0
s_z_y:   .long 0
         .long 0
s_z_z_y: .long 0
         .long 0
