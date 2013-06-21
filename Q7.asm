sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4

stdin           equ     0
stdout          equ     1
stderr          equ     3

SECTION .data

linha1:db'...',10
linha2:db'...',10
linha3:db'...',10
jogador1:db'Jogador 1',10
jogador2:db'Jogador 2',10
empates:db'Empate!',10
jogador1ganhou:db'Jogador 1 ganhou!',10
jogador2ganhou:db'Jogador 2 ganhou!',10
jogadaInvalidas:db'Jogada invalida!',10
cus:db'cu',10

SECTION .bss

str: resb 5
strlen: equ $-str

SECTION .text

	global _start

_start:

xor esi,esi

turno_1:
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,jogador1
	mov edx,10
	int 0X80
	
	jmp leitura_1

turno_1_p2:
	call jogada_1
	call printTabuleiro
	call verificarVencedor_1
	inc esi
	call verificarEmpate
	jmp turno_2

turno_2:
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,jogador2
	mov edx,10
	int 0X80
	jmp leitura_2

turno_2_p2:
	call jogada_2
	call printTabuleiro
	call verificarVencedor_2
	inc esi
	call verificarEmpate
	jmp turno_1

jogada_2:
	cmp eax,1
	je jogarLinha1_2
	cmp eax,2
	je jogarLinha2_2
	cmp eax,3
	je jogarLinha3_2
	jmp jogadaInvalida_2

jogarLinha1_2:
	cmp byte[linha1+ebx-1],'.'
	jne jogadaInvalida_2
	mov byte[linha1+ebx-1],'O'
	ret
jogarLinha2_2:
	cmp byte[linha2+ebx-1],'.'
	jne jogadaInvalida_2
	mov byte[linha2+ebx-1],'O'
	ret
jogarLinha3_2:
	cmp byte[linha3+ebx-1],'.'
	jne jogadaInvalida_2
	mov byte[linha3+ebx-1],'O'
	ret

;-----------------------------------
jogada_1:
	cmp eax,1
	je jogarLinha1_1
	cmp eax,2
	je jogarLinha2_1
	cmp eax,3
	je jogarLinha3_1
	jmp jogadaInvalida_1

;-----------------------------------------
jogarLinha1_1:
	cmp byte[linha1+ebx-1],'.'
	jne jogadaInvalida_1
	mov byte[linha1+ebx-1],'X'
	ret
jogarLinha2_1:
	cmp byte[linha2+ebx-1],'.'
	jne jogadaInvalida_1
	mov byte[linha2+ebx-1],'X'
	ret
jogarLinha3_1:
	cmp byte[linha3+ebx-1],'.'
	jne jogadaInvalida_1
	mov byte[linha3+ebx-1],'X'
	ret
;-------------------------------------	

jogadaInvalida_1:
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,jogadaInvalidas
	mov edx,17
	int 0X80
	call printTabuleiro
	jmp turno_1

jogadaInvalida_2:
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,jogadaInvalidas
	mov edx,17
	int 0X80
	call printTabuleiro
	jmp turno_2
;-------------------------------------------
verificarEmpate:
	cmp esi,9
	je empate
	ret
;-----------------------------------------
verificarVencedor_2:
	call verificarLinha1b1_2
	call verificarLinha2b1_2
	call verificarLinha3b1_2
	call verificarColuna1b1_2
	call verificarColuna2b1_2
	call verificarColuna3b1_2
	call verificarDiagonal1b1_2
	call verificarDiagonal2b1_2
	ret

;--------------------------------verifica diagonal2
verificarDiagonal2b1_2:
	cmp byte[linha1+2],'O'
	je verificarDiagonal2b2_2
	ret
verificarDiagonal2b2_2:
	cmp byte[linha2+1],'O'
	je verificarDiagonal2b3_2
	ret
verificarDiagonal2b3_2:
	cmp byte[linha3],'O'
	je vitoria2
	ret

;---------------------------------verifica diagonal1
verificarDiagonal1b1_2:
	cmp byte[linha1],'O'
	je verificarDiagonal1b2_2
	ret
verificarDiagonal1b2_2:
	cmp byte[linha2+1],'O'
	je verificarDiagonal1b3_2
	ret
verificarDiagonal1b3_2:
	cmp byte[linha3+2],'O'
	je vitoria2
	ret

;----------------------------------verifica coluna3
verificarColuna3b1_2:
	cmp byte[linha1+2],'O'
	je verificarColuna3b2_2
	ret
verificarColuna3b2_2:
	cmp byte[linha2+2],'O'
	je verificarColuna3b3_2
	ret
verificarColuna3b3_2:
	cmp byte[linha3+2],'O'
	je vitoria2
	ret

;---------------------------------verifica coluna2
verificarColuna2b1_2:
	cmp byte[linha1+1],'O'
	je verificarColuna2b2_2
	ret
