	.file	"helloworld.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	li	a5,1214607360
	addi	a5,a5,-916
	sw	a5,-28(s0)
	li	a5,1864388608
	addi	a5,a5,1903
	sw	a5,-24(s0)
	li	a5,1919705088
	addi	a5,a5,1057
	sw	a5,-20(s0)
	li	a5,0
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
