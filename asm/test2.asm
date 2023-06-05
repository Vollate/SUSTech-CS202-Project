.data 
.text
pre_code:
	addi $27,$ra,0

begin:
	lw $s3, 0x10($27)
	srl $s3, $s3, 16
   	
	addi $t0, $0, 8
	beq $19, $t0, testpre0
	
	addi $t0, $0, 9
	beq $19, $t0, testpre1
	
	addi $t0, $0, 10
	beq $19, $t0, testpre2
	
	addi $t0, $0, 11
	beq $19, $t0, testpre3
	
	addi $t0, $0, 12
	beq $19, $t0, testpre4
	
	addi $t0, $0, 13
	beq $19, $t0, testpre5
	
	addi $t0, $0, 14
	beq $19, $t0, testpre6
	
	addi $t0, $0, 15
	beq $19, $t0, testpre7

	j exitall


testpre0:
	lw $a3,0x10($27)
	sll $a3,$a3,24
	srl $a3,$a3,24
	srl $t0,$a3,7
	bne $t0,$0,twinkle
	jal fun0
	sw $v0,0($27)
	j exitall

fun0:
	bne $a3,$0,curs0
	addi $v0,$0,0
	jr $ra
curs0:
	addi $sp,$sp,-8
	sw $a3,0($sp)
	sw $ra,4($sp)
	addi $a3,$a3,-1
	jal fun0
	lw $ra,4($sp)
	lw $a3,0($sp)
	addi $sp,$sp,8
	add $v0,$v0,$a3
	jr $ra
twinkle:
	lui $t1,0x6E			
	ori $t1,$t1,0xF2C0
	addi $t2,$0,165
	sll $t2,$t2,8
	addi $t2,$t2,165
	sll $t2,$t2,8
	addi $t2,$t2,165
	addi $t3,$0,0
	addi $t4,$0,5

	loop00:
	addi $t0,$0,0
	beq $t3,$t4,do_pre_exit1
	addi $t3,$t3,1

	loop01:
	beq $t0,$t1,timeup0
	addi $t0,$t0,1
	j loop01

	timeup0:
	sw $t2,0($27)
	nor $t2,$t2,$0
	j loop00

	do_pre_exit1:
	sw $0,0($27)
	j exitall
	

testpre1:
	lw $a3,0x10($27)
	sll $a3,$a3,24
	srl $a3,$a3,24
	addi $t0,$0,0
	jal fun1
	sw $t0,0($27)
	j begin

fun1:	
	bne $a3,$0,curs1
	addi $v0,$0,0
	jr $ra

curs1:
	addi $sp,$sp,-8
	sw $a3,0($sp)
	sw $ra,4($sp)
	addi $t0,$t0,1
	addi $a3,$a3,-1
	jal fun1
	lw $a3,0($sp)
	lw $ra,4($sp)
	addi $t0,$t0,1
	addi $sp,$sp,8
	add $v0,$v0,$a3
	jr $ra
j exitall

testpre2:
	lw $a3,0x10($27)
	sll $a3,$a3,24
	srl $a3,$a3,24
	jal fun2
	sw $v0,0($27)
	j exitall

fun2:	
	bne $a3,$0,curs2
	addi $v0,$0,0
	jr $ra

curs2:
	addi $sp,$sp,-8
	sw $a3,0($sp)
	sw $ra,4($sp)
	sw $a3,0($27)
	lui $t1,0x10E			
	ori $t1,$t1,0xF3C0
	addi $t0,$0,0

	loop3:
	beq $t0,$t1,exit1_3
	addi $t0,$t0,1
	j loop3

	exit1_3:
	addi $a3,$a3,-1
	jal fun2
	lw $a3,0($sp)
	lw $ra,4($sp)
	addi $sp,$sp,8
	add $v0,$v0,$a3
	jr $ra

	j exitall

testpre3:
	lw $a3,0x10($27)
	sll $a3,$a3,24
	srl $a3,$a3,24
	jal fun3
	sw $v0,0($27)
	j exitall

fun3:	
	bne $a3,$0,curs3
	addi $v0,$0,0
	jr $ra

curs3:
	addi $sp,$sp,-8
	sw $a3,0($sp)
	sw $ra,4($sp)
	addi $a3,$a3,-1
	jal fun3
	lw $a3,0($sp)
	lw $ra,4($sp)
	sw $a3,0($27)
	lui $t1,0x10E			
        ori $t1,$t1,0xF3C0
        addi $t0,$0,0

	loop30:
	beq $t0,$t1,exit1_4
	addi $t0,$t0,1
	j loop30

	exit1_4:
	addi $sp,$sp,8
	add $v0,$v0,$a3
	jr $ra

	j exitall

