#==================================
#File: questao6
#Description:
#Author: Almir (aasc)
#Version: 
#=================================
reset_variaveis:


	addi x10, x0, 0   #Acumulador, iniciando em 0 e sendo incrementado no programa Esse numero sera o digito do display de 7 segmentos



	addi x11, x0, 8 #base: registrador usado como base para o valor calculado Iniciado em 8 pois é o valor do 1000(binario)

 
loop_ler_digito:
    beq  x11, x0, load_numero #salvar valor no registrador se a base chega a zero


	#base será constantimente dividida por 2 para simular que esta (caminhando pelo numero binario)

	
    lb   x5, 1025(x0)

    beq  x5, x0, loop_ler_digito #Capturar numero do teclado e voltando pro loop caso nao haja nenhum numero

	
    addi x5, x5, -48 #passando o numero de caracter para o decimal
	     
    beq  x5, x0, div_dois  #Se o digito binario for 0 ele nao soma no acumulador


#----------Abaixo soma no acumulador, que ocorre quando o digito é um, seguindo a regra dos numeros binarios 


	add  x10, x10, x11 


div_dois:                      
    srli x11, x11, 1     						#shift logico que divide o valor do registrador base o objetivo é usar o deslocamento afim de somar no acumulador de acordo com
    jal  x11, loop_ler_digito		#os digitos 1 que existirem no binario que esta sendo decodificado no momento





load_numero: 
    add x12, x0, x10 #Carrega o digito decodificado para usar nos 'ifs' abaixo


limpa_display: 
    addi x15, x0, 15 #Limpa display if digito == 15
    bne  x12, x15, decode_um

    addi x6, x0, 0 
	
	   
    sb   x6, 1029(x0) #2-7 PORT_D_escrita/Zerando todos os pins de 2 a 8
    
    sb   x6, 1027(x0) #8 PORT_B_escrita/Como tudo ia ser zerado reaproveita-se o registrador x6 para ambos
	
	
	jal x11, reset_variaveis



#---------Funcoes decodificadoras--------------
#Cada funcao referente a um digito do display
#decodificara o digito lido e calculado antes e acende os leds corretos
#de acordo com a tabela



decode_um: 
    addi x15, x0, 1 #A partir daqui os pins escolhidos sao de acordo com a tabela de decodificação para cada digito
    bne  x12, x15, decode_dois     
	
    addi x6, x0, 6    #pins 5 e 6 ligados
    sb   x6, 1029(x0)
	
	add x6, x0, x0    #pin 8 desligado
    sb   x6, 1027(x0)

    jal  x11, reset_variaveis   
decode_dois:
    addi x15, x0, 2
    bne  x12, x15, decode_tres 
	
    addi x6, x0, 27  #pins 3, 4, 6 e 7 ligados  
    sb   x6, 1029(x0)
	
	addi x6, x0, 1 #pin 8 ligado
    sb   x6, 1027(x0)

    jal  x11, reset_variaveis
decode_tres:
    addi x15, x0, 3
    bne  x12, x15, decode_quatro
	
	addi x6, x0, 15 #pins 4, 5, 6 e 7 ligados    
    sb   x6, 1029(x0)
	
    addi x6, x0, 1   #pin 8 ligado
    sb   x6, 1027(x0)
    
    jal  x11, reset_variaveis     
decode_quatro:
    addi x15, x0, 4
    bne  x12, x15, decode_cinco
	
	addi x6, x0, 38 #pins 2, 5, e 6 ligados
    sb   x6, 1029(x0)
	
    addi x6, x0, 1 #pin 8 ligado
    sb   x6, 1027(x0)

    jal  x11, reset_variaveis      
decode_cinco:
    addi x15, x0, 5
    bne  x12, x15, decode_seis
	
	addi x6, x0, 45  #pins 2, 4, 5 e 7 ligados
    sb   x6, 1029(x0)
	
    addi x6, x0, 1 #pin 8 ligado
    sb   x6, 1027(x0)
    
    jal  x11, reset_variaveis  
decode_seis:
    addi x15, x0, 6
    bne  x12, x15, decode_sete
	
    addi x6, x0, 61    #pins 2, 3, 4, 5, e 7 ligados
    sb   x6, 1029(x0)
	
	addi x6, x0, 1 #pin 8 ligado
    sb   x6, 1027(x0)

    jal  x11, reset_variaveis  
decode_sete:
    addi x15, x0, 7
    bne  x12, x15, decode_oito
	
	addi x6, x0, 7    #pins 5, 6 e 7 ligados
    sb   x6, 1029(x0)
	
    add x6, x0, x0 #pin 8 desligado
    sb x6, 1027(x0)
    

    jal  x11, reset_variaveis   
decode_oito:
    addi x15, x0, 8
    bne  x12, x15, decode_nove
	
    addi x6, x0, 255 #2-7 ligados   
    sb   x6, 1029(x0)
	
	addi x6, x0, 1 #pin 8 ligado
    sb   x6, 1027(x0)

    jal  x11, reset_variaveis    
decode_nove:
    addi x15, x0, 9
    bne  x12, x15, decode_zero
    
    addi x6, x0, 47   #pins 2, 4, 5, 6, 7 ligados 
    sb   x6, 1029(x0)
	
	addi x6, x0, 1 #pin 8 ligado
    sb   x6, 1027(x0)

    jal  x11, reset_variaveis  


decode_zero:
    bne  x12, x0, reset_variaveis
	
	addi x6, x0, 63  #2-7 ligados
    sb   x6, 1029(x0)
	
    add x6, x0, x0   #pin 8 desligado
    sb   x6, 1027(x0)
    

    jal  x11, reset_variaveis



#------------Funcoes decodificadoras-----------


#Houve alguns erros ao rodas o codigo causados por comentarios
#mal posicionados, no qual eu tive que remover alguns e editar outros
#pode estar faltando algum comentario explicativo por conta disso
