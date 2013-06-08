	sys_exit        equ     1
	sys_read        equ     3
	sys_write       equ     4

	stdin           equ     0
	stdout          equ     1
	stderr          equ     3

	SECTION .data
		menor: db'Menor',10	;labels para print
		maior: db'Maior',10
		igual: db'Igual',10

	SECTION .bss
		str: resb 21		;string a ser lida
		strlen: equ $-str	;tamanho da string

	SECTION .text

global _start

	_start:
		mov eax, 3			;leitura da entrada
		mov ebx, 0
		mov ecx, str 		
		mov edx, strlen
		int 0x80
	
		dec eax				;ajuste do tamanho da string (remoção do \n)
		mov ebx, eax		;ebx e edi recebem o tamanho exato da string
		mov edi, eax		
		mov ecx, 1			;contador auxiliar para a casa decimal *1, *10, etc
		xor edx, edx		;será o acumulador (os números ficarão registrados aqui)

	parse:
		dec ebx					;decremento para acessar o índice correto
		cmp byte[str+ebx], 32	;compara se o byte atual é equivalente ao espaço ' '
		je pilhaop				;se for, terminou de encontrar um número. Logo, pula para a pilha
		xor eax, eax			;zera o acumulador
		mov al, [str + ebx]		;acessa a posição do char na string
		sub eax, '0'			;conversão de string pra int
		imul eax, ecx			;parte aritmética da conversão (multiplicar o que está no acumulador pelo sua unidade decimal *1, *10, etc)
		add edx, eax			;adicionar ao resultado
		imul ecx, 10			;sobe a casa decimal (unidade->dezena->centena->milhar etc)
		dec edi					;decrementa edi		
		cmp edi, 0				;edi=0 indica que recebeu todos os números, caso contrário ainda falta
		jne parse
		je pilhaop				;quando chega em edi=0, o último número ainda precisa ser inserido na pilha

	pilhaop:
		push edx				;coloca o número no topo da pilha
		mov ecx, 1				;reseta o contador das casas decimas
		xor edx, edx			;reseta os regs eax, edx
		xor eax, eax		
		dec edi		
		cmp edi, 0				;se edi<0 chegou ao fim da leitura (por causa do dec edi, na última iteração edi=-1), senão, ainda há números
		jg parse				
		jl aritmetica			

	aritmetica:
		pop eax					;Se a entrada é A B C, o topo da pilha é A, seguido de B seguido de C.
		pop ebx
		pop ecx
		add eax, ebx			;A + B
		cmp eax, ecx			;(A+B) ? C
		je equals				;jump para os prints
		jg bigger
		jmp smaller

	equals:						;print caso (A+B)=C
		mov eax, sys_write
		mov ebx, stdout
		mov ecx, igual
		mov edx, 6
		int 0x80
		jmp final

	bigger:						;print caso (A+B)>C
		mov eax, sys_write
		mov ebx, stdout
		mov ecx, maior
		mov edx, 6
		int 0x80
		jmp final

	smaller:					;print caso (A+B)<C
		mov eax, sys_write
		mov ebx, stdout
		mov ecx, menor
		mov edx, 6
		int 0x80
		jmp final

	final:
		mov eax,1
		mov ebx,0
		int 0X80