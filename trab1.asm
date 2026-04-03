	.data
	.align 2
	ptr_head: .word 0 #ponteiro para o nó head (locomotiva)
	.align 2
	next_id: .word 1 #contador para IDs

	#strings da interface
	msg_boas_vindas: .asciz "Bem-vindo ao jogo: Montagem de Trem\n"
	msg_id_usuario: .asciz "Digite o ID do vagão: "
	msg_tipo_vagao: .asciz "Digite o tipo/código do vagão (1 - Locomotiva | 2 - Carga | 3 - Passageiro | 4 - Combustível): "
	msg_menu: .asciz "\n------------ Menu ------------\n1 - Adicionar vagão no início\n2 - Adicionar vagão no final\n3 - Remover vagão por ID\n4 - Listar trem\n5 - Buscar vagão\n6 - Sair\n\nEscolha uma opção: "
	msg_opcao_invalida: .asciz "Opção inválida! Tente novamente.\n"
	msg_sair: .asciz "Saindo do jogo. Até logo!\n"

	#outputs da interface
	msg_encontrado: .asciz "Vagão encontrado!\n"
	msg_nao_encontrado: .asciz "Vagão não encontrado.\n"
	msg_printID: .asciz "ID do vagão: "
	msg_printCOD: .asciz "\nCódigo do vagão: "
	
	.text
	.align 2
	.globl main

main:
	#inicializar o trem (cria a locomotiva)
	jal ra, construtor
	
	#input dos vagões
	
	#exibir mensagem de boas-vindas
	li a7, 4 #carrega o serviço de impressão de string em a7
	la a0, msg_boas_vindas #carrega o endereço de "msg_boas_vindas" em a0
	ecall #executa o comando de impressão

#loop infinito até que o usuário digite a opção 6
loop_escolha_menu:
	#exibir o menu
	li a7, 4 #carrega o serviço de impressão de string (código ecall 4) em a7
	la a0, msg_menu #carrega o endereço de "msg_menu" em a0
	ecall #executa o comando de impressão
	
	#ler a opção digitada pelo usuário e guarda em uma variável
	li a7, 5 #carrega o serviço de leitura de inteiro (código ecall 5) em a7
	ecall #executa o comando de leitura (valor lido é guardado em a0)

	#desvia para a função correta comparando com a entrada (a0)
	li t0, 1 #carrega 1 em t0 (registrador temporário)
	beq a0, t0, chamar_insert_inicio #se a0 == 1, pula para a função adicionar no início

	li t0, 2 #carrega 2 em t0 
	beq a0, t0, chamar_insert_final #se a0 == 2, pula para a função adicionar no final

	li t0, 3 #carrega 3 em t0 
	beq a0, t0, chamar_remover #se a0 == 3, pula para a função remover

	li t0, 4 #carrega 4 em t0 
	beq a0, t0, chamar_listar #se a0 == 4, pula para a função listar

	li t0, 5 #carrega 5 em t0 
	beq a0, t0, chamar_buscar #se a0 == 5, pula para a função buscar

	li t0, 6 #carrega 6 em t0 
	beq a0, t0, encerrar_jogo #compara a0 com t0, se forem iguais, pula para "encerrar_jogo"

	#se nenhuma opção válida for digitada (nenhum beq acima for ativado), então:
	li a7, 4 #carrega o serviço de impressão de string (código ecall 4) em a7
	la a0, msg_opcao_invalida #carrega o endereço de "msg_opcao_invalida" em a0
	ecall #executa o comando de impressão
	j loop_escolha_menu

# ================ BLOCOS DE CHAMADA ================
chamar_insert_inicio:
	#imprimir pedido de tipo de vagão
	li a7, 4 #carrega o serviço de impressão de string em a7
    la a0, msg_tipo_vagao #carrega o endereço de "msg_tipo_vagao" em a0
	ecall #executa o comando de impressão

	#ler o número digitado pelo usuário
	li a7, 5 #carrega o serviço de leitura de inteiro em a7
    ecall #executa o comando de leitura

	#chamar a função "insert_inicio"
	jal ra, insert_inicio #chama a função "insert_inicio"
	j loop_escolha_menu #volta ao menu principal

chamar_insert_final:
	#imprimir pedido de tipo de vagão
	li a7, 4 #carrega o serviço de impressão de string em a7
    la a0, msg_tipo_vagao #carrega o endereço de "msg_tipo_vagao" em a0
	ecall #executa o comando de impressão

	#ler o número digitado pelo usuário
	li a7, 5 #carrega o serviço de leitura de inteiro em a7
    ecall #executa o comando de leitura
	
	#chamar a função "insert_final" de inserção no final
	jal ra, insert_final #chama a função "insert_final"
	j loop_escolha_menu #volta ao menu principal

