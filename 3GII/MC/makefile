# Makefile - Ignacio Vellido Expósito

all: beautifier

beautifier: lex.yy.c
	gcc -o beautifier lex.yy.c

lex.yy.c: plantilla.flex
	flex plantilla.flex

ejecuta:
	./beautifier ejemplo-beautifier.cpp y

run-lineas:
	./beautifier ejemplo-beautifier.cpp y

run-no-lineas:
	./beautifier ejemplo-beautifier.cpp n

run-espacios:
	./beautifier ejemplo-beautifier.cpp n 2

run-errores:
	./beautifier ejemplo-errores.cpp n


clean: limpiar mrproper
	

limpiar:
	rm beautifier

mrproper:
	rm lex.yy.c