testpre4:
	jal input

   	srl $t0, $s0, 7# a的符号位
   	srl $t1, $s1, 7# b的符号位
   	
   	beq $t0, $t1, same1#判断是否为同号
   	
   	add $s0, $s0, $s1#异号直接相加，
   	add $t3,$0,$0#不会溢出
   	sll $t3, $t3, 16
   	add $s0, $t3, $s0
   	j right
   	
   	same1:beq $t0, $0, positive4#判断此处两个都为正
   	
	addi $s1, $s1,-1
	addi $s0, $s0,-1 
   	nor $s1, $s1, $0#为负就都取补码
   	nor $s0, $s0, $0
   	
   	srl $t3, $s0, 8
   	sll $t3, $t3, 8
   	sub $s0, $s0, $t3# 防止高位取反
   	srl $t3, $s1, 8
   	sll $t3, $t3, 8
   	sub $s1, $s1, $t3
   	
   	
   	positive4:
   	add $s0, $s0, $s1
   	srl $t2, $s0, 7# $t3用于判断是否溢出
   	
   	srl $t3, $s0, 7
   	sll $t3, $t3, 7
   	sub $s0, $s0, $t3#去掉最高位
   	
   	beq $t0, $0, posians
   	nor $s0, $s0, $0
	addi $s0, $s0,1
   	srl $t3, $s0, 8
   	sll $t3, $t3, 8
   	sub $s0, $s0, $t3# 防止高位取反
   	
   	
   	posians:
   	sll $t2, $t2, 16
   	add $s0, $s0, $t2
   	 
   	right:
   	# srl $t3, $s0, 16
   	# sll $t3, $s0, 16
   	# sub $s0, $s0, $t3
   	# addi $t0, $0, 0xff
   	# bne $s0, $t0, re0
   	# add $s0, $0, $0
   	# re0:
   	# add $s0, $s0, $t3
   	sw $s0,0($27)
   	j exitall

testpre5:
   	jal input
   	srl $t0, $s0, 7#a 符号位
   	srl $t1, $s1, 7#b 符号位
   	beq $t0, $t1, same2 #判断是否同号
   	
   	beq $t0, $0, case2 #判断被减数是否为正
   	addi $s0, $s0, -1
	nor $s0, $0,$s0 #被减数是负数
   	
   	srl $t3, $s0, 8
   	sll $t3, $t3, 8
   	sub $s0, $s0, $t3# 防止高位取反
   	
   	add $s0, $s1, $s0
   	srl $t2, $s0, 7# t2判断溢出
   	sll $t3, $t2, 7
   	sub $s0, $s0, $t3#删除符号位
   	

   	nor $s0, $s0, $0
	addi $s0, $s0, 1
   	srl $t3, $s0, 8
   	sll $t3, $t3, 8
   	sub $s0, $s0, $t3# 防止高位取反
   	sll $t2, $t2, 16
   	add $s0, $t2, $s0
   	j endcase
   	
   	case2:
	addi $s1, $s1, -1
   	nor $s1, $0,$s1 #减数是负数
   	
   	srl $t3, $s1, 8
   	sll $t3, $t3, 8
   	sub $s1, $s1, $t3# 防止高位取反
   	
   	add $s0, $s1, $s0
   	srl $t2, $s0, 7# t2判断溢出
   	sll $t3, $t2, 7
   	sub $s0, $s0, $t3#删除符号位
   	
   	sll $t2, $t2, 16
   	add $s0, $t2, $s0
   	j endcase
   	
   	same2:#符号相同
   	slt $t4, $s0, $s1
   	beq $t4, $0, posicase
   	
   	sub $s0, $s1, $s0
   	nor $s0, $s0, $0
	addi $s0, $s0, 1
   	srl $t3, $s0, 8
   	sll $t3, $t3, 8
   	sub $s0, $s0, $t3# 防止高位取反
   	j endcase
   	
   	posicase:
   	sub $s0, $s0, $s1
   	
   	endcase:
   	# srl $t3, $s0, 16
   	# sll $t3, $t0, 16
   	# sub $s0, $s0, $t3
   	# addi $t0, $0, 0xff
   	# bne $s0, $t0, re01
   	# add $s0, $0, $0
   	# re01:
   	# add $s0, $s0, $t3
   	sw $s0, 0($27)
   	j exitall

