
SECTION .data
	resto: db'Resto: '
	restolen: equ $-resto
	resultado: db'Resultado: '
	resultlen: equ $-resultado
	barran:	db"",10

SECTION .bss
	a:	resb 5
	b:	resb 5
	in: 	resb 5
	in_len:	equ $-in
	resp:	resb 5
	resplen: equ $-resp

SECTION .text

global _start
_start:
	
	call leitura		;leitura primeiro numero
	call parse		;conversao de string pra int
	mov [a], edx		;salva o numero na memoria
		
	call leitura		;leitura segundo numero
	call parse		
	mov [b], edx
	
	call leitura		;leitura operador
	mov al, [in]		;salva o operador em eax
	mov ebx, [a]		;primeiro número em ebx
	mov ecx, [b]		;segundo número em ecx
	
	;;seleção da operação
	cmp eax, '+'
	je adicao
	cmp eax, '-'
	je subtracao
	cmp eax, '*'
	je multiplicacao
	cmp eax, '/'
	je divisao

leitura:
	xor ecx, ecx
	mov eax, 3
	mov ebx, 0
	mov ecx, in
	mov edx, in_len
	int 0x80
	ret

parse:	
	dec eax			;ajusta o tamanho da string por causa do \n
	mov ebx, eax		;ebx, edi contém o tamanho exato
	mov edi, eax		
	mov ecx, 1		;ecx conta em que casa decimal está (1, 10, 100...)
	xor edx, edx
	call loop
	ret

loop:
	dec ebx			;ebx contém o índice [i] da string correto a ser acessado
	xor eax, eax		;limpa o reg eax
	mov al, [in + ebx]	;acessa a posição do char na string
	sub eax, '0'		;conversão de string pra int
	imul eax, ecx		;parte aritmética da conversão
	add edx, eax	
	imul ecx, 10		;sobe a casa decimal (unidade->dezena->centena->milhar etc)
	dec edi			;decrementa edi		
	cmp edi, 0		;edi=0 indica que recebeu todos os números, caso contrário ainda falta
	jne loop	
	ret

int_tostr:			;passa de inteiro para string
		
	xor ebx, ebx
	xor edi, edi
	
	conversao1:
		mov ecx, 10	;divisor para 10
		xor edx, edx
		idiv ecx	; resto está em edx, resultado em eax
		push edx        ; insere o resto na pilha
        	inc edi         ; incrementando o contador em 1
        	cmp eax, 0      ; enquanto eax!=0 continua o loop
       		jne conversao1	
	
        conversao2:     	        	
		xor eax, eax		; zera o reg
                pop eax                	; pop da pilha e joga em eax
                add eax, '0'            ; converte para char
                mov [resp], eax   	; imprimindo o char     	
                mov eax, 4
                mov ebx, 0			
                mov ecx, resp
                mov edx, resplen		
                int 0x80
                dec edi                 ; decrementando o contador em 1
                cmp edi, 0              ; mantém o laço até edi=0
                jne conversao2
ret

subtracao:
	call printresultado		;printa a string "Resultado: "
	mov eax, [a]
	mov ebx, [b]
	sub eax, ebx
	call int_tostr			;printa o que tiver em eax
	call printbarran		;dá um \n
	jmp final			;encerra

adicao:
	call printresultado
	mov eax, [a]
	mov ebx, [b]
	add eax, ebx
	call int_tostr
	call printbarran
	jmp final

multiplicacao:
	call printresultado
	mov eax, [a]
	mov ebx, [b]
	imul eax, ebx
	call int_tostr
	call printbarran
	jmp final

divisao:
	call printresultado
	xor edx,edx	
	mov eax, [a]
	mov ecx, [b]	
	idiv ecx
	mov [a], edx
	call int_tostr
	call printbarran

	call printresto		;printa a string "Resultado: "
	mov eax, [a]
	call int_tostr		;printa o que tiver em eax
	call printbarran	;dá um \n
	jmp final		;encerra

printresultado:	
	mov eax, 4
	mov ebx, 1
	mov ecx, resultado
	mov edx, resultlen	
	int 0x80
	ret

printresto:
	mov eax, 4
	mov ebx, 1
	mov ecx, resto
	mov edx, restolen
	int 0x80
	ret

printbarran:
	mov eax, 4
	mov ebx, 1
	mov ecx, barran
	mov edx, 2
	int 0x80
	ret

final:
	mov eax,1
	mov ebx,0
	int 0X80
