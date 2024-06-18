#==================================
#File: questao6
#Description:
#Author: Almir (aasc)
#Version: 
#=================================

#Acumulador, iniciando em 0 e sendo incrementado no programa
#Esse numero sera o digito do display de 7 segmentos
addi x10, x0, 0

#base: registrador usado como base para o valor calculado
#Iniciado em 8 pois é o valor do 1000(binario)
addi x11, x0, 8

 
loop_ler_digito:
    beq  x11, x0, load_numero #salvar valor no registrador se a base chega a zero
	#base será constantimente dividida por 2 para simular uma especie de potenciação do 10(caminhando pelo numero binario)

	#Capturar numero do teclado e voltando caso nao haja nenhum numero
    lb   x5, 1025(x0)

    beq  x5, x0, loop_ler_digito

	#passando o numero de caracter para o decimal
    addi x5, x5, -48
	#Se o digito binario for 0 ele nao soma no acumulador     
    beq  x5, x0, div_dois  
#----------Abaixo soma no acumulador, que ocorre quando o digito é um, seguindo a regra dos numeros binarios 
   add  x10, x10, x11      # num = num + pow


#shift logico que divide o valor do registrador base
#o objetivo é usar o deslocamento afim de somar no acumulador de acordo com
#os 1's que existirem no binario que esta sendo decodificado no momento
div_dois:
    srli x5, x5, 1     
    jal  x1, loop_ler_digito



#Carrega o digito decodificado para
#usar nos 'ifs' abaixo
load_numero:
    add x12, x0, x10

#Limpa display
limpa_display: #if digito == 15
    lw x15, quinze 
    bne  x12, x15, decode_um #provavelmente nao deve ent

    add x6, x0
	#Zerando todos os pins de 2 a 8
	#2-7 PORT_D_escrita   
    sb   x6, 1029(x0)
    #8 PORT_B_escrita
    sb   x6, 1027(x0)
	#Como tudo ia ser zerado reaproveita-se o registrador x6 para ambos
	
	jal x1, fim
#---------Funcoes decodificadoras--------------
#Cada funcao referente a um digito do display
#decodificara o digito lido e calculado antes e acende os leds corretos
#de acordo com a tabela


#A partir daqui os pins escolhidos sao de acordo com a tabela de decodificação para cada digito
decode_um:
    lw x15, um
    bne  x12, x15, decode_dois     
	#pins 5 e 6 ligados
    addi x6, x0, 6    
    sb   x6, 1029(x0)
	#pin 8 desligado
	add x6, x0    
    sb   x6, 1027(x0)

    jal  x1, fim   
decode_dois:
    lw x15, dois
    bne  x12, x15, decode_tres 
	#pins 3, 4, 6 e 7 ligados
    addi x6, x0, 27    
    sb   x6, 1029(x0)
	#pin 8 ligado
	addi x6, x0, 1 
    sb   x6, 1027(x0)

    jal  x1, fim
decode_tres:
    lw x15, tres
    bne  x12, x15, decode_quatro
	#pins 4, 5, 6 e 7 ligados
	addi x6, x0, 15    
    sb   x6, 1029(x0)
	#pin 8 ligado
    addi x6, x0, 1   
    sb   x6, 1027(x0)
    
    jal  x1, fim     
decode_quatro:
    lw x15, quatro
    bne  x12, x15, decode_cinco
	#pins 2, 5, e 6 ligados
	addi x6, x0, 38
    sb   x6, 1029(x0)
	#pin 8 ligado
    addi x6, x0, 1 
    sb   x6, 1027(x0)

    jal  x1, fim      
decode_cinco:
    lw x15, cinco
    bne  x12, x15, decode_seis
	#pins 2, 4, 5 e 7 ligados
	addi x6, x0, 45  
    sb   x6, 1029(x0)
	#pin 8 ligado
    addi x6, x0, 1 
    sb   x6, 1027(x0)
    
    jal  x1, fim  
decode_seis:
    lw x15, seis
    bne  x12, x15, decode_sete
	#pins 2, 3, 4, 5, e 7 ligados
    addi x6, x0, 61    
    sb   x6, 1029(x0)
	#pin 8 ligado
	addi x6, x0, 1
    sb   x6, 1027(x0)

    jal  x1, fim  
decode_sete:
    lw x15, sete
    bne  x12, x15, decode_oito
	#pins 5, 6 e 7 ligados
	addi x6, x0, 7    
    sb   x6, 1029(x0)
	#pin 8 desligado
    add x6, x0
    sb x6, 1027(x0)
    

    jal  x1, fim   
decode_oito:
    lw x15, oito
    bne  x12, x15, decode_nove
	#2-7 ligados
    addi x6, x0, 255    
    sb   x6, 1029(x0)
	#pin 8 ligado
	addi x6, x0, 1
    sb   x6, 1027(x0)

    jal  x1, fim    
decode_nove:
    lw x15, nove
    bne  x12, x15, decode_zero
    #pins 2, 4, 5, 6, 7 ligados
    addi x6, x0, 47    # Pin 2, 3, 4, 5, 6, 7 = 101111
    sb   x6, 1029(x0)
	#pin 8 ligado
	addi x6, x0, 1 
    sb   x6, 1027(x0)

    jal  x1, fim  


decode_zero:
    bne  x12, x0, fim  
	#2-7 ligados
	addi x6, x0, 63  
    sb   x6, 1029(x0)
	#pin 8 desligado
    add x6, x0   
    sb   x6, 1027(x0)
    

    jal  x1, fim



#------------Funcoes decodificadoras-----------

fim: halt

#valores aux da memoria 1-9 e 15

um: .byte 1
dois: .byte 2
tres: .byte 3
quatro: .byte 4
cinco: .byte 5
seis: .byte 6
sete: .byte 7
oito: .byte 8
nove: .byte 9
quinze: .byte 15
