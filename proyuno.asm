title "PROYECTO UNO"
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
time db "00:00:00:00 HRS", 0Dh, 0Ah, "$"

fecha db "LA FECHA ACTUAL ES: ", 0Dh, 0Ah, "$"
date db "00/00/0000", 0Dh, 0Ah, "$"

cronometro db "CRONOMETRO: ", 0Dh, 0Ah, "$"
timer db "00:00:000", 0Dh, 0Ah, "$"
tiempoInicial dw 0, 0
tick_ms dw 55
mil dw 1000
cien db 100
diez db 10
sesenta db 60
contador dw 0
miliSegundos dw 0
segundos db 0
minutos db 0
iniciar db "(1) INICIAR", 0Dh, 0Ah, "$"
detener db "(2) PAUSAR", 0Dh, 0Ah, "$"
reiniciar db "(3) RESETEAR", 0Dh, 0Ah, "$"
regresar db "(4) SALIR AL MENU", 0Dh, 0Ah, "$"
borrar  db "                  ", 0Dh, 0Ah, "$"

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
	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 7				;7 CUADROS HACIA ABAJO
	mov dl, 0				;0 CUADROS HACIA LA DERECHA
	mov ah, 08
	int 21h

	cmp al, 49				;49 = 1d
	je imprimeReloj

	cmp al, 50				;50 = 2d
	je imprimeFecha

	cmp al, 51				;51 = 3d
	je imprimeCronometro

	cmp al, 52				;52 = 4d
	je salir

	jmp limpiar

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
	lea bx, time			;LA VARIABLE time ES "TRANSPORTADA" AL REGISTRO bx
	call GETTIME 			;LLAMAMOS AL PROCESO GETTIME
	
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

auxiliar:
	jmp limpiar

imprimeCronometro:
	mov dl, 20h
	mov ah, 02h
	int 21h

	lea bx, timer 			;LA VARIABLE timer ES "TRANSPORTADA" AL REGISTRO bx
	call RESET 				;SE MANDA LLAMAR EL PROCEDIMIENTO RESET PARA RESETEAR EL CRONOMETRO

	mov ah, 02h 			;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 2				;2 CUADROS HACIA ABAJO
	mov dl, 47 				;47 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h
	lea dx, borrar
	int 21h

	mov ah, 02h 			;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 6 				;6 CUADROS HACIA ABAJO
	mov dl, 30 				;30 CUADROS HACIA LA DERECHA
	int 10h

	mov ah , 09h
	lea dx, borrar
	int 21h

	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 7				;7 CUADROS HACIA ABAJO
	mov dl, 30				;30 CUADROS HACIA LA DERECHA
	int 10h

	mov ah , 09h
	lea dx, borrar
	int 21h

	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 1				;1 CUADROS HACIA ABAJO
	mov dl, 30				;30 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN cronometro 
	lea dx, cronometro
	int 21h

	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 2				;2 CUADROS HACIA ABAJO
	mov dl, 47				;47 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN timer 
	lea dx, timer 		
	int 21h

	mov ah,00h
	int 1Ah
	mov [tiempoInicial], dx 
	mov [tiempoInicial+2], cx

	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 4				;4 CUADROS HACIA ABAJO
	mov dl, 30				;30 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN menu2
	lea dx, menu2
	int 21h

	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 5				;5 CUADROS HACIA ABAJO
	mov dl, 30				;30 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN iniciar
	lea dx, iniciar
	int 21h

	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 6				;6 CUADROS HACIA ABAJO
	mov dl, 30				;30 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN regresar
	lea dx, regresar
	int 21h

	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 7				;7 CUADROS HACIA ABAJO
	mov dl, 0				;0 CUADROS HACIA LA DERECHA
	mov ah, 08
	int 21h

	cmp al,49				;49 = 1d
	je borra0

	cmp al, 52				;52 = 4d
	je auxiliar			;pendiente: limpiar

	borra0:
		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 2				;2 CUADROS HACIA ABAJO
		mov dl, 47				;47 CUADROS HACIA LA DERECHA
		int 10h

		mov ah , 09h
		lea dx, borrar
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 5				;5 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah , 09h
		lea dx, borrar
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 6				;6 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah , 09h
		lea dx, borrar
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 7				;7 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah , 09h
		lea dx, borrar
		int 21h

		jmp loop1

	loop1:
		lea bx, timer			;LA VARIABLE time ES "TRANSPORTADA" AL REGISTRO bx
		call GETTIMER 			;LLAMAMOS AL PROCESO GETTIMER
			
		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 2				;2 CUADROS HACIA ABAJO
		mov dl, 47				;47 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME LA HORA EN CONSOLA
		lea dx, timer
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 4				;4 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN menu2
		lea dx, menu2
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 5				;5 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN detener
		lea dx, detener
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 6				;6 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reiniciar
		lea dx, reiniciar
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 7				;7 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
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
		je borra1
		cmp al, 51				;51 = 3d
		je imprimeCronometro

		cmp al, 52				;52 = 4d
		je auxiliar			;pendiente: limpiar

		jmp imprimeCronometro

	borra1:
		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 2				;2 CUADROS HACIA ABAJO
		mov dl, 47				;47 CUADROS HACIA LA DERECHA
		int 10h

		mov ah , 09h
		lea dx, borrar
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 5				;5 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah , 09h
		lea dx, borrar
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 6				;6 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah , 09h
		lea dx, borrar
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 7				;7 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah , 09h
		lea dx, borrar
		int 21h

		jmp pausaloop

	pausaloop:
		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 2				;2 CUADROS HACIA ABAJO
		mov dl, 47				;47 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN cronometro
		lea dx, timer
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 4				;4 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reloj
		lea dx, menu2
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 5				;5 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN iniciar
		lea dx, iniciar
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 6				;6 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN reiniciar
		lea dx, reiniciar
		int 21h

		mov ah, 02h				;POSICIONA EL CURSOR EN:
		mov bh, 00d
		mov dh, 7				;7 CUADROS HACIA ABAJO
		mov dl, 30				;30 CUADROS HACIA LA DERECHA
		int 10h

		mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN regresar
		lea dx , regresar
		int 21h

		mov ah, 1				;SENTENCIA QUE ESTA EN CONSTANTE FUNCIONAMIENTO Y SERÁ INTERRUMPIDA
		int 16h					;HASTA OBTENER UN CARACTER DE TECLADO
		jz pausaloop 				;CICLO QUE SE loop1
		
		mov ah, 08				;INTERRUPCION PARA QUE EL USUARIO ESCRIBA UN CARACTER
		int 21h

		cmp al, 49				;49 = 1d => reanudar cronometro
		je loop1

		cmp al, 51				;51 = 3d => reiniciar cronometro
		je imprimeCronometro

		cmp al, 52				;52 = 4d => salir
		je limpiar 

		jmp limpiar