chamar_remover:
	#imprimir mensagem de pedido de id 
	li a7, 4 #carrega o serviço de impressão de string em a7
	la a0, msg_id_usuario #carrega o endereço de "msg_id_usuario" em a0
	ecall #executa o comando de impressão

	#ler o número digitado pelo usuário
	li a7, 5 #carrega o serviço de leitura de inteiro em a7
	ecall #executa o comando de leitura

	#chamar a função de remoção
	jal ra, remove_no #chama a função "remove_no"
	j loop_escolha_menu #volta ao menu principal

chamar_listar:
	jal ra, printTrain #chama a função "printTrain"
	j loop_escolha_menu #volta ao menu principal

chamar_buscar:
	#imprimir mensagem de pedido de id 
	li a7, 4 #carrega o serviço de impressão de string em a7
	la a0, msg_id_usuario #carrega o endereço de "msg_id_usuario" em a0
	ecall #executa o comando de impressão

	#ler o número digitado pelo usuário
	li a7, 5 #carrega o serviço de leitura de inteiro em a7
	ecall #executa o comando de leitura

	#chamar a função de busca
	jal ra, busca_por_id #chama a função "busca_por_id"
	j loop_escolha_menu #volta ao menu principal

construtor:
	#alocar 12 bytes na memória dinâmica para o nó
	#4 bytes para o ID;
	#4 bytes para string do tipo (3 caracteres e \0);
	#4 bytes para o ponteiro do proximo 
	addi a7, zero, 9
	addi a0, zero, 12
	ecall
	
	#definir valores padrões do nó
	sw zero, 0(a0) #define o ID para 0
	sw zero, 8(a0) #define o ponteiro do prï¿½ximo para 0
	
	#definir o endereço para onde ptr_head vai apontar 
	la t1, ptr_head
	sw a0, 0(t1) # ptr_head aponta para o espaï¿½o na heap que a0 guarda
	
	#voltar para a main
	jalr zero, 0(ra)

# ================ INSERÇÃO ================		
insert_final:
	#argumentos esperados
	#a0 = Tipo do vagão

	add t4, zero, a0 #guarda o tipo do vagão no registrador temporário
	
	#alocar os bytes na heap
	addi a7, zero, 9
	addi a0, zero, 12
	ecall
	
	#ler o valor do id atual e escrever na heap
	la t1, next_id #t1 recebe o endereco de next_id
	lw t3, 0(t1) #t3 recebe o valor do id atual
	sw t3, 0(a0) #escreve o valor do id atual nos 4 primeiros bytes
	
	#incrementar valor do next_Id
	addi t3, t3, 1
	sw t3, 0(t1)
	
	#escrever o tipo do vagão na heap
	sw t4, 4(a0) #escreve o tipo do vagão nos bytes 4 - 7
	
	#escrever zero no ponteiro para o próximo vagão (pois é o último)
	sw zero, 8(a0)
	
	#buscar o último vagão
	la t1, ptr_head #t1 recebe o endereço de ptr_head
	lw t0, 0(t1) #t0 recebe o conteúdo de head

busca_ultimo:
	lw t1, 8(t0) #t1 le o ponteiro para o próximo no do vagão atual
	
	#verificar se o valor = 0 (se sim, significa que e o último vagão)
	beq t1, zero, link_final
	
	#se não for zero, continua a percorrer a lista
	add t0, t1, zero #t0 recebe o endereço guardado no ponteiro para o próximo vagão
	jal zero, busca_ultimo

link_final:
	#guardar o endereço do vagão atual no ponteiro do anterior
	sw a0, 8(t0)
	
	#retornar para a main
	jalr zero, 0(ra)

insert_inicio:
	#argumentos esperados
	#a0 = Tipo do vagão

	add t4, zero, a0 #guarda o tipo do vagão no registrador temporário
	
	#alocar os bytes na heap
	addi a7, zero, 9
	addi a0, zero, 12
	ecall
	
	#ler o valor do Id atual e escrever na heap
	la t1, next_id #t1 recebe o endereco de next_id
	lw t3, 0(t1) #t3 recebe o valor do id atual
	sw t3, 0(a0) #escreve o valor do id atual nos 4 primeiros bytes
	
	#incrementar valor do next_Id
	addi t3, t3, 1
	sw t3, 0(t1)
	
	#escrever o tipo do vagão na heap
	sw t4, 4(a0) #escreve o tipo do vagão nos bytes 4 - 7
	
	#acessar a locomotiva
	la t1, ptr_head
	lw t0, 0(t1)
	
	#acessar o antigo primeiro vagão
	lw t2, 8(t0)
	
	#liga o antigo primeiro vagão ao novo vagão
	sw t2, 8(a0)
	
	#liga o novo vagão a locomotiva
	sw a0, 8(t0)
	
	#retorna para a main
	jalr zero, 0(ra)

