sys_exit        equ     1
sys_read        equ     3
sys_write       equ     4

stdin           equ     0
stdout          equ     1
stderr          equ     3

SECTION .data

aquarios:db'Aquario', 10		
capricornios:db'Capricornio', 10
peixess:db'Peixes', 10
ariess:db'aries',10
touros:db'Touro',10
gemeoss:db'Gemeos', 10
cancers:db'Cancer', 10
leaos:db'Leao', 10
virgems:db'Virgem', 10
libras:db'Libra', 10
escorpiaos:db'Escorpiao', 10
sagitarios:db'Sagitario', 10



SECTION .bss
	str: resb 21		;string a ser lida
	strlen: equ $-str	;tamanho da string

SECTION .text

global _start

_start:
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

parse:
	dec ebx			;decremento para acessar o índice correto
	cmp byte[str+ebx], 32	;compara se o byte atual é equivalente ao espaço ' '
	je pilhaop		;se for, terminou de encontrar um número. Logo, pula para a pilha
	xor eax, eax		;zera o acumulador
	mov al, [str + ebx]	;acessa a posição do char na string
	sub eax, '0'		;conversão de string pra int
	imul eax, ecx		;parte aritmética da conversão
	add edx, eax
	imul ecx, 10		;sobe a casa decimal (unidade->dezena->centena->milhar etc)
	dec edi			;decrementa edi		
	cmp edi, 0		;edi=0 indica que recebeu todos os números, caso contrário ainda falta
	jne parse
	je pilhaop

pilhaop:
	push edx		;coloca o número no topo da pilha
	mov ecx, 1		;reseta o contador das casas decimas
	xor edx, edx		;reseta os regs eax, edx
	xor eax, eax		
	dec edi		
	cmp edi, 0		;se edi=0 chegou ao fim da leitura, senão, ainda há números
	jg parse
	jl inteirosnapilha

inteirosnapilha:
	pop eax		;primeiro inteiro está no eax (dia)
	pop ebx		;segundo inteiro está no ebx (mes)

	cmp ebx,01
	je janeiro
	
	cmp ebx, 02
	je fevereiro

	cmp ebx, 03
	je marco
	
	cmp ebx, 04
	je abril
	
	cmp ebx, 05
	je maio

	cmp ebx, 06
	je junho

	cmp ebx, 07
	je julho

	cmp ebx, 08
	je agosto

	cmp ebx, 09
	je setembro

	cmp ebx, 10
	je outubro

	cmp ebx, 11
	je novembro

	cmp ebx, 12
	je dezembro


janeiro:
	cmp eax,20
	jg aquario
	jmp capricornio

fevereiro:
	cmp eax, 19
	jg peixes
	jmp aquario

marco:
	cmp eax, 20
	jg aries
	jmp peixes

abril:
	cmp eax, 20
	jg touro
	jmp aries

maio:
	cmp eax, 20
	jg gemeos
	jmp touro

junho:
	cmp eax, 20
	jg cancer
	jmp gemeos

julho:
	cmp eax, 20
	jg leao
	jmp cancer

agosto:
	cmp eax, 22
	jg virgem
	jmp leao

setembro:
	cmp eax, 22
	jg libra
	jmp virgem

outubro:
	cmp eax, 22
	jg escorpiao
	jmp libra

novembro:
	cmp eax, 21
	jg sagitario
	jmp escorpiao

dezembro:
	cmp eax, 20
	jg capricornio
	jmp sagitario

peixes: 
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,peixess
	mov edx,7
	int 0X80
	jmp final

aries: 
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,ariess
	mov edx,6
	int 0X80
	jmp final

touro: 
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,touros
	mov edx,6
	int 0X80
	jmp final

gemeos: 
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,gemeoss
	mov edx,7
	int 0X80
	jmp final

escorpiao: 
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,escorpiaos
	mov edx,10
	int 0X80
	jmp final

sagitario: 
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,sagitarios
	mov edx,10
	int 0X80
	jmp final

libra: 
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,libras
	mov edx,6
	int 0X80
	jmp final

virgem: 
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,virgems
	mov edx,7
	int 0X80
	jmp final

leao: 
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,leaos
	mov edx,5
	int 0X80
	jmp final

cancer: 
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,cancers
	mov edx,7
	int 0X80
	jmp final

aquario: 
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,aquarios
	mov edx,8
	int 0X80
	jmp final

capricornio: 
	mov eax,sys_write
	mov ebx,stdout
	mov ecx,capricornios
	mov edx,12
	int 0X80
	jmp final	
	

final:
	mov eax,1
	mov ebx,0
	int 0X80
