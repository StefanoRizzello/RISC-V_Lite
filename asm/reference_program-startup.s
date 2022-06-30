#################
# Basic VERSION	
# This program takes an array v and computes
# min{|v[i]|}, the minimum of the absolute value,
# where v[i] is the i-th element in the array
	.data
	.align	2
v:
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
m:
	.word 0
	
	.text
	.align	2
	.globl	__start
__start:
	li x16,7          # put 7 in x16 
	la x4,v           # put in x4 the address of v
	la x5,m           # put in x5 the address of m
	li x13,0x3fffffff # init x13 with max pos
	
	# Store data 1
	li x20, 10
	sw x20, 0(x4)
	addi x4, x4, 0x4
	# Store data 2 
	li x20, -47
	sw x20, 0(x4)
	addi x4, x4, 0x4
	# Store data 3
	li x20, 22
	sw x20, 0(x4)
	addi x4, x4, 0x4
	# Store data 4
	li x20, -3
	sw x20, 0(x4)
	addi x4, x4, 0x4
	# Store data 5
	li x20, 15
	sw x20, 0(x4)
	addi x4, x4, 0x4
	# Store data 6
	li x20, 27
	sw x20, 0(x4)
	addi x4, x4, 0x4
	# Store data 7
	li x20, -4
	sw x20, 0(x4)
	# Store 0 in m
	sw x0, 0(x5)

	la x4, v
loop:	
	beq x16,x0,done   # check all elements have been tested
	lw x8,0(x4)       # load new element in x8
	srai x9,x8,31     # apply shift to get sign mask in x9
	xor x10,x8,x9     # x10 = sign(x8)^x8
	andi x9,x9,0x1    # x9 &= 0x1 (carry in)
	add x10,x10,x9    # x10 += x9 (add the carry in)
	addi x4,x4,0x4	  # point to next element
	addi x16,x16,-1   # decrease x16 by 1
	slt x11,x10,x13   # x11 = (x10 < x13) ? 1 : 0
	beq x11,x0,loop   # next element
	add x13,x10,x0    # update min
	jal loop          # next element
done:	
	sw x13,0(x5)      # store the result	
#endc:	
#	jal endc  	  # infinite loop
#	addi x0,x0,0
	