verificarColuna2b2_2:
	cmp byte[linha2+1],'O'
	je verificarColuna2b3_2
	ret
verificarColuna2b3_2:
	cmp byte[linha3+1],'O'
	je vitoria2
	ret

;----------------------------------verifica coluna1
verificarColuna1b1_2:
	cmp byte[linha1],'O'
	je verificarColuna1b2_2
	ret
verificarColuna1b2_2:
	cmp byte[linha2],'O'
	je verificarColuna1b3_2
	ret
verificarColuna1b3_2:
	cmp byte[linha3],'O'
	je vitoria2
	ret

;----------------------------------verifica linha3
verificarLinha3b1_2:
	cmp byte[linha3],'O'
	je verificarLinha3b2_2
	ret
verificarLinha3b2_2:
	cmp byte[linha3+1],'O'
	je verificarLinha3b3_2
	ret
verificarLinha3b3_2:
	cmp byte[linha3+2],'O'
	je vitoria2
	ret

;---------------------------------verifica linha2
verificarLinha2b1_2:
	cmp byte[linha2],'O'
	je verificarLinha2b2_2
	ret
verificarLinha2b2_2:
	cmp byte[linha2+1],'O'
	je verificarLinha2b3_2
	ret
verificarLinha2b3_2:
	cmp byte[linha2+2],'O'
	je vitoria2
	ret

;---------------------------------verifica linha1
verificarLinha1b1_2:
	cmp byte[linha1],'O'
	je verificarLinha1b2_2
	ret
verificarLinha1b2_2:
	cmp byte[linha1+1],'O'
	je verificarLinha1b3_2
	ret
verificarLinha1b3_2:
	cmp byte[linha1+2],'O'
	je vitoria2
	ret

;----------------------------------------
verificarVencedor_1:
	call verificarLinha1b1_1
	call verificarLinha2b1_1
	call verificarLinha3b1_1
	call verificarColuna1b1_1
	call verificarColuna2b1_1
	call verificarColuna3b1_1
	call verificarDiagonal1b1_1
	call verificarDiagonal2b1_1
	ret

;------------------------------------verifica diagonal2
verificarDiagonal2b1_1:
	cmp byte[linha1+2],'X'
	je verificarDiagonal2b2_1
	ret
verificarDiagonal2b2_1:
	cmp byte[linha2+1],'X'
	je verificarDiagonal2b3_1
	ret
verificarDiagonal2b3_1:
	cmp byte[linha3],'X'
	je vitoria1
	ret

;--------------------------------------verifica diagonal1
verificarDiagonal1b1_1:
	cmp byte[linha1],'X'
	je verificarDiagonal1b2_1
	ret
verificarDiagonal1b2_1:
	cmp byte[linha2+1],'X'
	je verificarDiagonal1b3_1
	ret
verificarDiagonal1b3_1:
	cmp byte[linha3+2],'X'
	je vitoria1
	ret

;-------------------------------------verifica coluna3
verificarColuna3b1_1:
	cmp byte[linha1+2],'X'
	je verificarColuna3b2_1
	ret
verificarColuna3b2_1:
	cmp byte[linha2+2],'X'
	je verificarColuna3b3_1
	ret
verificarColuna3b3_1:
	cmp byte[linha3+2],'X'
	je vitoria1
	ret

;-------------------------------------verifica coluna2
verificarColuna2b1_1:
	cmp byte[linha1+1],'X'
	je verificarColuna2b2_1
	ret
verificarColuna2b2_1:
	cmp byte[linha2+1],'X'
	je verificarColuna2b3_1
	ret
verificarColuna2b3_1:
	cmp byte[linha3+1],'X'
	je vitoria1
	ret

;-------------------------------------verifica coluna1
verificarColuna1b1_1:
	cmp byte[linha1],'X'
	je verificarColuna1b2_1
	ret
verificarColuna1b2_1:
	cmp byte[linha2],'X'
	je verificarColuna1b3_1
	ret
verificarColuna1b3_1:
	cmp byte[linha3],'X'
	je vitoria1
	ret

;---------------------------------------verifica linha3
verificarLinha3b1_1:
	cmp byte[linha3],'X'
	je verificarLinha3b2_1
	ret
verificarLinha3b2_1:
	cmp byte[linha3+1],'X'
	je verificarLinha3b3_1
	ret
verificarLinha3b3_1:
	cmp byte[linha3+2],'X'
	je vitoria1
	ret

;------------------------------------verifica linha2
verificarLinha2b1_1:
	cmp byte[linha2],'X'
	je verificarLinha2b2_1
	ret
verificarLinha2b2_1:
	cmp byte[linha2+1],'X'
	je verificarLinha2b3_1
	ret
verificarLinha2b3_1:
	cmp byte[linha2+2],'X'
	je vitoria1
	ret
