	.file	"alu_test.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	li	a5,231
	sw	a5,-20(s0)
	li	a5,112
	sw	a5,-24(s0)
	sw	zero,-28(s0)
	sw	zero,-32(s0)
	sw	zero,-36(s0)
	sw	zero,-40(s0)
	lw	a5,-20(s0)
	srai	a5,a5,4
	sw	a5,-28(s0)
	lw	a4,-28(s0)
	lw	a5,-24(s0)
	slt	a7,a4,a5
	beq	a7,zero,.L2
	lw	a5,-20(s0)
	addi	a5,a5,500
	sw	a5,-20(s0)
.L2:
	lw	a5,-20(s0)
	andi	a5,a5,772
	sw	a5,-40(s0)
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	xor	a5,a4,a5
	sw	a5,-36(s0)
	lw	a4,-40(s0)
	lw	a5,-36(s0)
	add	a5,a4,a5
	sw	a5,-32(s0)
	li	a5,0
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
