title "TAREA CUATRO"
	.model small
	.386
	.stack 64

	.data

	;macros
	init macro
		mov ax,@data 		;AX = directiva @data
		mov ds,ax 			;DS = AX, inicializa registro de segmento de datos
	endm

	finish macro
		mov ax , 4C00h
		int 21h
	endm

	;menu principal
	menu db "  B I E N V E N I D O", 0Dh, 0Ah, "$"
	menu3 db "(1) RELOJ", 0Dh, 0Ah, "$"
	menu4 db "(2) FECHA", 0Dh, 0Ah, "$"
	menu5 db "(3) CRONOMETRO", 0Dh, 0Ah, "$"
	menu6 db "(4) SALIR", 0Dh, 0Ah, "$"
	nombre1 db "ESPARZA FUENTES JORGE LUIS", 0Dh, 0Ah, "$"
	nombre2 db "MORA GONZALEZ ALAN FRANCISCO", 0Dh, 0Ah, "$"

	;RELOJ
	reloj db "LA HORA ACTUAL ES: ", 0Dh, 0Ah, "$"
	time db "00:00:00 HRS", 0Dh, 0Ah, "$"

	;Fecha
	fecha db "LA FECHA ACTUAL ES: ", 0Dh, 0Ah, "$"
	total db "00/00/00", 0Dh, 0Ah, "$"

	;Cronometro
	ms dw 0h
	s db 0h
	m db 0h
	h db 0h
	i dw 0h

	saltoLinea 	db	0Dh , 0Ah , "$"

	tituloCronometro db "CRONOMETRO: ", 0Dh, 0Ah, "$"
	Q1Cronometro db "EN CONTEO EL CRONOMETRO: ", 0Dh, 0Ah, "$"
	Q2Cronometro db "EN PAUSA EL CRONOMETRO: ", 0Dh, 0Ah, "$"
	cronometro db "00:00:00.00", 0Dh, 0Ah, "$"
	iniciar db "(1) PLAY", 0Dh, 0Ah, "$"
	detener db "(2) PAUSA", 0Dh, 0Ah, "$"
	reiniciar db "(3) RESET", 0Dh, 0Ah, "$"
	regresar db "(4) SALIR AL MENU", 0Dh, 0Ah, "$"

	;otras
	tecla db "PRESIONA CUALQUIER TECLA PARA REGRESAR...", 0Dh, 0Ah, "$"
	menu2 db "SELECCIONA UNA OPCION: ", 0Dh, 0Ah, "$"
	tmp db "aqui va un proc", 0Dh, 0Ah, "$"
	aux db ?


	.code
