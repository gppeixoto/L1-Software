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
	
	cmp al, 8 ;verifica backspace
	je backspace

	cmp al, 13 ;verifica enter
	je enter

	cmp al,17 ;verifica fim do programa
	je fim

	jmp loop
	

backspace:
	mov al, 32
	mov ah, 0Eh
	int 10h

	mov al, 8
	mov ah, 0Eh
	int 10h
	
	jmp loop
	
enter:
	mov al, 10
	mov ah, 0Eh
	int 10h
	
	mov al, 13
	mov ah, 0Eh
	int 10h

	jmp loop


fim: ;loop para printar a string de fim do programa

	mov al,[msg+bx] ;
	mov ah,0Eh
	int 10h
	inc bx
	cmp bx,msgL
	jne fim
	


times 510-($-$$) db 0		; preenche o resto do setor com zeros 
dw 0xaa55					; coloca a assinatura de boot no final
							; do setor (x86 : little endian)

;seu código pode ter, no máximo, 512 bytes, do org ao dw 0xaa55
