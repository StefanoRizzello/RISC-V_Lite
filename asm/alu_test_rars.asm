	li a0,231	#a
	li a1,112	#b
	li a2,0		#srai
	li a3,0		#add
	li a4,0		#xor
	li a5,0		#andi
	li a6,0		#slt

	srai a2,a0,4	#srai = a >> 4
	slt a6,a2,a1	#if (srai < b)
	beq a6,zero,.L1	#
	addi a0,a0,500	#a += 500
.L1:
	andi a5,a0,0x304	#andi = a & 0x304
	xor a4,a0,a1		#exor = a ^ b
	add a3,a5,a4		#add = andi + exor