imprimeFecha:
	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 1				;1 CUADRO HACIA ABAJO
	mov dl, 30				;30 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME EL MENSAJE GUARDADO EN fecha
	lea dx, fecha
	int 21h

	lea bx, date			;LA VARIABLE date ES "TRANSPORTADA" AL REGISTRO bx
	call GETDATE			;LLAMAMOS AL PROCESO GETDATE

	mov ah, 02h				;POSICIONA EL CURSOR EN:
	mov bh, 00d
	mov dh, 2				;3 CUADROS HACIA ABAJO
	mov dl, 45				;45 CUADROS HACIA LA DERECHA
	int 10h

	mov ah, 09h				;IMPRIME LA FECHA EN CONSOLA
	lea dx, date
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

GETTIME proc				;INICIO DEL PROCESO GETTIME
	push ax					;LO QUE CONTIENE ax SE GUARDA EN LA PILA
	push cx					;LO QUE CONTIENE bx SE GUARDA EN LA PILA

	mov ah, 2Ch				;INTERRUPCION QUE SIRVE PARA OBTENER LA HORA DEL SISTEMA
	int 21h

	mov al, ch 				;GUARDAMOS EN AL EL CONTENIDO DE CH, EN ESTE CASO LAS HORAS
	call CONVERT			;LLAMAMOS AL PROCESO CONVERT
	mov [bx], ax			;SE MUEVEN LAS HORAS A LA POSICION QUE TIENE [bx]
							;EJEMPLO 10:00:00:00
	
	mov al, cl 				;GUARDAMOS EN AL EL CONTENIDO DE CL, EN ESTE CASO LOS MINUTOS
	call CONVERT  			;LLAMAMOS AL PROCESO CONVERT
	mov [bx+3], ax 			;SE MUEVEN LOS MINUTOS A LA POSICION QUE TIENE [bx+3]
							;EJEMPLO 10:51:00:00

	mov al, dh 				;GUARDAMOS EN AL EL CONTENIDO DE DH, EN ESTE CASO LOS SEGUNDOS
	call CONVERT 			;LLAMAMOS AL PROCESO CONVERT
	mov [bx+6], ax 			;SE MUEVEN LOS SEGUNDOS A LA POSICION QUE TIENE [bx+6]
							;EJEMPLO 10:51:42:00

	mov al, dl 				;GUARDAMOS EN AL EL CONTENIDO DE DL, EN ESTE CASO LOS MILISEGUNDOS
	call CONVERT 			;LLAMAMOS AL PROCESO CONVERT
	mov [bx+9], ax 			;SE MUEVEN LOS MILISEGUNDOS A LA POSICION QUE TIENE [bx+9]
							;EJEMPLO 10:51:42:12 

	pop cx 					;SACAMOS DE LA PILA cx
	pop ax					;SACAMOS DE LA PILA ax

	ret 					;CERRAMOS EL PROCESO Y CONTINUAMOS CON EL FLUJO DEL PROGRAMA
