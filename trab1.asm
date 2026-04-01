	.data
	.align 2
	ptr_head: .word 0 #ponteiro para o no head (locomotiva)
	.align 2
	next_id: .word 2 #contador para IDs
	
	#outputs da interface
	
	.text
	.align 2
	.globl main

main:
	#inicializar o trem (cria a locomotiva)
	jal ra, construtor
	
	# input dos vag�es
	
	
	
	
	addi a7, zero, 10
	ecall

construtor:
	# Alocar 12 bytes na memoria dinamica para o no=
	# 4 bytes para o ID;
	# 4 bytes para string do tipo (3 caracteres e \0);
	# 4 bytes para o ponteiro do proximo 
	addi a7, zero, 9
	addi a0, zero, 12
	ecall
	
	# definir valores padroes do no
	sw zero, 0(a0) # define o ID para 0
	sw zero, 8(a0) # define o ponteiro do pr�ximo para 0
	
	# Definir o endere�o para onde ptr_head vai apontar 
	la t1, ptr_head
	sw a0, 0(t1) # ptr_head aponta para o espa�o na heap que a0 guarda
	
	# Voltar para a main
	jalr zero, 0(ra)
		
new_no:
	# Argumentos esperados
	# a0 = Tipo do vag�o

	add t4, zero, a0 # guarda o tipo do vag�o no registrador tempor�rio
	
	# Alocar os bytes na heap
	addi a7, zero, 9
	addi a0, zero, 12
	ecall
	
	# Ler o valor do Id atual e escrever na heap
	la t1, next_id # t1 recebe o endere�o de next_id
	lw t3, 0(t1) # t3 recebe o valor do id atual
	sw t3, 0(a0) # escreve o valor do id atual nos 4 primeiros bytes
	
	# Incrementar valor do next_Id
	addi t3, t3, 1 # incrementa o id para o pr�ximo n�
	sw t3, 0(t1) # atualiza o valor de next_id
	
	# Escrever o tipo do vag�o na heap
	sw t4, 4(a0) # escreve o tipo do vag�o nos bytes 4 - 7
	sw zero, 8(a0) # escreve o valor 0 nos bytes do ponteiro para o pr�ximo vag�o
	
	la t1, ptr_head # t1 recebe o endere�o de ptr_head
	lw t0, 0(t1) # t0 recebe o conte�do de head
	# programa entra na fun��o de busca do �ltimo n�

search_last:
	lw t1, 8(t0) # t1 l� o ponteiro para o pr�ximo n� do vag�o atual
	
	# Verificar se o valor � 0 (se sim, significa que � o �ltimo vag�o)
	beq t1, zero, link_no
	
	# Se n�o for zero, percorre a lista
	add t0, t1, zero #t0 recebe o endere�o guardado no ponteiro para o pr�ximo vag�o
	jal zero, search_last

link_no:
	# Guardar o endere�o do n� atual no ponteiro do anterior
	sw a0, 8(t0)
	
	# Retornar para a main
	jalr zero, 0(ra)
	
	
# ================ REMOÇÃO ====================
	
remove_no:
	add t0, a0, zero # Copia o id que queremos apagar para t0
	
	# t1 armazena o endereço da locomotiva
	la t1, ptr_head
	lw t1, 0(t1)
	
	# Se a lista estiver vazia t1 == 0, não faz nada
	beq t1, zero, fim_remove
	
	#t2 le o id da locomotiva, se o que o usuario digitou for da locomotiva
	lw t2, 0(t1)
	beq t0, t2, fim_remove

remove_busca:
	#t1 é o anterior e t2 é o atual
	
	# t2 recebe o endereço do proximo vagao
	lw t2, 8(t1)
	
	# Se t2 for zero, é o fim do trem e o ID nao existe
	beq t2, zero, fim_remove
	
	# ID do vagão atual que esta em t2, é colocado em t3
	lw t3, 0(t2)
	
	# Se o id a ser apagado for igual ao atual, executamos a remocao
	beq t3, t0, remove_executa
	
	# caso nao, continuamos na busca recursiva, e t1(anterior), passa a ser o t2(atual)
	add t1, t2, zero
	jal zero, remove_busca

remove_executa:
	# t4, armazena o endereco do vagao depois do que será removido agora
	lw t4, 8(t2)
	sw t4, 8(t1)

fim_remove:
	jalr zero, 0(ra)