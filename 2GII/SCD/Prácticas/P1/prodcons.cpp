// Ignacio Vellido Expósito

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

const int num_items = 40 ,   // número de items
	       tam_vec   = 10 ;   // tamaño del buffer
unsigned  cont_prod[num_items] = {0}, // contadores de verificación: producidos
          cont_cons[num_items] = {0}; // contadores de verificación: consumidos

int vec[tam_vec] ;				// Inicializando el vector, implementación FIFO (cola)

Semaphore sem_pro = tam_vec , sem_con = 0 ;	// Al comienzo el productor puede hacer como máximo 'tam_vec' inserciones
						// en el vector sin necesidad de un signal

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
   static int contador = 0 ;
   this_thread::sleep_for( chrono::milliseconds( aleatorio<20,100>() ));

   cout << "producido: " << contador << endl << flush ;

   cont_prod[contador] ++ ;
   return contador++ ;
}
//----------------------------------------------------------------------

void consumir_dato( unsigned dato )
{
   assert( dato < num_items );
   cont_cons[dato] ++ ;
   this_thread::sleep_for( chrono::milliseconds( aleatorio<20,100>() ));

   cout << "                  consumido: " << dato << endl ;
   
}


//----------------------------------------------------------------------

void test_contadores()
{
   bool ok = true ;
   cout << "comprobando contadores ...." ;
   for( unsigned i = 0 ; i < num_items ; i++ )
   {  if ( cont_prod[i] != 1 )
      {  cout << "error: valor " << i << " producido " << cont_prod[i] << " veces." << endl ;
         ok = false ;
      }
      if ( cont_cons[i] != 1 )
      {  cout << "error: valor " << i << " consumido " << cont_cons[i] << " veces" << endl ;
         ok = false ;
      }
   }
   if (ok)
      cout << endl << flush << "solución (aparentemente) correcta." << endl << flush ;
}

//----------------------------------------------------------------------

void  funcion_hebra_productora(  )
{
   int puntero_pro = 0 ;				// Inicializando el punto de comienzo de la inserción de valores

   for( unsigned i = 0 ; i < num_items ; i++ )
   {
      int dato = producir_dato() ;

      sem_wait (sem_pro) ;
		vec [puntero_pro] = dato ;		// Sección crítica, ambos procesos utilizan el vector
      sem_signal (sem_con) ;

      puntero_pro = (puntero_pro + 1) % tam_vec ;
      
   }
}

//----------------------------------------------------------------------

void funcion_hebra_consumidora(  )
{
   int puntero_con = 0 ;				// Inicializando el punto de comienzo de la lectura de valores

   for( unsigned i = 0 ; i < num_items ; i++ )
   {
      int dato ;

      sem_wait (sem_con) ;
	      dato = vec [puntero_con] ;		// Sección crítica
      sem_signal (sem_pro) ;

      consumir_dato(					// Esto podría ir dentro del signal, pero lo dejo fuera puesto 
			 dato ) ;
      puntero_con = (puntero_con + 1) % tam_vec ;		// Incrementando el puntero módulo el tamaño
								// que realmente no pertenece a una sección crítica
								// (Aunque tam_vec sea global solo se utiliza como lectura)
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
          hebra_consumidora( funcion_hebra_consumidora );

   hebra_productora.join() ;
   hebra_consumidora.join() ;

   test_contadores();

   cout << "FIN" << endl ;
}
