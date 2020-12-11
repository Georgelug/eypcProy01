title "TAREA CUATRO"
	.model small
	.386
	.stack 64

	.data
menu db "  B I E N V E N I D O", 0Dh, 0Ah, "$"
menu2 db "SELECCIONA UNA OPCION: ", 0Dh, 0Ah, "$"
menu3 db "(1) RELOJ", 0Dh, 0Ah, "$"
menu4 db "(2) FECHA", 0Dh, 0Ah, "$"
menu5 db "(3) CRONOMETRO", 0Dh, 0Ah, "$"
menu6 db "(4) SALIR", 0Dh, 0Ah, "$"
nombre1 db "ESPARZA FUENTES JORGE LUIS", 0Dh, 0Ah, "$"
nombre2 db "MORA GONZALEZ ALAN FRANCISCO", 0Dh, 0Ah, "$"
reloj db "LA HORA ACTUAL ES: ", 0Dh, 0Ah, "$"
time db "00:00:00 HRS", 0Dh, 0Ah, "$"
fecha db "LA FECHA ACTUAL ES: ", 0Dh, 0Ah, "$"
total db "00/00/00", 0Dh, 0Ah, "$"
cronometro db "CRONOMETRO: ", 0Dh, 0Ah, "$"
tecla db "PRESIONA CUALQUIER TECLA PARA REGRESAR...", 0Dh, 0Ah, "$"

exCode db 0

	.code
main:
	mov ax, @data
	mov ds, ax

limpiar:
	mov ax, 0600h			;LLAMADA A LA FUNCIÓN
	mov bh, 07h				;COLOR DE FONDO Y LETRA
	mov cx, 0000h			;COORDENADAS INICIO
	mov dx, 184Fh			;COORDENADAS DE FIN 
	int 10h

colorear:
	mov ax, 0600h			;LLAMADA A LA FUNCIÓN
	mov bh, 01001111b 		;COLOR DE FONDO Y LETRA
	mov ch, 0				;PUNTO INICIAL HACIA ABAJO
	mov cl, 0				;PUNTO INICIAL HACIA LA DERECHA
	mov dh, 25				;PUNTO FINAL HACIA ABAJO
	mov dl, 28				;PUNTO FINAL HACIA LA DERECHA
	int 10h

	mov ax, 0600h			;LLAMADA A LA FUNCIÓN
	mov bh, 00001110b 		;COLOR DE FONDO Y LETRA
	mov ch, 0				;PUNTO INICIAL HACIA ABAJO
	mov cl, 29				;PUNTO INICIAL HACIA LA DERECHA
	mov dh, 25				;PUNTO FINAL HACIA ABAJO
	mov dl, 79				;PUNTO FINAL HACIA LA DERECHA
	int 10h

imprimeMenu:
	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 1				;1 CUADRO HACIA ABAJO
	mov dl, 1				;1 CUADRO HACIA LA DERECHA
	int 10h

	mov ah, 09h				;COMIENZA A IMPRIMIR EN PANTALLA EL MENÚ
	lea dx, menu
	int 21h

	lea dx, menu2
	int 21h

	lea dx, menu3
	int 21h

	lea dx, menu4
	int 21h

	lea dx, menu5
	int 21h

	lea dx, menu6
	int 21h

	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 10				;10 CUADROS HACIA ABAJO
	mov dl, 0				;0 CUADRO HACIA LA DERECHA
	int 10h

	mov ah, 09h				;COMIENZA A IMPRIMIR LOS NOMBRES
	lea dx, nombre1
	int 21h

	lea dx, nombre2
	int 21h

leeTeclado:	
	;esto es usable
	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 7				;7 CUADROS HACIA ABAJO
	mov dl, 0				;0 CUADROS HACIA LA DERECHA
	mov ah, 08
	int 21h

	cmp al,49				;49 = 1d
	je imprimeReloj

	cmp al, 50				;50 = 2d
	je imprimeFecha

	cmp al, 51				;51 = 3d
	je imprimeCronometro

	cmp al, 52				;52 = 4d
	je salir