GETTIME endp

GETTIMER proc
	push ax 				;LO QUE CONTIENE ax SE GUARDA EN LA PILA
	push cx 				;LO QUE CONTIENE cx SE GUARDA EN LA PILA
	push dx 				;LO QUE CONTIENE dx SE GUARDA EN LA PILA
	push bx 				;LO QUE CONTIENE bx SE GUARDA EN LA PILA

	mov ah,00h
	int 1Ah

	mov ax, [tiempoInicial]		;AX = parte baja de t_inicial
	mov bx, [tiempoInicial+2]	;BX = parte alta de t_inicial

	sub dx, ax  				;DX = DX - AX = t_final - t_inicial, DX guarda la parte baja del contador de ticks
	sbb cx, bx 					;CX = CX - BX - C = t_final - t_inicial - C, 
								;CX guarda la parte alta del contador de ticks y 
								;se resta el acarreo si hubo en la resta anterior

	mov ax, dx 				;GUARDAMOS EN ax EL CONTENIDO DE dx, EN ESTE CASO LA PARTE BAJA DEL CONTADOR 
	mul [tick_ms] 			;MULTIPLICAMOS ax POR LOS TICKS QUE EXISTEN EN CADA MILISEGUNDO
	div [mil]				;DESPUES LO DIVIDIMOS ENTRE 1000
	
	mov [miliSegundos], dx 	;AQUI OBTENEMOS LOS MILISEGUNDOS
	div [sesenta] 			;DIVIDIMOS ENTRE 60 PARA OBTENER LOS SEGUNDOS 
	mov [segundos], ah 		;AQUI OBTENEMOS LOS SEGUNDOS 
	xor ah, ah 				
	div[sesenta] 			;DIVIDIMOS ENTRE 60 PARA OBTENER LOS MINUTOS 
	mov [minutos], ah 		;OBTENEMOS LOS MINUTOS

	pop bx 					;RECUPERAMOS LO QUE TENIAMOS EN bx PARA PODER MODIFICAR LA VARIABLE TIMER 

	xor ah, ah 				;COMENZAMOS A CONVERTIR EL ASCII PARA LOS MINUTOS 
	mov al, [minutos]
	AAM
	or ax, 3030h
	mov cl, al
	mov [bx], ah 			;DECENAS DE LOS MINUTOS
	mov [bx+1], cl 			;UNIDADES DE LOS MINUTOS 

	xor ah, ah 				;COMENZAMOS A CONVERTIR EL ASCII PARA LOS SEGUNDOS 
	mov al, [segundos]
	AAM
	or ax, 3030h
	mov cl, al
	mov [bx+3], ah 			;DECENAS DE LOS SEGUNDOS
	mov [bx+4], cl 			;UNIDADES DE LOS SEGUNDOS 

	mov ax, [miliSegundos] 	;COMENZAMOS A CONVERTIR EL ASCII PARA LOS MILISEGUNDOS 
	div [cien]
	xor al, 30h
	mov cl, ah
	mov [bx+6], al 			;CENTENAS DE LOS MILISEGUNDOS

	mov al, cl 				
	xor ah, ah
	AAM
	or ax, 3030h
	mov cl, al
	mov [bx+7], ah 			;DECENAS DE LOS MILISEGUNDOS 
	mov [bx+8], cl 			;UNIDADES DE LOS MILISEGUNDOS

	pop dx 					;SACAMOS DE LA PILA dx
	pop cx 					;SACAMOS DE LA PILA cx 
	pop ax 					;SACAMOS DE LA PILA ax

	ret
GETTIMER endp

