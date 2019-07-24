// gcc -m32 bomba.c -o bomba

#include <stdio.h>	// para printf()
#include <stdlib.h>	// para exit()
#include <string.h>	// para strncmp()/strlen()
#include <sys/time.h>	// para gettimeofday(), struct timeval

char password[]="abracadabra\n";	// 13 Bytes
int  passcode  = 7777;

void boom(){
	printf("***************\n");
	printf("*** BOOM!!! ***\n");
	printf("***************\n");
	exit(-1);
}

void defused(){
	printf("·························\n");
	printf("··· bomba desactivada ···\n");
	printf("·························\n");
	exit(0);
}

int main(){
#define SIZE 100
	char pass[SIZE];
	int  pasv;
#define TLIM 5			// Limite de tiempo: 5s
	struct timeval tv1,tv2;	// gettimeofday() secs-usecs

	gettimeofday(&tv1,NULL);

	printf("Introduce la contraseña: ");
	fgets(pass,SIZE,stdin);
	if (strncmp(pass,password,strlen(password)))	// strlen no cuenta el \0: 12Bytes
	    boom();

	gettimeofday(&tv2,NULL);
	if (tv2.tv_sec - tv1.tv_sec > TLIM)
	    boom();

	printf("Introduce el código: ");
	scanf("%i",&pasv);				// Lee bytes según el formato y lo almacena donde el puntero
	if (pasv!=passcode) 
	    boom();

	gettimeofday(&tv1,NULL);
	if (tv1.tv_sec - tv2.tv_sec > TLIM)
	    boom();

	defused();
}

/*
La misma bomba de clase pero cambiando abracadabra y el codigo. 
Se puede añadir 64 bits, bucles, struct (cosas de clase)
Solo una contraseña y un código, no puede ir variando, sin algoritmos criptográficos (si se puede la del cesar, sumar restar algún numero a cada letra, aplicarla a la entrada).

nexti hasta "Introduce la contraseña"
nexti hasta call<boom> 
break en boom
	(Dentro no viene nada para sacar la contraseña)
quitar break de boom
break en test %eax, %eax (%eax es el valor devuelto por strncmp)
break en call<strncmp> (para ver los argumentos)
status -> register para ver %eax
data -> memory
	examine 1, string, bytes, valor de mov ..., 0x4(%esp) - segundo argumento (el primero en (%esp))

para saltarnos el boom por si hemos escrito la contraseña mal, en la consola de gdb: set $eax=0
con nexti se activa el flag ZF

para la bomba de tiempo: cmp $0x5, %eax, break ahí
set $eax=0

cmp %eax,%edx - break
set $edx=7777

/// ej2

anotarse la direccion de la instruccion je ... <main>
					jle ... <main>
					je ... <main>
					jle ... <main>
objdump -d bomba
ver las instrucciones de antes: je=74 05, jle=7e 05, jmp=eb
escribir bomba.txt en gdb, sin file<otro prog>

/// ej3
con ghex2 se puede modificar en hexadecimal las direcciones anteriores, cambiando 74 por EB
para cambiar la contraseña buscar: abracadabra, pero no se puede modificar la longitud
par cambiar el codigo buscarlo en hexadecimal, y en little-endian

*/

/*
- info line main - en la consola de gdb
- Si parpadea:
	- Ctrl+C
	- Salir y entrar de ddd
	- rm -rf ~/.ddd/sessions
	

*/
