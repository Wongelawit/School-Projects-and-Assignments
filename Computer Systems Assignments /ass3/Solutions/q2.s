.pos 0x100

# STATEMENT1: tmp = 0; tos = 0; s[tos] = a[0]; tos++;
ld $0, r0     # r0=0
ld $tmp, r1  # r1= address temp
st r0, 0(r1)  # temp = 0
ld $tos, r1   # r1 = address of tos
st r0, 0(r1)  # tos = 0
ld $a, r2     # r2 = address of a
ld 0(r2), r2  # r2 = a[0]
ld $s, r0     # r0 = &s
ld 0(r1), r1  # r1 = tos
st r2, (r0, r1, 4) # s[tos] = a[0];
inc r1        # r1 = tos++
ld $tos, r0   # r0 = &tos
st r1, 0(r0)  # tos++

# STATEMENT1: s[tos] = a[1];  tos++;

ld $1, r0           #r0= 1
ld $a, r1           #r1= &a
ld (r1, r0, 4), r1  # r1= value a[1]
ld $s, r0           # r0= &s
ld $tos, r2         #r2= &tos
ld 0(r2), r2        #r2= value tos
st r1, (r0, r2, 4)  # s[tos] = a[1];
inc r2              # r2 = tos++
ld $tos, r0         # r0 = &tos
st r2, 0(r0)        # r0=tos++

# STATEMENT1:    s[tos] = a[2]; tos++; tos--;

ld $2, r0           #r0= 1
ld $a, r1           #r1= &a
ld (r1, r0, 4), r1  # r1= value a[2]
ld $s, r0           # r0= &s
ld $tos, r2         #r2= &tos
ld 0(r2), r2        #r2= value tos
st r1, (r0, r2, 4)  # s[tos] = a[1];
inc r2              # r2 = value of tos++
ld $tos, r0         # r0 = &tos
st r2, 0(r0)        # tos++
ld 0(r0), r0        # r0= value of toss
dec r0              # r0= tos--
ld $tos, r1         # r1= & tos
st r0, 0(r1)        # r1=  tos--

# STATEMENT1: tmp = s[tos]; tos--;

ld $s, r0            # r0= &s
ld $tos, r1          # r1= &tos
ld 0(r1), r1         # r1= value tos
ld(r0,r1, 4), r0     # r0= s[tos]
ld $tmp, r1          # r0=& tem
st r0, 0(r1)         # tmp = s[tos];
ld $tos, r0          #r1= &tos
ld 0(r0), r0         # r1= value tos
dec r0               # tos--
ld $tos, r1          # r1= & tos
st r0, 0(r1)         #   tos--


# STATEMENT1: tmp = tmp + s[tos]; tos--;
ld $s, r0            # r0= &s
ld $tos, r1          # r1= &tos
ld 0(r1), r1         # r1= value of tos
ld (r0, r1, 4), r0   # r0= s[tos];
ld $tmp, r1          # r1= &tmp
ld 0(r1), r2         # r2= value tmp
add r2, r0           # r2= tmp + s[tos]
st r0, 0(r1)         # tos = tos - 1

ld $tos, r0          # r0= & tos
ld 0(r0), r0         # r0= value of tos
dec r0               # r0= tos--
ld $tos, r1          # r1= & tos
st r0, 0(r1)         # r0= t0s--


# STATEMENT1: tmp = tmp + s[tos];
ld $s, r0            #r0= &s
ld $tos, r1          #r1= &tos
ld 0(r1), r1         # =r1= value of tos
ld(r0, r1, 4), r0    # r0= s[tos]
ld $tmp, r1          # r1= tmp
ld 0(r1), r2         # r2= value of tmp
add r2, r0           # r2= tmp + s[tos]
st r0, 0(r1)        # tmp = tmp + s[tos];

halt


















.pos 0x1000
tos:           .long 0x0      #tos

.pos 0x2000
tmp:           .long 0x0      #tmp

.pos 0x3000
a:             .long 0x1      # a[0]
               .long 0x2	  # a[1]
               .long 0x3	  # a[2]

.pos 0x4000
s:             .long 0x4      # s[0]
               .long 0x5	  # s[1]
               .long 0x6	  # s[2]
               .long 0x7	  # s[3]
               .long 0x8	  # s[4]



