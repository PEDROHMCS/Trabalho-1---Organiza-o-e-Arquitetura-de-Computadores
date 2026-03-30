	.data
	.align 2
	ptr_head: .word 0 #ponteiro para o nó head (locomotiva)
	.align 2
	next_id: .word 2 #contador para IDs
	
	#outputs da interface
	
	.text
	.align 2
	.globl main

main:
	#inicializar o trem (cria a locomotiva)
	jal ra, construtor
	
	# input dos vagões
	
	
	
	
	addi a7, zero, 10
	ecall

construtor:
	# Alocar 12 bytes na memória dinâmica para o nó
	# 4 bytes para o ID;
	# 4 bytes para string do tipo (3 caracteres e \0);
	# 4 bytes para o ponteiro do próximo 
	addi a7, zero, 9
	addi a0, zero, 12
	ecall
	
	# definir valores padrões do nó
	sw zero, 0(a0) # define o ID para 0
	sw zero, 8(a0) # define o ponteiro do próximo para 0
	
	# Definir o endereço para onde ptr_head vai apontar 
	la t1, ptr_head
	sw a0, 0(t1) # ptr_head aponta para o espaço na heap que a0 guarda
	
	# Voltar para a main
	jalr zero, 0(ra)
		
new_no:
	# Argumentos esperados
	# a0 = Tipo do vagão

	add t4, zero, a0 # guarda o tipo do vagão no registrador temporário
	
	# Alocar os bytes na heap
	addi a7, zero, 9
	addi a0, zero, 12
	ecall
	
	# Ler o valor do Id atual e escrever na heap
	la t1, next_id # t1 recebe o endereço de next_id
	lw t3, 0(t1) # t3 recebe o valor do id atual
	sw t3, 0(a0) # escreve o valor do id atual nos 4 primeiros bytes
	
	# Incrementar valor do next_Id
	addi t3, t3, 1 # incrementa o id para o próximo nó
	sw t3, 0(t1) # atualiza o valor de next_id
	
	# Escrever o tipo do vagão na heap
	sw t4, 4(a0) # escreve o tipo do vagão nos bytes 4 - 7
	sw zero, 8(a0) # escreve o valor 0 nos bytes do ponteiro para o próximo vagão
	
	la t1, ptr_head # t1 recebe o endereço de ptr_head
	lw t0, 0(t1) # t0 recebe o conteúdo de head
	# programa entra na função de busca do último nó

search_last:
	lw t1, 8(t0) # t1 lê o ponteiro para o próximo nó do vagão atual
	
	# Verificar se o valor é 0 (se sim, significa que é o último vagão)
	beq t1, zero, link_no
	
	# Se não for zero, percorre a lista
	add t0, t1, zero #t0 recebe o endereço guardado no ponteiro para o próximo vagão
	jal zero, search_last

link_no:
	# Guardar o endereço do nó atual no ponteiro do anterior
	sw a0, 8(t0)
	
	# Retornar para a main
	jalr zero, 0(ra)


	
