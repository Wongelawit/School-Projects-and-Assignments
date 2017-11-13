.pos 0x100
start:
ld $sb, r5              # initialize stack
inca    r5              # inca the stack pointer for saving the wasted 4-bytes
gpc $6, r6              # return address = PC + 6
j main                  # call main()
halt                    # end

f:
deca r5                 # r5 -= 4, allocate for local var couter
ld $0, r0               # counter = r0 = 0
ld 4(r5), r1            # r1 = 4(r5) = a1
ld $0x80000000, r2      # r2 = 0x80000000
f_loop:
beq r1, f_end           # if (a1 == 0) goto f_end
mov r1, r3              # temp_a1 = r3 = a1
and r2, r3              # temp_a1 = r2 & temp_a1
beq r3, f_if1           # if (temp_a1 == 0) goto f_if1
inc r0                  # counter++
f_if1:
shl $1, r1              # a1 = a1 << 1
br f_loop               # goto f_loop
f_end:
inca r5                 # r5 += 4
j(r6)                   # return counter

main:
deca r5                 # r5 -= 4, allocate for ra
deca r5                 # r5 -= 4, allocate for local var i
st r6, 4(r5)            # ra = 4(r5) = r6
ld $8, r4               # i = r4 = 8
main_loop:
beq r4, main_end        # if (i == 0) goto main_end
dec r4                  # i--
ld $x, r0               # r0 = &x
ld (r0,r4,4), r0        # r0 = x[i]
deca r5                 # r5 -= 4, allocate for argument a1 in f's frame
st r0, (r5)             # a1 = 0(r5) = x[i]
gpc $6, r6              # r6 = PC + 6
j f                     # call f(a1)
inca r5                 # r5 += 4, free argument a1 from f's frame
ld $y, r1               # r1 = &y
st r0, (r1,r4,4)        # y[i] = return from f(a1)
br main_loop            # goto main_loop
main_end:
ld 4(r5), r6            # r6 = ra
inca r5                 # r5 += 4, free local var i
inca r5                 # r5 += 4, free ra
j (r6)                  # return

.pos 0x2000
x:
.long 1
.long 2
.long 3
.long 0xffffffff
.long 0xfffffffe
.long 0
.long 184
.long 340057058

y:
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0
.long 0

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