main:
	init

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
		mov [ms] , 0h
		mov [s] , 0h
		mov [m] , 0h
		mov [h] , 0h
		mov [i] , 0h

		;TITULO 
		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 1				;1 CUADROS HACIA ABAJO
		mov dl, 32				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
		lea dx, tituloCronometro
		int 21h


		;Cronometro como tal
		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 2				;3 CUADROS HACIA ABAJO
		mov dl, 47				;45 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
		lea dx, cronometro
		int 21h


		;Menu
		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 4				;3 CUADROS HACIA ABAJO
		mov dl, 30				;45 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
		lea dx, menu2
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 5				;3 CUADROS HACIA ABAJO
		mov dl, 30				;45 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
		lea dx, iniciar
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 6				;3 CUADROS HACIA ABAJO
		mov dl, 30				;45 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
		lea dx, regresar
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 7				;7 CUADROS HACIA ABAJO
		mov dl, 0				;0 CUADROS HACIA LA DERECHA
		mov ah, 08
		int 21h

		cmp al,49				;49 = 1d
		je loop1

		cmp al, 52				;52 = 4d
		je limpiar			;pendiente: limpiar

		loop1:
			mov ah, 02h				;POSICIONA EL CURSOR EN:
			mov bh, 00d
			mov dh, 2				;3 CUADROS HACIA ABAJO
			mov dl, 45				;45 CUADROS HACIA LA DERECHA
			int 10h

			mov dx , [ i ]	;dx = i
			or dl , 30h		;i - 30h
			mov ah,02h
			int 21h

			;lea dx , [ saltoLinea ]		
			;mov ax , 0900h		
			;int 21h		
			
			inc [ i ]


			;Menu
			mov ah, 02h				;POSICIONA EL CURSOR EN:
			mov bh, 00d
			mov dh, 4				;3 CUADROS HACIA ABAJO
			mov dl, 30				;45 CUADROS HACIA LA DERECHA
			int 10h

			mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
			lea dx, menu2
			int 21h

			mov ah, 02h				;POSICIONA EL CURSOR EN:
			mov bh, 00d
			mov dh, 5				;3 CUADROS HACIA ABAJO
			mov dl, 30				;45 CUADROS HACIA LA DERECHA
			int 10h

			mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
			lea dx, detener
			int 21h

			mov ah, 02h				;POSICIONA EL CURSOR EN:
			mov bh, 00d
			mov dh, 6				;3 CUADROS HACIA ABAJO
			mov dl, 30				;45 CUADROS HACIA LA DERECHA
			int 10h

			mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
			lea dx, reiniciar
			int 21h

			mov ah, 02h				;POSICIONA EL CURSOR EN:
			mov bh, 00d
			mov dh, 7				;3 CUADROS HACIA ABAJO
			mov dl, 30				;45 CUADROS HACIA LA DERECHA
			int 10h

			mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
			lea dx, regresar
			int 21h

			mov ah, 1				;SENTENCIA QUE ESTA EN CONSTANTE FUNCIONAMIENTO Y SERÁ INTERRUMPIDA
			int 16h					;HASTA OBTENER UN CARACTER DE TECLADO
			jz loop1 				;CICLO QUE SE loop1
		
			mov ah, 08				;INTERRUPCION PARA QUE EL USUARIO ESCRIBA UN CARACTER
			int 21h

			cmp al, 50				;50 = 2d
			je auxiliar

			cmp al, 51				;51 = 3d
			je imprimeCronometro

			cmp al, 52				;52 = 4d
			je limpiar			;pendiente: limpiar

			mov [aux], al
			jmp limpiar

		auxiliar:
			jmp pausaloop

		pausaloop:
			;Cronometro como tal
			mov ah, 02h				;POSICIONA EL CURSOR EN:
			mov bh, 00d
			mov dh, 2				;3 CUADROS HACIA ABAJO
			mov dl, 47				;45 CUADROS HACIA LA DERECHA
			int 10h

			mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
			lea dx, cronometro
			int 21h


			;Menu
			mov ah, 02h				;POSICIONA EL CURSOR EN:
			mov bh, 00d
			mov dh, 4				;3 CUADROS HACIA ABAJO
			mov dl, 30				;45 CUADROS HACIA LA DERECHA
			int 10h

			mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
			lea dx, menu2
			int 21h

			mov ah, 02h				;POSICIONA EL CURSOR EN:
			mov bh, 00d
			mov dh, 5				;3 CUADROS HACIA ABAJO
			mov dl, 30				;45 CUADROS HACIA LA DERECHA
			int 10h

			mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
			lea dx, iniciar
			int 21h

			mov ah, 02h				;POSICIONA EL CURSOR EN:
			mov bh, 00d
			mov dh, 6				;3 CUADROS HACIA ABAJO
			mov dl, 30				;45 CUADROS HACIA LA DERECHA
			int 10h

			mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
			lea dx, reiniciar
			int 21h

			mov ah, 02h				;POSICIONA EL CURSOR EN:
			mov bh, 00d
			mov dh, 7				;3 CUADROS HACIA ABAJO
			mov dl, 30				;45 CUADROS HACIA LA DERECHA
			int 10h

			mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
			lea dx, regresar
			int 21h

			cmp al, 49				;49 = 1d
			je loop1

			cmp al, 51				;51 = 3d
			je imprimeCronometro

			cmp al, 52				;52 = 4d
			je limpiar			;pendiente: limpiar 
		
	
	;extra
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
	

	;Procedimientos del reloj
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
	
	;Procemientos del cronometro
;	Play proc
;		;Procedimiento que sirve para iniciar el cronometro
;		lea dx , tmp
;		int 21
;	Play endp
;		
;	Pausa proc
;		;Procedimiento que sirve para pausar el cronometro
;		lea dx , tmp
;		int 21
;	Pausa endp
;	
;	Reset proc
;		;Procedimiento que sirve para reiniciar el cronometro
;		lea dx , tmp
;		int 21
;	Reset endp
;	
;	Exit proc
;		;Procedimiento que sirve para regresar al menu principal
;		lea dx , tmp
;		int 21
;	Exit endp

	;Pausa

	
salir:
	mov ax, 0600h			;LLAMADA A LA FUNCIÓN
	mov bh, 07h				;COLOR DE FONDO Y LETRA
	mov cx, 0000h			;COORDENADAS INICIO
	mov dx, 184Fh			;COORDENADAS DE FIN 
	int 10h

	finish

	end main