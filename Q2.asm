SECTION .data

pars:db'Par', 10
impars:db'Impar', 10

SECTION .bss

num: resb 4

SECTION .text

	global _start

_start:

mov eax,3
mov ebx,0
mov ecx,num
mov edx,4
int 0X80

dec eax
dec eax
	
mov edx, [num+eax]
sub edx,'0'
and edx, 1
jnz impar
jz par

par:
	mov eax,4
	mov ebx,1
	mov ecx,pars
	mov edx,4
	int 0X80
	jmp final

impar:
	mov eax,4
	mov ebx,1
	mov ecx,impars
	mov edx,6
	int 0X80		
	jmp final

final:
	mov eax,1
	mov ebx,0
	int 0X80
