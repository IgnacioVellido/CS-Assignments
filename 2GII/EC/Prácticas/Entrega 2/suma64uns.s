.section .data
	 .macro linea
			 .int 1,1,1,1							# 32 = 0x20
			# .int 2,2,2,2							# 64
			# .int 1,2,3,4							# 80
			# .int -1,-1,-1,-1						# 0x1FFFFFFFE0
			# .int 0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF		# 0x1FFFFFFFE0
			# .int 0x08000000,0x08000000,0x08000000,0x08000000		# 0x100000000
			# .int 0x10000000,0x10000000,0x10000000,0x10000000		# 0x200000000
	 .endm

lista:		.irpc i,12345678
			linea
		.endr
		
longlista:	.int (.-lista)/4
resultado:	.quad -1
formato:	.ascii "suma = %llu = %llx hex\n\0"		# Formato para printf()

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
	mov $0, %eax
	mov $0, %edx
	mov $0, %esi					# Porque ahora el índice es %esi
bucle:
	add (%ebx,%esi,4), %eax
	jnc nocarry
	inc %edx
nocarry:
	inc       %esi
	cmp %esi, %ecx
	jne bucle

	ret

