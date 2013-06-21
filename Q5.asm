sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4

stdin           equ     0
stdout          equ     1
stderr          equ     3

SECTION .data
	primo:		db'Primo',10
	naoprimo: 	db'Nao primo',10

SECTION .bss
	in: 	resb 5
	in_len: equ $-in
	num:	resb 5
	numlen:	equ $-num

SECTION .text

global _start

_start:
	call leitura
	call parse	;string->int
	cmp edx, 1	;1 nao eh primo por definicao
	je print2	
	mov esi, edx	;salva o numero na memoria
	call clean	;limpa todos os regs
	mov edi, 2	;contador auxiliar a ser usado no teste de primalidade
	jmp verify	;metodo que verifica primalidade

verify:
	mov ecx, edi	;contador vai para ecx
	imul ecx, ecx	;elevo o contador ao quadrado (i2)
	cmp ecx, esi	;se i2 for igual ao numero, o numero nao eh primo. Se for maior, ele é primo
	je print2
	jg print1		
	jl verify2	;se i2 for menor que o numero, pula pra parte2 do teste de primalidade

verify2:
	mov eax, esi	;numero esta em eax
	xor edx, edx	;limpo o edx
	idiv edi	;divisao EAX/EDI, resto vai pra edx
	cmp edx, 0	;se o resto for 0, nao é primo
	je print2
	inc edi		;se resto!=0, incremento o contador e reinicio a verificao
	jmp verify

clean:			;limpa todos os regs
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor edi, edi
	ret

leitura:
	mov eax, sys_read
	mov ebx, stdin
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
	add edx, eax		;edx contém o int convertido no final
	imul ecx, 10		;sobe a casa decimal (unidade->dezena->centena->milhar etc)
	dec edi			;decrementa edi		
	cmp edi, 0		;edi=0 indica que recebeu todos os números, caso contrário ainda falta
	jne loop	
	ret

print1:				;print do numero primo
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, primo
	mov edx, 6
	int 0x80
	jmp final

print2:				;print do numero nao primo
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, naoprimo
	mov edx, 10
	int 0x80
	jmp final

final:
	mov eax, 1
	mov ebx, 0
	int 0x80
