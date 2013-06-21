org 0x7c00

jmp 0x0000:start

cor db'BlackBlueGreenCyanRedMagentaBrownLightGrayDarkGrayLightBlueLightGreenLightCyanLightRed'
tam db'!&*/36=BKS\fow'
cor2 db'LightMagentaYellowWhite'
tam2 db'!-38'

start:		

xor ax, ax
mov ds, ax

xor ax, ax
mov ds, ax

xor ch,ch
xor dh,dh

ler1:
mov ah,0h
int 16h
mov ah, 0Eh
int 10h

xor ah, ah
mov cx, ax

sub cx,'0'

cmp cx, 9
jg ehhexa1
jmp ler2

ehhexa1:
	sub cx, 7
	jmp ler2

ler2:
mov ah,0h
int 16h
mov ah, 0Eh
int 10h

xor ah, ah
mov dx, ax

sub dx,'0'
cmp dx, 9
jg ehhexa2
jmp indice_string1

ehhexa2:
	sub dx, 7
	
indice_string1:
	push cx
	push dx
	cmp cx,dx
	je fim

	cmp cx,12
	jg indice_print1_string2
	
	mov al, byte[tam+ecx]
	sub al,'!'
	mov si, ax
	
	mov bl, byte[tam+ecx+1]
	sub bl, '!' 
	mov di, bx
	
	mov bx, cx  ;cor: backgroundFonte
	imul bx, 16
	add bx, dx
	
	jmp print1_string1
	
indice_string2:
	xor si, si
	xor di, di
	cmp dx, 12
	jg indice_print2_string2
	
	
	xor ah,ah
	mov al, byte[tam+edx]
	sub al, '!'
	mov si, ax
	
	xor bh,bh
	mov bl, byte[tam+edx+1]
	sub bl, '!'
	mov di, bx
	
	pop dx
	pop cx
	mov bx, cx  ;cor: backgroundFonte
	imul bx, 16
	add bx, dx
	
	jmp print2_string1	
	
indice_print2_string2:
	mov si, dx
	sub si, 13
	
	xor ah,ah
	mov al, byte[tam2+esi]
	sub al, '!'
	
	
	xor bh,bh
	mov bl, byte[tam2+esi+1]
	sub bl, '!'
	mov edi, ebx
	mov si, ax
	
	pop dx
	pop cx
	mov bx, cx  ;cor: backgroundFonte
	imul bx, 16
	add bx, dx
	
	jmp print2_string2
	
indice_print1_string2:
	sub ecx, 13
	mov al, byte[tam2+ecx]
	sub al, '!'
	mov si, ax
	
	mov bl, byte[tam2+ecx+1]
	sub bl, '!'
	mov di, bx
	
	add cx, 13
	mov bx, cx
	imul bx, 16
	add bx, dx
	
	jmp print1_string2

print1_string2:
	cmp si, di
	je ecomm
	
	xor bh,bh
	mov ah, 09h
	mov cx, 1
	int 10h
	
	mov al, byte[cor2+si]
	mov ah, 0Eh
	int 10h
	
	inc si
	jmp print1_string2		
	
	
print2_string1:
	cmp si, di
	je loopzar
	
	xor bh,bh
	mov ah, 09h
	mov cx, 1
	int 10h
	
	mov al, byte[cor+si]
	mov ah, 0Eh
	int 10h
	
	inc si
	jmp print2_string1
	
print2_string2:
	cmp si, di
	je loopzar
	
	xor bh,bh
	mov ah, 09h
	mov cx, 1
	int 10h
	
	mov al, byte[cor2+si]
	mov ah, 0Eh
	int 10h
	
	inc si
	jmp print2_string2
	
	
print1_string1:
	
	cmp si, di
	je ecomm
	
	xor bh,bh
	mov ah, 09h ; tem que ter	
	mov cx, 1 ;numero caracteres pra printar
	int 10h

	mov al, byte[cor+si]
	mov ah, 0Eh
	int 10h		
	
	inc si
	jmp print1_string1
	
	
ecomm:
	xor bh,bh
	mov ah, 09h
	mov cx, 1
	int 10h
	
	mov al, '&'
	mov ah, 0Eh
	int 10h
	jmp indice_string2
	
loopzar:
	mov al, 10
	mov ah, 0Eh
	int 10h
	
	mov al, 13
	mov ah, 0Eh
	int 10h
	jmp start
	
fim:

times 510-($-$$) db 0
dw 0xaa55

;seu código pode ter, no máximo, 512 bytes, do org ao dw 0xaa55
