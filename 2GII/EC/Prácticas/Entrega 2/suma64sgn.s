.section .data
	 .macro linea
			 .int -1,-1,-1,-1						# -32 
			# .int 0xffffffff,0xffffffff,0xffffffff,0xffffffff		# 0xffffffffffffffe0 = -32
			# .int 1,-2,1,-2						# -16
			# .int 1,2,-3,-4						# -32
			# .int 0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff		# 0x0000000fffffffe0
			# .int 0x80000000,0x80000000,0x80000000,0x80000000		# 0xfffffff000000000
			# .int 0x04000000,0x04000000,0x04000000,0x04000000		# 0x0000000080000000
			# .int 0x08000000,0x08000000,0x08000000,0x08000000		# 0x0000000100000000
			# .int 0xfc000000,0xfc000000,0xfc000000,0xfc000000		# 0xffffffff80000000
			# .int 0xf8000000,0xf8000000,0xf8000000,0xf8000000		# 0xffffffff00000000
			# .int 0xf0000000,0xe0000000,0xe0000000,0xd0000000		# 0xfffffffc00000000
	 .endm

lista:		.irpc i,12345678
			linea
		.endr
		
longlista:	.int (.-lista)/4
resultado:	.quad -1
formato:	.ascii "suma = %lld = %016llx hex\n\0"		# Formato para printf()

.section .text
main:	.global main					# Punto de arranque del programa compilado con gcc

	mov    $lista, %ebx				# Dirección del array lista
	mov longlista, %ecx
	call suma
	mov %eax, resultado
	mov %edx, resultado+4

	push resultado+4				# Primero se añaden los altos
	push resultado					
	push resultado+4
	push resultado

	push $formato
	call printf					# Traduce formato a ASCII
	add $20, %esp

	mov $1, %eax
	mov $0, %ebx
	int $0x80

suma:
	mov $0, %edi					# Poniendo el acumulador a 0
	mov $0, %ebp
	mov $0, %esi					# Porque ahora el índice es %esi

bucle:
	mov (%ebx,%esi,4), %eax
	cltd						# Extendiendo el signo
	add %eax, %edi
	adc %edx, %ebp					# Suma con acarreo
	inc %esi					# Se incrementa el indice
	cmp %esi, %ecx					# Comparando con la longitud
	jne bucle

	mov %edi, %eax
	mov %ebp, %edx
	ret
