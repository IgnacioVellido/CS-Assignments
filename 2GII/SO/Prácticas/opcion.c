// Ignacio Vellido Expósito

#include <sys/types.h>	// umask, chmod, DIR, kill - Tipos de datos primitivos del sistema
#include <sys/stat.h>	// struct stat
#include <stdio.h>	// printf, stdin
#include <unistd.h>	// getpid, exec - Constantes simbólicas
#include <fcntl.h>	// fcntl
#include <stdlib.h>	// NULL, EXIT_SUCCESS
#include <errno.h>	// Errores
#include <string.h>	// Strings: strcpy...


// ---------------------------------------MAIN
int main (int argc, char **argv) {
  // Comprobando argumentos
  if (argc != 2) {
    printf("Uso: %s <nombreCauce>\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  // Abrimos el archivo FIFO, menu.c debe haberlo creado antes
  int fifo;
  if ( (fifo = open(argv[1], O_WRONLY)) < 0) {
    perror ("Error al abrir el FIFO\n");
    exit(EXIT_FAILURE);
  }

  int opcion = 6;	// Se inicializa a un número no válido
  printf("Por favor, introduzca un dígito entre 0 y 5\n");
  while (opcion != 0) {
    // Leemos de la entrada estándar
    char digito;
    if (read(STDIN_FILENO, &digito, sizeof(char)) < 0) {
      perror ("Error al leer la opcion\n");
      exit(EXIT_FAILURE);
    }

    // Para evitar que procese el '\n', salto de iteración si lo encuentra
    if (digito == '\n')
      continue;

    opcion = atoi(&digito);
    printf("Opcion: Leido %d\n", opcion);

    // Si la opción es no válida, saltamos a la siguiente iteración
    if (opcion >= 0 && opcion <= 5) {
 
      // Escribimos en el fifo
      if (write(fifo, &opcion, sizeof(int)) <= 0) {
        perror ("Error al escribir la opcion\n");
        exit(EXIT_FAILURE);
      }
    }

/*
    if (fflush(stdin) != 0) {
      perror ("Error limpiar el flujo de entrada\n");
      exit(EXIT_FAILURE);
    }
*/

    printf("Por favor, introduzca un dígito entre 0 y 5\n");
  }

  return (EXIT_SUCCESS);
}
