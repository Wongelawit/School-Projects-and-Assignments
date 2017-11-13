.pos 0x100
start:
ld $sb, r5              # initialize stack
inca    r5              # inca the stack pointer for saving the wasted 4-bytes
gpc $6, r6              # return address = PC + 6
j main                  # call main()
halt                    # end

copy:
deca r5                 # r5 -= 4, allocate for local var dst[0]
deca r5                 # r5 -= 4, allocate for local var dst[1]
ld $0, r1				# i = r1 = 0
ld $src, r2				# r2 = &src

copy_loop:
ld (r2, r1, 4), r3 		# r3 = src[i]
beq r3, copy_endLoop	# if (src[i] == 0) goto copy_endLoop
st r3, (r5, r1, 4)		# dst[i] = src[i];
inc r1					# i++;
br copy_loop 			# goto copy_loop
copy_endLoop:
ld $0, r0				# r0 = 0
st r0, (r5, r1, 4)		# dst[i] = 0;
inca r5					# r5 += 4, free local var dst[0]
inca r5 				# r5 += 4, free local var dst[1]
j (r6)					# return

main:
deca r5                 # r5 -= 4, allocate for ra
st r6, (r5)             # ra = r6
gpc $6, r6              # r6 = PC + 6
j copy                  # call copy()
ld (r5), r6             # r6 = ra
inca r5                 # r5 += 4, free ra
j (r6)                  # return

.pos 0x2000
src:
.long 1
.long 1
.long 0x200e			# attack code address
.long 0x00000000		# end the copy sequence; ld $-1, r0
.long 0xffffffff		# (continue) ld $-1, r0
.long 0x60016002		# mov r0, r1; mov r0, r2
.long 0x60036004		# mov r0, r3; mov r0, r4
.long 0x60056006		# mov r0, r5; mov r0, r6
.long 0x6007f000		# mov r0, r7; halt

.pos 0x8000
# These are here so you can see (some of) the stack contents.
.long 0					# dst[0] @ copy
.long 0					# dst[1] @ copy
sb: .long 0					# ra @ main
