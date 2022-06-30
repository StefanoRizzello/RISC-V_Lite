	.file	"helloworld.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	2
.LC0:
	.string	"lleHoW o!dlr"
	.zero	7
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	a2,0(a5)
	lw	a3,4(a5)
	lw	a4,8(a5)
	sw	a2,-36(s0)
	sw	a3,-32(s0)
	sw	a4,-28(s0)
	lw	a5,12(a5)
	sb	a5,-24(s0)
	sb	zero,-23(s0)
	sb	zero,-22(s0)
	sb	zero,-21(s0)
	sb	zero,-20(s0)
	sb	zero,-19(s0)
	sb	zero,-18(s0)
	sb	zero,-17(s0)
	li	a5,0
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
