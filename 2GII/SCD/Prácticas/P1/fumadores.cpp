// Ignacio Vellido Expósito

#include <iostream>
#include <cassert>
#include <thread>
#include <mutex>
#include <random> // dispositivos, generadores y distribuciones aleatorias
#include <chrono> // duraciones (duration), unidades de tiempo
#include "Semaphore.h"

using namespace std ;
using namespace SEM ;

const int NUM_FUMADORES = 3 ;

Semaphore mostrador_vacio = 1 ;					// Solo puede haber un ingrediente
Semaphore ingrediente_disponible [NUM_FUMADORES] = {0,0,0} ;    // Al principio todos deben esperar


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


//----------------------------------------------------------------------
// función que ejecuta la hebra del estanquero

void funcion_hebra_estanquero(  )
{
   while (true) { 
	int ingrediente = aleatorio<0,2> () ;
   
	sem_wait (mostrador_vacio) ;
	   cout << "Poniendo ingrediente: " << ingrediente << endl ;
	sem_signal (ingrediente_disponible [ingrediente]) ;
   }
}

//-------------------------------------------------------------------------
// Función que simula la acción de fumar, como un retardo aleatoria de la hebra

void fumar( int num_fumador )
{

   // calcular milisegundos aleatorios de duración de la acción de fumar)
   chrono::milliseconds duracion_fumar( aleatorio<20,200>() );

   // informa de que comienza a fumar

    cout << "- Fumador " << num_fumador << "  :"
          << " empieza a fumar (" << duracion_fumar.count() << " milisegundos)" << endl;

   // espera bloqueada un tiempo igual a ''duracion_fumar' milisegundos
   this_thread::sleep_for( duracion_fumar );

   // informa de que ha terminado de fumar

    cout << "- Fumador " << num_fumador << "  : termina de fumar, comienza espera de ingrediente." << endl;

}

//----------------------------------------------------------------------
// función que ejecuta la hebra del fumador
void  funcion_hebra_fumador( int num_fumador )
{
   while( true )
   {
	sem_wait (ingrediente_disponible [num_fumador]) ;
	   cout << "                        Retirado ingrediente: " << num_fumador << endl ;
	sem_signal (mostrador_vacio) ;
        
	fumar (num_fumador) ;
   }
}

//----------------------------------------------------------------------

int main()
{
   thread estanquero (funcion_hebra_estanquero) ;
   thread fumadores [NUM_FUMADORES] ;

   for (int i = 0 ; i < NUM_FUMADORES ; i++)
	fumadores[i] = thread (funcion_hebra_fumador, i) ;

   // Es necesario los join para que el main no acabe antes
   for (int i = 0 ; i < NUM_FUMADORES ; i++)
	fumadores[i].join() ;

   estanquero.join() ;

   // Las hebras tienen un bucle infinito, por lo que no van a llegar a aquí
   cout << "FIN" << endl ;			

}