testpre6:
   	jal input
   	srl $t0, $s0, 7#a 符号位
   	srl $t1, $s1, 7#b 符号位
   	beq $t0, $0, exita#判断a是否为负
   	
	addi $s0, $s0,-1
   	nor $s0, $s0, $0
   	srl $t3, $s0, 8
   	sll $t3, $t3, 8
   	sub $s0, $s0, $t3# 防止高位取反
   	
   	exita:
   	beq $t1, $0, exitb#判断b是否为负
   	
	addi $s1, $s1,-1
   	nor $s1, $s1, $0
   	srl $t3, $s1, 8
   	sll $t3, $t3, 8
   	sub $s1, $s1, $t3# 防止高位取反
   	
   	exitb:
   	beq $t0, $t1, po
   	addi $t5, $0, 1
   	j exitpo
   	po: add $t5, $0, $0#t0用于计算符号
   	exitpo:
   	
   	add $t2, $0, $0 #定义一个0
   	addi $t3, $0, 0xff #定义一个低八位都是1的数字
   	addi $t4, $0, 0x01 #定义一个取最后一位的数
   	add $s2, $0, $0 #初始化值
   	
   	and $t1, $t4, $s0
   	beq $t1, $0, spacemul
   	add $s2, $s2, $s1
   	spacemul:
   	
   	srl $s0, $s0, 1
   	and $t1, $t4, $s0
   	sll $s1, $s1, 1
	beq $t1, $0, spacemul1
   	add $s2, $s2, $s1
   	spacemul1:
   	
   	srl $s0, $s0, 1
   	and $t1, $t4, $s0
   	sll $s1, $s1, 1
	beq $t1, $0, spacemul2
   	add $s2, $s2, $s1
   	spacemul2:
   	
   	srl $s0, $s0, 1
   	and $t1, $t4, $s0
	sll $s1, $s1, 1
	beq $t1, $0, spacemul3
   	add $s2, $s2, $s1
   	spacemul3:
   	
   	srl $s0, $s0, 1
   	and $t1, $t4, $s0
   	sll $s1, $s1, 1
	beq $t1, $0, spacemul4
   	add $s2, $s2, $s1
   	spacemul4:
   	
   	srl $s0, $s0, 1
   	and $t1, $t4, $s0
   	sll $s1, $s1, 1
	beq $t1, $0, spacemul5
   	add $s2, $s2, $s1
   	spacemul5:
   	
   	srl $s0, $s0, 1
   	and $t1, $t4, $s0
   	sll $s1, $s1, 1
	beq $t1, $0, spacemul6
   	add $s2, $s2, $s1
   	spacemul6:
   	
   	srl $s0, $s0, 1
   	and $t1, $t4, $s0
   	sll $s1, $s1, 1
	beq $t1, $0, spacemul7
   	add $s2, $s2, $s1
   	spacemul7:
   	
   	beq $t5, $0, exitmul1
   	nor $s2, $s2, $0
	addi $s2, $s2, 1 
   	srl $t3, $s2, 16
   	sll $t3, $t3, 16
   	sub $s2, $s2, $t3# 防止高位取反
   	exitmul1:
   	sw $s2, 0($27)
   	
   	j exitall
   	
testpre7:
 	jal input
   	srl $t0, $s0, 7#a 符号位
   	srl $t1, $s1, 7#b 符号位
   	beq $s1, $0 ,wrong
   	
   	beq $t0, $0, exitdiv1
	addi $s0, $s0,-1
   	nor $s0, $s0, $0
   	srl $t3, $s0, 8
   	sll $t3, $t3, 8
   	sub $s0, $s0, $t3# 防止高位取反
   	exitdiv1:
   	
   	beq $t1, $0, exitdiv2
	addi $s1, $s1,-1
   	nor $s1, $s1, $0
   	srl $t3, $s1, 8
   	sll $t3, $t3, 8
   	sub $s1, $s1, $t3# 防止高位取反
   	exitdiv2:
   	
   	slt $t2, $s1, $s0
   	add $s4, $0, $0
   	beq $t2, $0, exitdivloop
   	add $s4, $0, $0#每次商加一
   	divloop:sub $s0, $s0, $s1
   	addi $s4, $s4, 1
   	slt $t2, $s0, $s1
   	beq $t2, $0, divloop
   	exitdivloop:
   	
   	
   	beq $t0, $t1, divcase1
   	nor $s4, $s4, $0
	addi $s4, $s4, 1
   	srl $t3, $s4, 8
   	sll $t3, $t3, 8
   	sub $s4, $s4, $t3# 防止高位取反
   	divcase1:
   	beq $t0, $0, divcase2
   	nor $s0, $s0, $0
	addi $s0, $s0,1
   	srl $t3, $s0, 8
   	sll $t3, $t3, 8
   	sub $s0, $s0, $t3# 防止高位取反
   	divcase2: 
   	
   	add $t0, $0, $0
   	addi $t3, $0, 1

   	loopshow:
	lui $t8,0x6F			
	ori $t8,$t8,0xF2C0

   	addi $t0, $t0, 1
   	
   	add $t1, $0, $0
   	
   	loopdiv1:sw $s4, 0($27)
   	addi $t1, $t1, 1
   	slt $t2, $t8, $t1
   	beq $t2, $0,loopdiv1
   	
   	add $t1, $0, $0
   	
   	loopdiv2:sw $s0, 0($27)
   	addi $t1, $t1, 1
   	slt $t2, $t8, $t1
   	beq $t2, $0,loopdiv2
   	
   	slt $t2, $t3, $t0
   	beq $t2,$0, loopshow
   	j exitall
   	
   	wrong:sw $0, 0($27)
   	j exitall

input:

   	lw $t0, 0x10($27)
   	
   	srl $t1, $t0, 16
   	sll $t1, $t1, 16
   	sub $t0, $t0, $t1
   	
   	srl $s1, $t0, 8#b s1
   	sll $t1, $s1, 8
   	sub $s0, $t0, $t1#a s0
   		
   	jr $ra 

exitall:
	j begin
