;org endereço -> ajusta todas as suas referencias à endereços. NAO RETIRAR.
org 0x7c00 

;no modo real não há sections, o código começa a ser executado no começo do arquivo
;só estão disponíveis os registradores de 16bits.

jmp 0x0000:start ;mais sobre segment:offset na aula do projeto do bootloader.

msg db " (Programa encerrado com sucesso!)"
	msgL equ $-msg


start:

	; nunca se esqueca de zerar o ds,
	; pois apartir dele que o processador busca os 
	; dados utilizados no programa.
	xor ax, ax
	mov ds, ax

	;Início do seu código


	xor cx,cx
	xor si,si
	xor bx,bx

loop:
	mov ah,0h
	int 16h
	
	mov ah,0Eh
	int 10h
	
	push ax

	cmp al, 13 ;verifica enter
	je enter

	inc si
	jmp loop
	
enter:

	mov al, 10
	mov ah, 0Eh
	int 10h
	
	mov al, 13
	mov ah, 0Eh
	int 10h
	
	jmp fim

fim:
	
	pop ax
	mov ah,0Eh
	int 10h	

	dec si
	cmp si,0
	je acabou

	jmp fim

acabou:

	pop ax
	mov ah,0Eh
	int 10h

times 510-($-$$) db 0		; preenche o resto do setor com zeros 
dw 0xaa55					; coloca a assinatura de boot no final
							; do setor (x86 : little endian)

;seu código pode ter, no máximo, 512 bytes, do org ao dw 0xaa55