imprimeReloj:
	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 1				;1 CUADRO HACIA ABAJO
	mov dl, 30				;30 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
	lea dx, reloj
	int 21h

	repite:					;CICLO INFINITO QUE VA A REPETIRSE HASTA RECIBIR UNA TECLA
	lea bx, time			;OBTENEMOS LA HORA GUARDANDOLA EN BX 
	call gettime			;LLAMAMOS A LA FUNCIÓN gettime
	
	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 2				;3 CUADROS HACIA ABAJO
	mov dl, 45				;45 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME LA HORA EN CONSOLA
	lea dx, time
	int 21h

	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 6				;6 CUADROS HACIA ABAJO
	mov dl, 30				;30 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN tecla
	lea dx, tecla
	int 21h

	mov ah, 1				;SENTENCIA QUE ESTA EN CONSTANTE FUNCIONAMIENTO Y SERÁ INTERRUMPIDA
	int 16h					;HASTA OBTENER UN CARACTER DE TECLADO
	jz repite 				;CICLO QUE SE REPITE

	mov ah, 08				;INTERRUPCION PARA QUE EL USUARIO ESCRIBA UN CARACTER
	int 21h

	jmp limpiar				;HACE UN SALTO HACIA LA ETIQUETA limpiar

imprimeCronometro:
	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 1				;1 CUADRO HACIA ABAJO
	mov dl, 30				;30 CUADROS HACIA LA DERECHA
	int 10h
	lea dx, cronometro 
	int 21h

	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 7				;7 CUADROS HACIA ABAJO
	mov dl, 30				;30 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN tecla
	lea dx, tecla
	int 21h

	mov ah, 08				;INTERRUPCION PARA QUE EL USUARIO ESCRIBA UN CARACTER
	int 21h

	jmp limpiar				;HACE UN SALTO HACIA LA ETIQUETA limpiar

imprimeFecha:
	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 1				;1 CUADRO HACIA ABAJO
	mov dl, 30				;30 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN fecha
	lea dx, fecha
	int 21h

	mov ah, 2Ah
	int 21h

	lea bx, total			;OBTENEMOS LA HORA GUARDANDOLA EN BX 
	call gettime			;LLAMAMOS A LA FUNCIÓN gettime
	
	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 2				;3 CUADROS HACIA ABAJO
	mov dl, 45				;45 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME LA HORA EN CONSOLA
	lea dx, total
	int 21h

	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 7				;7 CUADROS HACIA ABAJO
	mov dl, 30				;30 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN tecla
	lea dx, tecla
	int 21h

	mov ah, 08				;INTERRUPCION PARA QUE EL USUARIO ESCRIBA UN CARACTER
	int 21h

	jmp limpiar				;HACE UN SALTO HACIA LA ETIQUETA limpiar

gettime proc				;INICIO DE LA FUNCION gettime
	push ax					;LO QUE CONTIENE ax SE GUARDA EN LA PILA
	push cx					;LO QUE CONTIENE bx SE GUARDA EN LA PILA

	mov ah, 2ch
	int 21h

	mov al, ch
	call convert			;LLAMADA A LA FUNCION convert
	mov [bx], ax			;SE CONVIERTEN LAS HORAS

	mov al, cl
	call convert 			;LLAMADA A LA FUNCION convert
	mov [bx+3], ax 			;SE CONVIERTEN LOS MINUTOS

	mov al, dh 				
	call convert 			;LLAMADA A LA FUNCION convert
	mov [bx+6], ax 			;SE CONVIERTEN LOS SEGUNDOS

	pop cx 					;SACAMOS DE LA PILA cx
	pop ax					;SACAMOS DE LA PILA ax

	ret 					;RETORNAMOS LOS VALORES OBTENIDOS
gettime endp

convert proc 				;INICIO DE LA FUNCION convert
	push dx 				;LO QUE CONTIENE dx SE GUARDA EN LA PILA

	mov ah, 0				;UTILIZAMOS ESTAS FUNCIONES PARA PASAR DE ASCII A DECIMAL
	mov dl, 10
	div dl
	or ax, 3030h	

	pop dx					;SACAMOS DE LA PILA dx
	ret 					;RETORNAMOS EL VALOR OBTENIDO
convert endp



salir:
	mov ax, 0600h			;LLAMADA A LA FUNCIÓN
	mov bh, 07h				;COLOR DE FONDO Y LETRA
	mov cx, 0000h			;COORDENADAS INICIO
	mov dx, 184Fh			;COORDENADAS DE FIN 
	int 10h

	mov ah,4Ch
	mov al,[exCode]

	int 21h
	end main