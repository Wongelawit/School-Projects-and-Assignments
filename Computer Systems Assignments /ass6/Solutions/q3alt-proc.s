## This is the solution to CPSC 213 Assignment 6
## Do not distribute any part of this file to anyone for any reason
## Do not remove this comment

## This alternate version uses procedures
## Also ... its from a slightly different formulation of the problem
## where the average was not stored in the struct (which made it more difficult)

.pos  0x100
swhilei:
	ld $i, r0    ## start of outer while
	ld (r0),r0   # load value of i
	ld $n, r2
	ld (r2),r2   # r2 = n
	not r2
	inc r2		# -n
	add r0,r2 	# i-n
	inc r2
	beq r2, ewhilei  ## while (i-n+1)
swhilej:
	ld $i, r0     ## start inner while 
	ld (r0), r0
	ld $j, r1
	ld (r1),r1
	ld $n, r2
	ld (r2),r2
	not r2
	inc r2		# -n
	add r0,r2 	# i-n
	inc r2		# i-n+1
	add r1,r2   	# j-n+i+1
	beq r2, ewhilej   ### while (j-n+1+i)
	ld $j, r0     # r0 = j   test base[j] and base[j+1]
	ld (r0),r0     
	mov r0, r1
	inc r1        # r1 = j+1
	gpc $6, r6
	j getavg    # get average for j (r0 doesn't  change)
	mov r7, r3  # result in r7, AVE(base[j])
	not r3
	inc r3     # r3 = -AVE(base[j])
	inc r0     # r0 = j+1
	gpc $6, r6  ## get average for j+1
	j getavg
	add r3,r7   ## r7 = AVE(base[j+1])-AVE(base[j])
	bgt r7, noswap
	mov r0, r1
	dec r0
	gpc $6, r6    ## call swap on r0=j, r1=j+1
	j swap
noswap:	
	ld $j,r2        # increment j 
	ld (r2),r1
	inc r1
	st r1, (r2)     # j = j+1
	br swhilej      # end while_j
ewhilej:		
	ld $i,r2
	ld (r2),r0
	inc r0
	st r0, (r2)     # i=i+1
	ld $j, r2
	ld $0,r1
	st r1,(r2)      # j=0 
	br swhilei
ewhilei:
	ld $n,r0      ## outside while loops
	ld (r0),r0    ## r0 = n
	shr $1,r0     ## r0 = index of median @ n/2
	ld  $s,r1     
	ld  (r1),r1   ## r1 = *s (base)
	mov r0,r3     ## r3 = n
	shl $2,r3     ## r3 = 4*index 
        add r3,r1     ## r3 =5*index
	ld  (r1,r3,4), r7  ## r7 = median
	ld $m,r0
	st r7,(r0)   ## m = median
	halt
.pos 0x200
getavg:		# assumes index in r0, returns value in r7, uses r5,r1,r2  --- free is r3,r4
	ld $s, r5
	ld (r5),r5   # r5 = &base
	mov r0,r1
	shl $2,r1
	add r0,r1   
	inc r1       # r1 = 5*r0 + 1
	ld $0, r7    ## r7 = sum
	ld  (r5,r1,4), r2   #  r2 = grade 0
	add r2,r7
	inc r1
	ld  (r5,r1,4), r2   #  r2 = grade 1
	add r2,r7
	inc r1
	ld  (r5,r1,4), r2   #  r2 = grade 2
	add r2,r7
	inc r1
	ld  (r5,r1,4), r2   #  r2 = grade 3
	add r2,r7           # r2 = sum of four
	shr $2,r7
	j (r6)
.pos 0x300
swap:    ## assumes indices are in r0 and r1, destroy r0 and r1
	ld $s,r5
	ld (r5),r5
	mov r0,r2
	shl $2, r2
	add r0, r2   ## offset for first
	mov r1,r3
	shl $2, r3
	add r1, r3   ## offset for second
	ld $5, r7
start_swap:   ## does not use r4, assumes
	beq r7, end_swap
	ld (r5,r2,4), r0
	ld (r5,r3,4), r1
	st r0,(r5,r3,4) 
	st r1,(r5,r2,4)
	inc r3
	inc r2
	dec r7
	br start_swap
end_swap:
	j (r6)
.pos 0x400
i: 	.long 0
j: 	.long 0
.pos 0x1000
n:	.long 5   #just one student
m: 	.long 0   # result goes here
s:	.long base  # base of the array
base:   .long 1234   #student ID
	.long 80     #grade 0
	.long 80     #grade 1
	.long 80     #grade 2
	.long 80     #grade 3
	.long 1235   #student ID
	.long 70     #grade 0
	.long 70     #grade 1
	.long 70     #grade 2
	.long 70     #grade 3
	.long 1236   #student ID
	.long 50     #grade 0
	.long 50     #grade 1
	.long 50     #grade 2
	.long 50     #grade 3
	.long 1237   #student ID
	.long 30     #grade 0
	.long 30     #grade 1
	.long 30     #grade 2
	.long 30     #grade 3
	.long 1238   #student ID
	.long 90     #grade 0
	.long 90     #grade 1
	.long 90     #grade 2
	.long 90     #grade 3


