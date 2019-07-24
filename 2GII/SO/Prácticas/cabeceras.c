#include <sys/types.h>	// umask, chmod, DIR, kill - Tipos de datos primitivos del sistema
#include <sys/stat.h>	// struct stat

#include <stdio.h>	// printf, stdin

#include <unistd.h>	// getpid, exec - Constantes simbólicas

#include <fcntl.h>	// fcntl

#include <stdlib.h>	// NULL, EXIT_SUCCESS

#include <signal.h>	// Señales

#include <errno.h>	// Errores

#include <wait.h>	// wait
 
#include <dirent.h>	// struct dirent

#include <string.h>	// Strings: strcpy...

// -------------------------------------------

#include <sys/mman.h>	// mmap

#include <time.h>	// Funciones de tiempo

#include <sched.h>	// clone

#include <malloc.h>	// malloc

#include<sys/syscall.h>	// Llamadas al sistema

#include <stdarg.h>	// verr

#include <ftw.h> 	// nftw

#include <limits.h>	// LONG_MIN

// -------------------------------------SEÑALES

static void manejador(int senal) {

  return;
}

// ---------------------------------------MAIN

int main (int argc, char **argv) {



  return (EXIT_SUCCESS);
}

// ---------------------------------------STAT

  struct stat atribut;
  if ( lstat(<nombre_archivo>, &atribut) < 0) {
    perror ("Error al acceder a los atributos\n");
    exit(EXIT_FAILURE);
  }

// ---------------------------------------FORK

  int pid_hijo;
  if ( (pid_hijo = fork()) < 0) {
    perror ("Error al crear el hijo\n");
    exit(EXIT_FAILURE);
  }

// -------------------------------------SETBUF

  if (setvbuf(<stdout>, NULL, _IONBF, 0)) {
    perror ("Error al desactivar el buffering\n");
    exit(EXIT_FAILURE);
  } 

// -------------------------------------MKFIFO

  // Probar con un unlink antes si no va

  if (mkfifo(<nombre>, 0666) < 0) {
    perror ("Error al crear el archivo FIFO\n");
    exit(EXIT_FAILURE);
  }

// ---------------------------------------DUP2

  if ( dup2(<nuevo>, <antiguo>) == -1) {
    perror("Error en dup2\n");
    exit(EXIT_FAILURE);
  }   

// -----------------------------------SIGACTION

  struct sigaction manejador; 
  manejador.sa_handler = <nombrefuncion>;	// Estableciendo el manejador a la función 
  
  sigemptyset(&manejador.sa_mask);
  manejador.sa_flags = 0;	

  if (sigaction(<SEÑAL>, &manejador, NULL)== -1) {
    perror ("Error configurando señal \n");
    exit(EXIT_FAILURE);
  }

  // --------
  static void handler(int senal) {

  }


// ---------------------------------READ - WRITE

  read(<FD>, <var_a_almacenar>, <tamaño>);	
  write(<FD>, <var_a_escribir>, <tamaño>);

  FILE *temporal;		
  temporal = tmpfile();
  <leidos> = fread(<var_a_leer>, sizeof(), <tamaño>, temporal);
  fwrite(<var_a_escribir>, sizeof(), <tamaño>, temporal);

// -----------------------------------------OPEN

  if ( (<id> = open(<RUTA>, <O_RDWR>)) < 0) {
    perror ("Error al abrir el archivo\n");
    exit(EXIT_FAILURE);
  }

// ---------------------------------------UNLINK

  if ( unlink(<nombre>) < 0) {
    perror ("Error en unlink\n");
    exit(EXIT_FAILURE);
  }

// ----------------------------------------EXECL

  if ( execl(<RUTA>, <NOMBRE>, <ARGUMENTOS>, NULL) < 0) { 
    perror ("Error en execl\n");
    exit(EXIT_FAILURE);
  }

// ----------------------------------------FCNTL

  struct flock cerrojo;
  cerrojo.l_type = F_WRLCK;
  cerrojo.l_whence = SEEK_SET;
  cerrojo.l_start = 0;
  cerrojo.l_len = 0;

  if ( fcntl(<FD>, <F_SETLKW>, &cerrojo) == -1) {
    perror ("Error al bloquear\n");
    exit(EXIT_FAILURE);
  }

  // ------------
  close(1);
  if ( fcntl(<FD>, <F_DUPFD>, 1) == -1) {
    perror ("Error al duplicar\n");
    exit(EXIT_FAILURE);
  }

// ----------------------------------------LSTAT

  struct stat atributos;
  if ( lstat(argv[1], &atributos) < 0) {
    perror ("Error al acceder a los atributos\n");
    exit(EXIT_FAILURE);
  }

// ---------------------------------------SPRINTF

  sprintf(<VARIABLE>, <CADENA>, <ARGUMENTOS>);

// ------------------------------------ARGUMENTOS

  if (argc != <>) {
    perror("Uso: %s <> <>\n", argv[0]);
    exit(EXIT_FAILURE);
  }

// -----------------------------------------CLOSE

  if (close(<fd>) == -1) {
    perror("Error en close\n");
    exit(EXIT_FAILURE);
  }
