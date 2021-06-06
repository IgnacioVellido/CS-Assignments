.SUFFIXES:

all: limpia sintactico

sintactico: main.o y.tab.o
	gcc -o prueba main.o y.tab.o

y.tab.o: y.tab.c
	gcc -c y.tab.c

main.o: main.c
	gcc -c main.c

y.tab.c: sintactico.y lex.yy.c
	bison -d -o y.tab.c sintactico.y --report="solved"

lex.yy.c: lexico.flex
	flex lexico.flex

limpia:
	rm -f prueba main.o y.tab.o y.tab.c lex.yy.c

todo:
	make limpia
	make prueba	

run:
	./prueba archivo_prueba4.cpp

# ###############################################3

lexico: lex.yy.c
	gcc -o lexico lex.yy.c -I .

lex.yy.c: lexico.flex
	flex lexico.flex

run-lexico:
	./lexico archivo_prueba1.cpp

# clean: limpiar mrproper

# limpiar:
# 	rm lexico

# mrproper:
# 	rm lex.yy.c
