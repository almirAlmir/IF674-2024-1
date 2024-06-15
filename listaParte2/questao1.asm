lw x28, espaco #usarei para determinar fim da primeira palavra e inicio da segunda
lw x29, quebra_linha #carriage return: usarei para determinar fim da segunda palavra

addi x2, x2, 10000
addi x17, x0, 0 #Inicio do array contendo os valores das pontuações

#---------------------------------------------
#colocando os valores em ordem numa memoria sequencial
addi x5, x0, 3
sw x5, 0(x17)
addi x5, x0, 4
sw x5, 4(x17)
addi x5, x0, 4
sw x5, 8(x17)
addi x5, x0, 1
sw x5, 12(x17)
addi x5, x0, 3
sw x5, 16(x17)
addi x5, x0, 2
sw x5, 20(x17)
addi x5, x0, 1
sw x5, 24(x17)
addi x5, x0, 2
sw x5, 28(x17)
addi x5, x0, 3
sw x5, 32(x17)
addi x5, x0, 8
sw x5, 36(x17)
addi x5, x0, 5
sw x5, 40(x17)
addi x5, x0, 8
sw x5, 44(x17)
addi x5, x0, 4
sw x5, 48(x17)
addi x5, x0, 4
sw x5, 52(x17)
addi x5, x0, 3
sw x5, 56(x17)
addi x5, x0, 4
sw x5, 60(x17)
addi x5, x0, 6
sw x5, 64(x17)
addi x5, x0, 5
sw x5, 68(x17)
addi x5, x0, 5
sw x5, 72(x17)
addi x5, x0, 1
sw x5, 76(x17)
addi x5, x0, 3
sw x5, 80(x17)
addi x5, x0, 2
sw x5, 84(x17)
addi x5, x0, 2
sw x5, 88(x17)
addi x5, x0, 8
sw x5, 92(x17)
addi x5, x0, 2
sw x5, 96(x17)
addi x5, x0, 6
sw x5, 100(x17)

#------------------------------
palavra_1:
	lb x10, 1025(x0)
	beq x10, x28, palavra_2 #Considera ' '(espaco) como caracter de fim da primeira palavra

	addi x12, x10, -0x41 #sendo 41 equivalente a letra A, pego o indice da posição do caracter maiusculo
	
	slli x6, x12, 2 #multiplica o index por 4
	add x6, 	x17, x6 #Pega endereco do elemento pelo index

	lw x9, 0(x6) #guarda valor da pontuacao do caracter
	
	add x21, x21, x9 #Soma pontuacao ao registrador x21(escolhi esse para o jogador 1)
	
	jal x11, palavra_1

palavra_2: 
	lb x10, 1025(x0)
	beq x10, x29, continua #Considera o enter(carriage return) como caracter de fim da segunda palavra
#---------------------------------
#Repete processo anterior
	addi x12, x10, -0x41
	
	slli x6, x12, 2 
	add x6, 	x17, x6

	lw x9, 0(x6)
	
	add x22, x22, x9 #Soma pontuacao ao registrador x22(escolhi esse para o jogador 2)
#-----------------------------------------------------	
	jal x11, palavra_2

continua:
	sw x21, p1
	sw x22, p2
	lw x10, dez #carrega o valor 10 da variavel na memoria para calculos a seguir
print_1:
	blt x21, x10, if_1
	addi x21, x21, -10 #decrementa 10 para saber se chegamos na UNIDADE do numero da pontuacao
	addi x13, x13, 1 #acumula o numero de dezenas da pontuacao
	jal x2, print_1

#Caimos nesse if quando o valor for menor do que 10
if_1:
	addi x13, x13, 48
	sb x13, 1024(x0) #Printa dezana
	addi x21, x21, 48
	sb x21, 1024(x0)#Printa unidade
#obs: programa pode ser adaptado para printar valores centenarios

	sb x28, 1024(x0) #ESPACO
	

print_2:
	blt x22, x10, if_2
	addi x22, x22, -10 #decrementa 10 para saber se chegamos na UNIDADE do numero da pontuacao
	addi x14, x14, 1 #acumula o numero de dezenas da pontuacao
	jal x2, print_2

#Caimos nesse if quando o valor for menor do que 10
if_2:
	addi x14, x14, 48
	sb x14, 1024(x0) #Printa dezana
	addi x22, x22, 48
	sb x22, 1024(x0)#Printa unidade
#obs: programa pode ser adaptado para printar valores centenarios

	sb x29, 1024(x0)	#QUEBRA DE LINHA(Carriage return)

resultado:
	
	lw t1, p1 #carrego as pontuacoes originais nesses dois regs
	lw t2, p2

	beq t1, t2, empate
	blt t1, t2, player2_vence
	addi x9, x0, 49
	sb x9, 1024(x0)#Printa numero do vencerdor: 1
	jal x11, fim
player2_vence:
	
	addi x9, x0, 50
	sb x9, 1024(x0) #Printa o numero do vencedor: 2
	jal x11, fim
empate: 
	addi x25, x0, 69
	sb x25, 1024(x0)
	addi x25, x0, 77
	sb x25, 1024(x0)
	addi x25, x0, 80
	sb x25, 1024(x0)
	addi x25, x0, 65
	sb x25, 1024(x0)
	addi x25, x0, 84
	sb x25, 1024(x0)
	addi x25, x0, 69
	sb x25, 1024(x0)
#Uma forma nao tao sofisticada
#Ou otimizada para o aviso do EMPATE
#Mas caso sobre tempo apos as outras questoes
#Tentarei melhorar isso

fim: halt

espaco: .word 0x20
quebra_linha: .word 0x0d

p1: .word 0
p2: .word 0
dez: .word 10

#texto_empate: .word 0x454d50415445

#COMO EXECUTAR:
#As duas palavras em maiusculo
#Separadas por um espaco e uma
#quebra de linha com enter ao final da segunda palavra
#exemplo1: PONTE SORTE
#
#exemplo2: ESCOVA DENTAL
#
