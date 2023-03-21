# Torres de Hanoi 
# Guilherme Specht, Diogo Diogenes e Eduardo Balzan
# Trabalho 2 de Organização e Arquitetura de Processadores

.data
prompt: .asciiz "Insira o número de discos: "
part1: .asciiz "\nMove o disco "
part2: .asciiz " da posição "
part3: .asciiz " para a posição "
 
.text
.globl main
main:
    li $v0,  4         		# imprime a string armazenada em prompt
    la $a0,  prompt		# "Insira o número de discos: "
    syscall			# imprime a mensagem no console 
    li $v0,  5         	 	# le o numero de discos
    syscall			# imprime a mensagem no console 
 
    # passagem de parametros da função
    add $a0, $v0, $zero 	# passa o numero de discos para $a0
    li $a1, 'A' 		# recebe a posição A (65 em ASCII), inicio 
    li $a2, 'B' 		# recebe a posição B (66 em ASCII), auxiliar
    li $a3, 'C' 		# recebe a posição C (67 em ASCII), fim
 
    jal hanoi_t           	# pula para a função hanoi_t
 
    li $v0, 10          	# fim do programa
    syscall
 
hanoi_t:
 
    #salva na pilha os argumentos da função
    addi $sp, $sp, -20 		# aloca 20 bytes na pilha
    sw   $ra, 0($sp)		# guarda os argumentos na pilha
    sw   $s0, 4($sp) 		# numero de discos
    sw   $s1, 8($sp) 		# inicio
    sw   $s2, 12($sp) 		# auxiliar
    sw   $s3, 16($sp) 		# fim
 
    add $s0, $a0, $zero 	# passa o numero de discos para $s0
    add $s1, $a1, $zero 	# A -> $s1
    add $s2, $a2, $zero 	# B -> $s2
    add $s3, $a3, $zero 	# C -> $s3
 
    addi $t1, $zero, 1 		# $t1 = 1
    beq $s0, $t1, output 	# analisa se o numero de discos = 1 ($s0 = $t1), se for pula para a função output
 
    recur1:
 
        addi $a0, $s0, -1 	# decrementa o numero de discos
        add $a1, $s1, $zero 	# $a1 = A
        add $a2, $s3, $zero 	# $a2 = C
        add $a3, $s2, $zero 	# $a3 = B
        jal hanoi_t 		# pula para a função hanoi
 
        j output 		# pula para o output
 
    recur2:
 
        addi $a0, $s0, -1	# decrementa o numero de discos
        add $a1, $s3, $zero	# posição armazenada em $s3 vai para $a1
        add $a2, $s2, $zero	# posição armazenada em $s2 vai para $a2
        add $a3, $s1, $zero	# posição armazenada em $s1 vai para $a3
        jal hanoi_t		# pula para a função hanoi_t
 
    exithanoi:
 
        lw   $ra, 0($sp)        # restora os registradores da pilha
        lw   $s0, 4($sp)	# numero que indica o tamanho do disco
        lw   $s1, 8($sp)	# $s1 = A
        lw   $s2, 12($sp)	# $s2 = C
        lw   $s3, 16($sp)	# $s3 = B
 
        addi $sp, $sp, 20       # restora o stack pointer
 
        jr $ra			# retorna para o inicio da função
 
    output:
 	# imprime os movimentos do console
        li $v0,  4              # imprime a string armazenada em part1
        la $a0,  part1		# "\nMove o disco "
        syscall			# imprime a mensagem no console
        li $v0,  1              # imprime um inteiro
        add $a0, $s0, $zero	# inteiro armazenado em $s0
        syscall			# imprime a mensagem no console
        li $v0,  4              # imprime a string armazenada em part2
        la $a0,  part2		# " da posição " 
        syscall			# imprime a mensagem no console
        li $v0,  11             # imprime um caractere
        add $a0, $s1, $zero	# inteiro(ascii) armazenado em $s1
        syscall			# imprime a mensagem no console
        li $v0,  4              # imprime a string armazenada em part3
        la $a0,  part3		# " para a posição "
        syscall			# imprime a mensagem no console
        li $v0,  11             # imprime um caractere 
        add $a0, $s2, $zero	# inteiro(ascii) armazenado em $s2
        syscall			# imprime a mensagem no console
        addi $t4, $t4, 1	# contador de movimentos
 
        beq $s0, $t1, exithanoi # analisa se $s0 = $t1, se for pula para exithanoi
        j recur2	        # se não, volta para a recur2
