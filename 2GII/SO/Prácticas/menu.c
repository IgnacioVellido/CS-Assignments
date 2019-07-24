// Ignacio Vellido Expósito

#include <sys/types.h>	// umask, chmod, DIR, kill - Tipos de datos primitivos del sistema
#include <sys/stat.h>	// struct stat
#include <stdio.h>	// printf, stdin
#include <unistd.h>	// getpid, exec - Constantes simbólicas
#include <fcntl.h>	// fcntl
#include <stdlib.h>	// NULL, EXIT_SUCCESS
#include <errno.h>	// Errores
#include <wait.h>	// wait
#include <string.h>	// Strings: strcpy...


// ---------------------------------------MAIN
int main (int argc, char **argv) {
  // Comprobando argumentos
  if (argc != 5) {
    printf("Uso: %s <r1> <r2> <r3> <nombreCauce>\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  // Creamos el FIFO
  if (mkfifo(argv[4], 0666) < 0) {
    perror ("Error al crear el archivo FIFO\n");
    exit(EXIT_FAILURE);
  }

  // Abrimos el archivo FIFO
  int fifo;
  if ( (fifo = open(argv[4], O_RDONLY)) < 0) {
    perror ("Error al abrir el FIFO\n");
    exit(EXIT_FAILURE);
  }

  int opcion = 6;	// Se inicializa a un número no válido
  while (opcion != 0) {
    read(fifo, &opcion, sizeof(int));
    printf("\nMenu: Leida opcion %d\n", opcion);

    if (opcion >= 1 && opcion <= 3) {
    
      // Creamos el hijo
      int pid_hijo;
      if ( (pid_hijo = fork()) < 0) {
        perror ("Error al crear el hijo\n");
        exit(EXIT_FAILURE);
      }

      if (pid_hijo == 0) {
	// Ejecuta exec - no es execl puesto que es necesario que se le pase la ruta
	// Por el diseño del ejercicio estos programas no reciben argumentos
	if ( execl(argv[opcion], argv[opcion], NULL) < 0) { 
	  printf("Menu: no se puede ejecutar %s", argv[opcion]);
  	  perror ("Error en execl\n");
	  exit(EXIT_FAILURE);
	}	
      }

      // Cogemos los datos e imprimos el tamaño y el propietario
      int archivo;
      if ( (archivo = open(argv[opcion], O_RDONLY)) < 0) {
        perror ("Error al abrir el archivo\n");
        exit(EXIT_FAILURE);
      }

      struct stat atributos;
      if ( lstat(argv[opcion], &atributos) < 0) {
        perror ("Error al acceder a los atributos\n");
        exit(EXIT_FAILURE);
      }

      printf("El tamaño de %s es %d bytes y su propietario es %d\n", argv[opcion], atributos.st_size, atributos.st_uid);
    } 
    else if (opcion == 4) {

      // Creamos los hijos, y ejecutan secuencialmente (se crea uno y se espera a su terminación)
      int pid_hijo, i, estado;
      for (i = 1; i <= 3; i++) {
        if ( (pid_hijo = fork()) < 0) {
          perror ("Error al crear el hijo\n");
          exit(EXIT_FAILURE);
        }

        if (pid_hijo == 0) {	
	  if ( execl(argv[i], argv[i], NULL) < 0) { 
   	    perror ("Error en execl\n");
	    exit(EXIT_FAILURE);
  	  }	
        }

	waitpid(pid_hijo, &estado, 0);
      }

    }
    else if (opcion == 5) {

      // Creamos los hijos, y ejecutan paralelamente (se crean todos y se espera a su terminación)
      int pid_hijo, i;
      for (i = 1; i <= 3; i++) {
        if ( (pid_hijo = fork()) < 0) {
          perror ("Error al crear el hijo\n");
          exit(EXIT_FAILURE);
        }

        if (pid_hijo == 0) {	
	  if ( execl(argv[i], argv[i], NULL) < 0) { 
   	    perror ("Error en execl\n");
	    exit(EXIT_FAILURE);
  	  }	
        }
      }

      int estado;
      for (i = 1; i <= 3; i++)
	wait(&estado);
    }

  }

  // Borrar nombreCauce 
  if ( unlink(argv[4]) < 0) {
    perror ("Error en unlink\n");
    exit(EXIT_FAILURE);
  }  

  return (EXIT_SUCCESS);
}

