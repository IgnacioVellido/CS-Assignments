.section .data
	 .macro linea								# Tiene que haber 13 líneas, separar los dígitos decimales de 3 en 3, hexadecimales de 4 en 4
			# .int 1,-2,1,-2					# 0 _ -16
			# .int 1,2,-3,-4					# -1 _ 0
			# .int 0x7FFFFFFF,0x7FFFFFFF,0x7FFFFFFF,0x7FFFFFFF 	# 0x7FFF FFFF _ 0x0000 0000
			# .int 0x80000000,0x80000000,0x80000000,0x80000000	# 0x8000 0000 _ 0x0000 0000 
			# .int 0xF0000000,0xE0000000,0xE0000000,0xD0000000	# 0xE000 0000 _ 0x0000 0000
			# .int -1,-1,-1,-1					# -1 _ 0
	 .endm
	 .macro linea0
			# .int 0,-1,-1,-1					# 0 _ -31
			# .int 0,-2,-1,-1					# -1 _ 0

			# .int 1,-2,-1,-1					# 0 _ -31
			# .int 16,-2,-1,-1					# 0 _ -16
			# .int 32,-2,-1,-1					# 0 _ 0
			# .int 62,-2,-1,-1					# 0 _ 30
			# .int 63,-2,-1,-1					# 0 _ 31

			# .int 64,-2,-1,-1					# 1 _ 0
			# .int 75,-2,-1,-1					# 1 _ 11 
			# .int 95,-2,-1,-1					# 1 _ -31

			# .int -31,-2,-1,-1					# -1 _ -31
			# .int -10,-2,-1,-1					# -1 _ -10
			# .int 0,-2,-1,-1					# -1 _ 0

	 .endm
lista:			linea#0						# Quitar la almohadilla para cuando varía la primera línea
		.irpc i,1234567
			linea
		.endr
		
longlista:	.int (.-lista)/4					
media:		.int 0x89ABCDEF						# Inicializando la media y el resto
resto: 		.int 0x01234567
formato:	.ascii "media =   %8d \t resto =   %8d \n"		# Formato para printf()
		.ascii "hexadec 0x%08x \t resto = 0x%08x\n\0"		# med/resto, dec/hex

.section .text
main:	.global main							# Punto de arranque del programa compilado con gcc

	mov    $lista, %ebx						# Dirección del array lista
	mov longlista, %ecx
	call suma
	mov %eax, media
	mov %edx, resto

	push resto							# Leyendo el printf() de fin a princio
	push media					
	push resto
	push media

	push $formato							# Y lo primero que se lee es el formato
	call printf							# Traduce formato a ASCII
	add $20, %esp

	mov $1, %eax
	mov $0, %ebx							# Código a retornar 
	int $0x80							# Llamada a _exit(0)

suma:
	mov $0, %edi							# Poniendo el acumulador a 0
	mov $0, %ebp
	mov $0, %esi							# Porque ahora el índice es %esi

bucle:
	mov (%ebx,%esi,4), %eax
	cltd						# Extendiendo el signo
	add %eax, %edi
	adc %edx, %ebp					# Suma con acarreo
	inc %esi					# Se incrementa el indice
	cmp %esi, %ecx					# Comparando con la longitud
	jne bucle

	mov %edi, %eax					# Se devuelve el resultado en edx:eax
	mov %ebp, %edx
	idiv %ecx					# El tamaño del array está en %ecx

	ret
