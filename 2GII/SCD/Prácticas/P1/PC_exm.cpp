// Ignacio Vellido Expósito
// Grupo D2

#include <iostream>
#include <cassert>
#include <thread>
#include <mutex>
#include <random>
#include "Semaphore.h"

using namespace std ;
using namespace SEM ;

//**********************************************************************
// variables compartidas

const int num_items = 500 ,   		// Número de items
	  TOTAL_HEBRAS = 5 ,
	  tam_vec   = num_items / TOTAL_HEBRAS;   // Tamaño del buffer
		// Número de hebras

int balance = 0;

int vec[TOTAL_HEBRAS][tam_vec] ; 	// Vector de buffers, uno para cada hebra

// Al comienzo el productor puede hacer como máximo 'tam_vec' inserciones en cada buffer
// No se puede leer de los buffers hasta que haya al menos una inserción en cada uno
Semaphore sem_pro[TOTAL_HEBRAS] = {tam_vec,tam_vec,tam_vec,tam_vec,tam_vec}, 
	  sem_con[TOTAL_HEBRAS] = {0,0,0,0,0} ;	

//**********************************************************************
// plantilla de función para generar un entero aleatorio uniformemente
// distribuido entre dos valores enteros, ambos incluidos
// (ambos tienen que ser dos constantes, conocidas en tiempo de compilación)
//----------------------------------------------------------------------

template< int min, int max > int aleatorio()
{
  static default_random_engine generador( (random_device())() );
  static uniform_int_distribution<int> distribucion_uniforme( min, max ) ;
  return distribucion_uniforme( generador );
}

//**********************************************************************
// funciones comunes a las dos soluciones (fifo y lifo)
//----------------------------------------------------------------------

int producir_dato()
{
   int numero = 0 ;
   numero = aleatorio<10,30>() ;

   this_thread::sleep_for( chrono::milliseconds( aleatorio<20,100>() ));

   cout << "producido: " << numero << endl << flush ;

   return numero;
}
//----------------------------------------------------------------------

void consumir_dato( unsigned dato, int buffer )
{
   if ((dato % 2) == 0) 				// Se aumenta en los pares
	balance++;
   else 
	balance--;					// Se decrementa en los impares

   this_thread::sleep_for( chrono::milliseconds( aleatorio<20,100>() ));

   cout << "                  consumido: " << dato << " en buffer: " << buffer << endl ;
   
}

//----------------------------------------------------------------------

void  funcion_hebra_productora( )
{
   int puntero_pro[TOTAL_HEBRAS] = {0,0,0,0,0} ;		// Inicializando el punto de comienzo de la inserción de valores
							// Un puntero para cada buffer
   int buffer_a_insertar = 0;				// Buffer sobre el que realizar las operaciones

   for( unsigned i = 0 ; i < num_items ; i++ )
   {
      int dato = producir_dato() ;

	buffer_a_insertar = (i % TOTAL_HEBRAS);
      sem_wait (sem_pro[buffer_a_insertar]) ;
		vec [buffer_a_insertar][ puntero_pro[buffer_a_insertar] ] = dato ;		
      sem_signal (sem_con[buffer_a_insertar]) ;

      // Se aumenta el puntero sobre el que se han realizado la inserción
      puntero_pro[buffer_a_insertar] = (puntero_pro[buffer_a_insertar] + 1) % tam_vec ;
      
   }
}

//----------------------------------------------------------------------

void funcion_hebra_consumidora(int num_hebra)			// num_hebra se utiliza para saber sobre qué buffer leer
{
   int puntero_con = 0 ;					// Inicializando el punto de comienzo de la lectura de valores

   for( unsigned i = 0 ; i < tam_vec ; i++ )
   {
      int dato ;

      sem_wait (sem_con[num_hebra]) ;
	      dato = vec[num_hebra][puntero_con] ;		// Sección crítica
      sem_signal (sem_pro[num_hebra]) ;

      consumir_dato(dato, num_hebra) ;				
			 
      puntero_con = (puntero_con + 1) % tam_vec ;		// Incrementando el puntero módulo el tamaño del buffer
								
    }
}
//----------------------------------------------------------------------

int main()
{
   cout << "--------------------------------------------------------" << endl
        << "Problema de los productores-consumidores (solución LIFO)." << endl
        << "--------------------------------------------------------" << endl
        << flush ;

   thread hebra_productora ( funcion_hebra_productora ),
          hebra_consumidora[TOTAL_HEBRAS];

   for (int i = 0; i < TOTAL_HEBRAS; i++) 
	hebra_consumidora[i] = thread (funcion_hebra_consumidora, i);

   hebra_productora.join() ;
   for (int i = 0; i < TOTAL_HEBRAS; i++) 
	hebra_consumidora[i].join();

   cout << "El balance de números pares e impares consumidos es " << balance << endl;
   cout << "FIN" << endl ;
}