;--------------------------------------verifica linha1
verificarLinha1b1_1:
	cmp byte[linha1],'X'
	je verificarLinha1b2_1
	ret
verificarLinha1b2_1:
	cmp byte[linha1+1],'X'
	je verificarLinha1b3_1
	ret
verificarLinha1b3_1:
	cmp byte[linha1+2],'X'
	je vitoria1
	ret

;-------------------------------------------
printTabuleiro:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, linha1
	mov edx, 4
	int 0X80

	mov eax, sys_write
	mov ebx, stdout
	mov ecx, linha2
	mov edx, 4
	int 0X80

	mov eax, sys_write
	mov ebx, stdout
	mov ecx, linha3
	mov edx, 4
	int 0X80
	ret

;-------------------------------------
vitoria1:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, jogador1ganhou
	mov edx, 18
	int 0X80
	jmp final

vitoria2:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, jogador2ganhou
	mov edx, 18
	int 0X80
	jmp final

;-------------------------------------
empate:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, empates
	mov edx, 8
	int 0X80
	jmp final

;-------------------------------------------
leitura_1:
	mov eax, 3
	mov ebx, 0
	mov ecx, str 		;a string está no ecx
	mov edx, strlen
	int 0x80

	dec eax			;ajuste do tamanho da string (remoção do \n)
	mov ebx, eax		;ebx e edi recebem o tamanho exato da string
	mov edi, eax		
	mov ecx, 1		;contador auxiliar para a casa decimal *1, *10, etc
	xor edx, edx		;será o acumulador (os números ficarão registrados aqui)

parse_1:
	dec ebx			;decremento para acessar o índice correto
	cmp byte[str+ebx], 32	;compara se o byte atual é equivalente ao espaço ' '
	je pilhaop_1		;se for, terminou de encontrar um número. Logo, pula para a pilha
	xor eax, eax		;zera o acumulador
	mov al, [str + ebx]	;acessa a posição do char na string
	sub eax, '0'		;conversão de string pra int
	imul eax, ecx		;parte aritmética da conversão
	add edx, eax
	imul ecx, 10		;sobe a casa decimal (unidade->dezena->centena->milhar etc)
	dec edi			;decrementa edi		
	cmp edi, 0		;edi=0 indica que recebeu todos os números, caso contrário ainda falta
	jne parse_1
	je pilhaop_1

pilhaop_1:
	push edx		;coloca o número no topo da pilha
	mov ecx, 1		;reseta o contador das casas decimas
	xor edx, edx		;reseta os regs eax, edx
	xor eax, eax		
	dec edi		
	cmp edi, 0		;se edi=0 chegou ao fim da leitura, senão, ainda há números
	jg parse_1
	jl inteirosnapilha_1

inteirosnapilha_1:
	pop eax		;primeiro inteiro está no eax (linha)
	pop ebx		;segundo inteiro está no ebx (coluna)
	jmp turno_1_p2

;------------------------------------------------------------

leitura_2:
	mov eax, 3
	mov ebx, 0
	mov ecx, str 		;a string está no ecx
	mov edx, strlen
	int 0x80

	dec eax			;ajuste do tamanho da string (remoção do \n)
	mov ebx, eax		;ebx e edi recebem o tamanho exato da string
	mov edi, eax		
	mov ecx, 1		;contador auxiliar para a casa decimal *1, *10, etc
	xor edx, edx		;será o acumulador (os números ficarão registrados aqui)

parse_2:
	dec ebx			;decremento para acessar o índice correto
	cmp byte[str+ebx], 32	;compara se o byte atual é equivalente ao espaço ' '
	je pilhaop_2		;se for, terminou de encontrar um número. Logo, pula para a pilha
	xor eax, eax		;zera o acumulador
	mov al, [str + ebx]	;acessa a posição do char na string
	sub eax, '0'		;conversão de string pra int
	imul eax, ecx		;parte aritmética da conversão
	add edx, eax
	imul ecx, 10		;sobe a casa decimal (unidade->dezena->centena->milhar etc)
	dec edi			;decrementa edi		
	cmp edi, 0		;edi=0 indica que recebeu todos os números, caso contrário ainda falta
	jne parse_2
	je pilhaop_2

pilhaop_2:
	push edx		;coloca o número no topo da pilha
	mov ecx, 1		;reseta o contador das casas decimas
	xor edx, edx		;reseta os regs eax, edx
	xor eax, eax		
	dec edi		
	cmp edi, 0		;se edi=0 chegou ao fim da leitura, senão, ainda há números
	jg parse_2
	jl inteirosnapilha_2

inteirosnapilha_2:
	pop eax		;primeiro inteiro está no eax (linha)
	pop ebx		;segundo inteiro está no ebx (coluna)
	jmp turno_2_p2

;-------------------------------------------------------------

final:
	mov eax,1 ; aqui ele encerra o programa >> exit
	mov ebx,0
	int 0X80