# ================ REMOÇÃO ================
remove_no:
	add t0, a0, zero #copia o id que queremos apagar para t0
	
	#t1 armazena o endereço da locomotiva
	la t1, ptr_head
	lw t1, 0(t1)
	
	#se a lista estiver vazia t1 == 0, não faz nada
	beq t1, zero, fim_remove
	
	#t2 lê o id da locomotiva, se o que o usuário digitou for da locomotiva
	lw t2, 0(t1)
	beq t0, t2, fim_remove

remove_busca:
	#t1 é o anterior e t2 é o atual
	
	#t2 recebe o endereço do próximo vagão
	lw t2, 8(t1)
	
	#se t2 for zero, é o fim do trem e o id não existe
	beq t2, zero, fim_remove
	
	#ID do vagão atual que está em t2, é colocado em t3
	lw t3, 0(t2)
	
	#se o id a ser apagado for igual ao atual, executamos a remoção
	beq t3, t0, remove_executa
	
	#caso não, continuamos na busca recursiva, e t1(anterior), passa a ser o t2(atual)
	add t1, t2, zero
	jal zero, remove_busca

remove_executa:
	#t4, armazena o endereço do vagão depois do que será removido agora
	lw t4, 8(t2)
	sw t4, 8(t1)

fim_remove:
	jalr zero, 0(ra)

# ================ BUSCA ================
busca_por_id:	
	#a0 = id de busca
	#copia o id que o usuário quer buscar
	add t0, a0, zero
	
	#carrega o endereço de ptr_head no registrador t1
	la t1, ptr_head
	
	lw t1, 0(t1)
	
loop_busca:
	#compara o t1 com zero, se for igual não achamos o vagão, salta para "nao_achou"
	beq t1, zero, nao_achou
	
	#armazena o id do vagão
	lw t2, 0(t1)
	
	#verifica se o id do vagão é igual ao do t0, que o usuário ta buscando
	beq t2, t0, achou
	
	#lê o endereço no deslocamento 8, ponteiro para o próximo e atualiza o próprio t1 com esse endereço
	lw t1, 8(t1)
	
	#retorna a fazer o loop
	jal zero, loop_busca

achou:
	#código 4 no a7 avisa o sistema que queremos imprimir texto
	addi a7, zero, 4
	#carrega o endereço do texto em a0
	la a0, msg_encontrado
	#executa
	ecall
	
	#retorna para a main
	jalr zero, 0(ra)

nao_achou:
	#código 4 no a7 avisa o sistema que queremos imprimir texto
	addi a7, zero, 4
	#carrega o endereço do texto em a0
	la a0, msg_nao_encontrado
	#executa
	ecall
	
	#retorna para a main
	jalr zero, 0(ra)

# ================ EXIBIÇÃO ================
printTrain:
	#inicia a partir do começo da lista (locomotiva)
	la t1, ptr_head
	lw t0, 0(t1) #t0 recebe o endereço da locomotiva (início do trem)

loop_printTrain:
	#verificar se o valor do ponteiro é 0 (se sim, significa que é o último vagão)
	beq t0, zero, fim_printTrain
	
	#se não for o final do trem, imprime os campos
	#imprime o texto de ID do vagão
	addi a7, zero, 4
	la a0, msg_printID
	ecall
	
	#imprime o id do vagão
	lw t2, 0(t0)
	add a0, zero, t2
	li a7, 1
	ecall
	
	#imprime o texto de código do vagão
	addi a7, zero, 4
	la a0, msg_printCOD
	ecall
	
	#imprime o código do vagão
	lw a0, 4(t0) #lê o número guardado no offset 4
	li a7, 1 
	ecall

	#imprime quebra de linha para organizar a lista na tela
	li a0, 10 #10 é o código ASCII para '\n'
	li a7, 11 #serviço 11 é o de imprimir caractere
	ecall

	#vai para o próximo vagão
	lw t0, 8(t0)
	jal zero, loop_printTrain

fim_printTrain:
	#retorna para a main
	jalr zero, 0(ra)

# ================ ENCERRAR JOGO ================
encerrar_jogo:
	li a7, 4 #carrega o serviço de impressão de string em a7
	la a0, msg_sair #carrega o endereço de "msg_sair" em a0
	ecall #executa o comando de impressão

	li a7, 10 #carrega o serviço de encerrar o programa em a7
	ecall #fim da execução dos comandos

