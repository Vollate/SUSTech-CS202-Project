.data
   ans:    .word  0xfffffc60
   st1: .word 0xfffffc70
   clktime: .word 0x04000000#2s
    clktime1: .word 0x14000000
.text 
main :
	lui $7, 0xffff
	ori $7, $7, 0xfc60 

	lui $8, 0x0100
	add $t8, $8, $0
	lui $9, 0x4400
	add $s6, $9, $0
	
	
	loopmain:
	
	
	lui $t0, 0xffff
	ori $t0, $t0, 0xfc70
	
	#²âÊÔÑùÀý
	lui $t1, 0x000d
	ori $t1, $t1, 0x8282
	sw $t1, 0($t0)
	#²âÊÔÑùÀý
	
	lw $s3, 0($t0)
	srl $s3, $s3, 16
	
	add $8, $0, $0
	add $31, $0,$0

	addi $t0, $zero, 8
	beq $19, $t0, testpre0
	
	addi $t0, $zero, 9
	beq $19, $t0, testpre1
	
	addi $t0, $zero, 10
	beq $19, $t0, testpre2
	
	addi $t0, $zero, 11
	beq $19, $t0, testpre3
	
	addi $t0, $zero, 12
	beq $19, $t0, testpre4
	
	addi $t0, $zero, 13
	beq $19, $t0, testpre5
	
	addi $t0, $zero, 14
	beq $19, $t0, testpre6
	
	addi $t0, $zero, 15
	beq $19, $t0, testpre7
	j exitall
	
	testpre0:jal test0
	j exitall
	testpre1:jal test1
	j exitall
	testpre2:jal test2
	j exitall
	testpre3:jal test3
	j exitall
	testpre4:jal test4
	j exitall
	testpre5:jal test5
	j exitall
	testpre6:jal test6
	j exitall
	testpre7:jal test7
	j exitall
	
	exitall:
	add $t0, $zero, $zero
	
	looptime:addi $t0, $t0,1
	add $t0, $t0, $zero
	slt $t1, $t8, $t0
	beq $t1, $zero, looptime
	add $t0, $zero,$zero
	add $t1, $zero,$zero
	
	#²âÊÔ½á¹û
	lw $t1, 0($a3)
	lui $t0, 0xffff
	sw $t1, 0($t0)
	#²âÊÔ½á¹û
	
	
	j loopmain
	
	
	
	
	
	
	
	test0:
	lui $t0, 0xffff
	ori $t0, $t0, 0xfc70
   	lw $s0, 0($t0)
   	
   	srl $t2, $s0, 16
   	sll $t2, $t2, 16
   	sub $s0, $s0, $t2
   	
   	lui $7, 0xffff
	ori $7, $7, 0xfc60 
   	
   	
   	addi $s1, $s0, -1
   	and $s2, $s0, $s1
   	beq $s2, $zero,jump1
   	add $s1,$zero,$zero 
   	j exit1
   	jump1: addi $s1,$zero,1
   	
   	exit1: sll $s1, $s1, 16
   	add $s0, $s1, $s0
   	sw $s0, 0($a3)
   	j exitall
   	
   	    
   	
   	test1:
   	lui $t0, 0xffff
	ori $t0, $t0, 0xfc70
   	lw $s0, 0($t0)  
   	
   	srl $t2, $s0, 16
   	sll $t2, $t2, 16
   	sub $s0, $s0, $t2
   	
   	srl $t2, $s0, 1
   	sll $t2, $t2, 1
   	sub $s1, $s0, $t2
   	
   	lui $7, 0xffff
	ori $7, $7, 0xfc60     
   	
   	sll $s1, $s1, 16
   	add $s0, $s1, $s0
   	sw $s0, 0($a3)
   	j exitall
   	
   	
   	test2:
   	jal test7
   	sw $zero, 0($a3)
   	or $t1, $s1, $s0
   	sw $t1,0($a3)
   	
   	
   	j exitall
   	
   	test3:
   	jal test7
   	sw $zero, 0($a3)
   	nor $t1, $s1, $s0
   	srl $t2, $t1, 8
   	sll $t2, $t2, 8
   	sub $t1, $t1, $t2
   	
   	
   	sw $t1,0($a3)
   	
   	j exitall
   	
   	test4:
   	jal test7
   	nor $t1, $s1,$s1
   	nor $t0, $s0,$s0
   	and $s2, $t0,$s1
   	and $s3, $t1,$s0
   	or $s0, $s2, $s3
   	
   	srl $t2, $s0, 8
   	sll $t2, $t2, 8
   	sub $s0, $s0, $t2
   	
   	sw $s0, 0($a3)
   	j exitall
   	
   	test5:
   	jal test7
   	srl $t0, $s0, 7
   	srl $t1, $s1, 7
   	add $t3, $zero, $zero
   	beq $s0, $s1, okey
   	beq $t0, $t1, exitforequal
   	beq $t0, $zero,zerobig
   	addi $t3, $zero, 1
   	j okey
   	zerobig:add $t3, $zero,$zero
   	j okey
   	exitforequal:slt $t3, $s0, $s1
   	beq $t0, $zero, okey
   	nor $t3, $t3, $zero
   	srl $t0, $t3, 1
   	sll $t0, $t0, 1
   	sub $t3, $t3, $t0
   	okey: 
   	
   	sw $t3, 0($a3)
   	j exitall
   	
   	test6:
   	jal test7
   	slt $t2, $s0, $s1
   	
   	sw $t2, 0($a3)
   	
   	j exitall
   	
  
   	
   	
   	test7:
   	add $t2, $zero, $t8
   	lui $t0, 0xffff
	ori $t0, $t0, 0xfc70
   	lw $t0, 0($t0)
   	
   	srl $t1, $t0, 16
   	sll $t1, $t1, 16
   	sub $t0, $t0, $t1
   	
   	srl $s1, $t0, 8
   	sll $t1, $s1, 8
   	sub $s0, $t0, $t1
   	
   	sll $t1, $s1, 8
   	add $s3, $t1, $s0
   	
   	lui $t0, 0xffff
	ori $t0, $t0, 0xfc60
	sw $s3, 0($t0)
   	
	add $t0, $zero, $zero
	
	looptime1:addi $t0, $t0,1
	add $t0, $t0, $zero
	slt $t1, $t8, $t0
	beq $t1, $zero, looptime1
	add $t0, $zero,$zero
	add $t1, $zero,$zero

   	jr $ra 
   	j exitall
   	
   	
   	
   	
   	
   	
   	
   	
   	
   	
   	
   	
   	
