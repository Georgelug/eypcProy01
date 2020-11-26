title "TAREA CUATRO"
	.model small
	.386
	.stack 64

	.data
menu db "  B I E N V E N I D O", 0Dh, 0Ah, "$"
menu2 db "SELECCIONA UNA OPCION: ", 0Dh, 0Ah, "$"
menu3 db "(1) RELOJ", 0Dh, 0Ah, "$"
menu4 db "(2) CRONOMETRO", 0Dh, 0Ah, "$"
menu5 db "(3) SALIR", 0Dh, 0Ah, "$"
reloj db "LA HORA ACTUAL ES: ", 0Dh, 0Ah, "$"
time db '00:00:00$'
cronometro db "CRONOMETRO: ", 0Dh, 0Ah, "$"
tecla db "PRESIONA CUALQUIER TECLA PARA REGRESAR...", 0Dh, 0Ah, "$"

exCode db 0

	.code
main:
	mov ax, @data
	mov ds, ax

limpiar:
	mov ax, 0600h	;LLAMADA A LA FUNCIÓN
	mov bh, 07h		;COLOR DE FONDO Y LETRA
	mov cx, 0000h	;COORDENADAS INICIO
	mov dx, 184Fh	;COORDENADAS DE FIN 
	int 10h

colorear:
	mov ax, 0600h	;LLAMADA A LA FUNCIÓN
	mov bh, 01001111b ;COLOR DE FONDO Y LETRA
	mov ch, 0		;PUNTO INICIAL HACIA ABAJO
	mov cl, 0		;PUNTO INICIAL HACIA LA DERECHA
	mov dh, 25		;PUNTO FINAL HACIA ABAJO
	mov dl, 25		;PUNTO FINAL HACIA LA DERECHA
	int 10h

	mov ax, 0600h
	mov bh, 00001110b
	mov ch, 0
	mov cl, 27
	mov dh, 25
	mov dl, 79
	int 10h

imprimeMenu:
	mov ah, 02h		;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 1		;1 CUADRO HACIA ABAJO
	mov dl, 1		;1 CUADRO HACIA LA DERECHA
	int 10h

	mov ah, 09h
	lea dx, menu
	int 21h

	mov ah, 09h
	lea dx, menu2
	int 21h

	mov ah, 09h
	lea dx, menu3
	int 21h

	mov ah, 09h
	lea dx, menu4
	int 21h

	mov ah, 09h
	lea dx, menu5
	int 21h

leeTeclado:	
	mov ah, 08
	int 21h

	cmp al,49
	je imprimeReloj

	cmp al, 50
	je imprimeCronometro

	cmp al, 51
	je salir

imprimeReloj:
	mov ah, 02h
	mov bh, 00d
	mov dh, 1
	mov dl, 28
	int 10h

	mov ah, 09h
	lea dx, reloj
	int 21h

	repite:
	lea bx, time
	call gettime
	
	mov ah, 02h
	mov bh, 00d
	mov dh, 3
	mov dl, 38
	int 10h

	mov ah, 09h
	lea dx, time
	int 21h

	mov ah, 1
	int 16h
	jz repite

	mov ah, 02h
	mov bh, 00d
	mov dh, 10
	mov dl, 28
	int 10h

	mov ah, 09h
	lea dx, tecla
	int 21h

	mov ah, 08
	int 21h
	mov ah, 02h		;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 8		;8 CUADROS HACIA ABAJO
	mov dl, 28		;28 CUADROS HACIA LA DERECHA
	int 10h
	jmp limpiar

imprimeCronometro:
	mov ah, 02h
	mov bh, 00d
	mov dh, 1
	mov dl, 28
	int 10h

	mov ah, 09h
	lea dx, cronometro 
	int 21h

	mov ah, 02h
	mov bh, 00d
	mov dh, 7
	mov dl, 28
	int 10h

	mov ah, 09h
	lea dx, tecla
	int 21h

	mov ah, 08
	int 21h
	mov ah, 02h		;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 8		;8 CUADRO HACIA ABAJO
	mov dl, 28		;28 CUADRO HACIA LA DERECHA
	int 10h
	jmp limpiar

gettime proc
	push ax
	push cx

	mov ah, 2ch
	int 21h

	mov al, ch
	call convert
	mov [bx], ax

	mov al, cl
	call convert
	mov [bx+3], ax 

	mov al, dh 
	call convert
	mov [bx+6], ax

	pop cx
	pop ax

	ret
gettime endp

convert proc
	push dx

	mov ah, 0
	mov dl, 10
	div dl
	or ax, 3030h

	pop dx
	ret
convert endp

salir:
	mov ax, 0600h	;LLAMADA A LA FUNCIÓN
	mov bh, 07h		;COLOR DE FONDO Y LETRA
	mov cx, 0000h	;COORDENADAS INICIO
	mov dx, 184Fh	;COORDENADAS DE FIN 
	int 10h

	mov ah,4Ch
	mov al,[exCode]

	int 21h
	end main