GETDATE proc 				;INICIO DEL PROCESO GETTIME
	push ax					;LO QUE CONTIENE ax SE GUARDA EN LA PILA
	push cx					;LO QUE CONTIENE bx SE GUARDA EN LA PILA

	mov ah, 2Ah 			;INTERRUPCION QUE SIRVE PARA OBTENER LA FECHA DEL SISTEMA
	int 21h

	mov ax, cx 				;GUARDAMOS EN AX EL CONTENIDO DE CX, EN ESTE CASO EL AÑO
	mov cx, ax 				;GUARDAMOS EN CX UNA COPIA DE AX PARA EVITAR PROBLEMAS EN EL CODIGO

	AAM						;(ASCII ADJUST AX AFTER MULTIPLY)
	mov al, 0				;MOVEMOS A AL 0d 
	AAM						;(ASCII ADJUST AX AFTER MULTIPLY)
	mov al, ah 				;GUARDAMOS EN AL EL CONTENIDO DE AH = 0
	or al, 30h 				;PASAMOS DE ASCII A DECIMAL
	mov [bx+9], al    		;SE MUEVEN LAS UNIDADES DEL AÑO A LA POSICION QUE TIENE [bx+9]
							;EJEMPLO 00/00/0000

	mov ax, cx 				;LO GUARDADO ANTERIORMENTE ES MOVIDO A AX
	AAM 					;(ASCII ADJUST AX AFTER MULTIPLY)

	mov al, ah 				;GUARDAMOS EN AL EL CONTENIDO DE AH = 2
	AAM 					;(ASCII ADJUST AX AFTER MULTIPLY)
	or al, 30h 				;PASAMOS DE ASCII A DECIMAL
	mov [bx+8], al 			;SE MUEVEN LAS DECENAS DEL AÑO A LA POSICION QUE TIENE [bx+8]
							;EJEMPLO 00/00/0020

	mov al, ah 				;GUARDAMOS EN AL EL CONTENIDO DE AH = 0
	AAM 					;(ASCII ADJUST AX AFTER MULTIPLY)
	or ax, 3030h 			;PASAMOS DE ASCII A DECIMAL
	mov [bx+7], ah 			;SE MUEVEN LAS CENTENAS DEL AÑO A LA POSICION QUE TIENE [bx+7]
	mov [bx+6], al 			;SE MUEVEN LAS UNIDADES DE MILLAR DEL AÑO A LA POSICION QUE TIENE [bx+6]
							;EJEMPLO 00/00/2020

	mov al, dh 				;GUARDAMOS EN AL EL CONTENIDO DE DH, EN ESTE CASO EL NUMERO DE MES 
	call CONVERT  			;LLAMAMOS AL PROCESO CONVERT
	mov [bx+3], ax 			;SE MUEVE EL NUMERO DE MES A LA POSICION QUE CONTIENE [bx+3]
							;EJEMPLO 00/12/2020

	mov al, dl 				;GUARDAMOS EN AL EL CONTENIDO DE DL, EN ESTE CASO EL NUMERO DEL DÍA
	call CONVERT 			;LLAMAMOS AL PROCESO CONVERT
	mov [bx], ax 			;SE MUEVE EL NUMERO DEL DIA A LA POSICION QUE CONTIENE [bx]
							;EJEMPLO 14/12/2020

	pop cx 					;SACAMOS DE LA PILA cx
	pop ax					;SACAMOS DE LA PILA ax

	ret 					;CERRAMOS EL PROCESO Y CONTINUAMOS CON EL FLUJO DEL PROGRAMA
GETDATE endp

CONVERT proc 				;INICIO DEL PROCESO CONVERT
	push dx 				;LO QUE CONTIENE dx SE GUARDA EN LA PILA

	mov ah, 0				;UTILIZAMOS ESTAS FUNCIONES PARA PASAR DE ASCII A DECIMAL
	mov dl, 10
	div dl
	or ax, 3030h	

	pop dx					;SACAMOS DE LA PILA dx
	ret 					;RETORNAMOS EL VALOR OBTENIDO
CONVERT endp

RESET proc 					;INICIO DEL PROCESO RESET 
	push ax 				;LO QUE CONTIENE ax SE GUARDA EN LA PILA
	push cx 				;LO QUE CONTIENE cx SE GUARDA EN LA PILA
	push bx 				;LO QUE CONTIENE bx SE GUARDA EN LA PILA

	mov ax, 3030h 			;LIMPIAMOS LAS VARIABLES
	mov [bx], ax
	mov [bx+3], ax
	mov [bx+6], ax
	mov [bx+7], ax

	pop bx 					;SACAMOS DE LA PILA bx
	pop cx 					;SACAMOS DE LA PILA cx
	pop ax 					;SACAMOS DE LA PILA ax 

	ret
RESET endp

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