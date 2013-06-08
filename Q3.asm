SECTION .data

SECTION .bss

string: resb 20

SECTION .text

	global _start

_start:

mov eax,3
mov ebx,0
mov ecx,string
mov edx,21
int 0X80

mov edi,1
print:

	mov eax,4
	mov ebx,1	
	int 0X80

	inc edi
	cmp byte[ecx+edi],0
	jnz print
	jz final

final:
	mov eax,1
	mov ebx,0
	int 0X80
