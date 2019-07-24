// -----------------------------------------------------------------------------
//
// Sistemas concurrentes y Distribuidos.
// Práctica 3. Implementación de algoritmos distribuidos con MPI
//
// Archivo: cajas.cpp
//
// Ignacio Vellido Expósito
//
// Compilación:
// mpicxx -std=c++11 -o ejercicio1 ejercicio1.cpp
// 
// Ejecución:
// mpirun -np 8 ./ejercicio1
//
// -----------------------------------------------------------------------------

#include <iostream>
#include <thread> // this_thread::sleep_for
#include <random> // dispositivos, generadores y distribuciones aleatorias
#include <chrono> // duraciones (duration), unidades de tiempo
#include <mpi.h>

using namespace std;
using namespace std::this_thread ;
using namespace std::chrono ;

// ---------------------------------------------------------------------
const int			
   n_usuarios            = 5 ,
   n_cajas               = 2 ,			// Los ids corresponden a n_usuarios+1 y a n_usuarios+2
   n_controladores       = 1 ,
   id_controlador        = n_usuarios ,		// Este id es igual al n_productores, 0...n_productores son los id_productores
   num_procesos_esperado = n_usuarios + n_cajas + n_controladores ,

   etiq_solicitar	 = 0,
   etiq_completado	 = 1;

//**********************************************************************
// plantilla de función para generar un entero aleatorio uniformemente
// distribuido entre dos valores enteros, ambos incluidos
// (ambos tienen que ser dos constantes, conocidas en tiempo de compilación)
//----------------------------------------------------------------------
template< int min, int max > int aleatorio() {
  static default_random_engine generador( (random_device())() );
  static uniform_int_distribution<int> distribucion_uniforme( min, max ) ;
  return distribucion_uniforme( generador );
}

// ---------------------------------------------------------------------
void hacer_cosas_de_usuarios( int id ) {
   // espera bloqueada
   sleep_for( milliseconds( aleatorio<110,200>()) );
   cout << "# Usuario " << id << " hace algo " << endl << flush ;
}

// ---------------------------------------------------------------------
void funcion_usuario(const int id) {
   int 		valor = 0 ,
		id_caja ;
   MPI_Status	estado ;

   while (true) {
     cout << "~ Usuario " << id << " solicita caja " << endl << flush ;
     MPI_Send( &valor, 1, MPI_INT, id_controlador, etiq_solicitar, MPI_COMM_WORLD);

     MPI_Recv( &valor, 1, MPI_INT, id_controlador, 0, MPI_COMM_WORLD, &estado );	 
     cout << "& Usuario " << id << " tiene la caja " << valor << endl << flush ;

     id_caja = valor;
     MPI_Send( &valor, 1, MPI_INT, id_caja, 0, MPI_COMM_WORLD);
     MPI_Recv( &valor, 1, MPI_INT, id_caja, 0, MPI_COMM_WORLD, &estado );	

     cout << "~ Usuario " << id << " terminó con la caja " << endl << flush ;
     MPI_Send( &id_caja, 1, MPI_INT, id_controlador, etiq_completado, MPI_COMM_WORLD);

     hacer_cosas_de_usuarios(id);
   }
}

// ---------------------------------------------------------------------
void hacer_cosas_de_cajas( int id ) {
   // espera bloqueada
   sleep_for( milliseconds( aleatorio<110,200>()) );
   cout << "\t- Caja " << id << " hace algo " << endl << flush ;
}

// ---------------------------------------------------------------------
void funcion_caja( const int id ) {
   int 		valor = 0 ,
		id_emisor ;
   MPI_Status 	estado ;

   while (true) {
     cout << "$ Caja " << id << " esta esperando " << endl << flush ;
     MPI_Recv( &valor, 1, MPI_INT, MPI_ANY_SOURCE, 0, MPI_COMM_WORLD, &estado );
     id_emisor = estado.MPI_SOURCE;

     hacer_cosas_de_cajas(id);

     MPI_Ssend( &valor, 1, MPI_INT, id_emisor, 0, MPI_COMM_WORLD);
   }
}

// ---------------------------------------------------------------------
void funcion_controlador() {
   int        valor 		  = 0,               	// valor recibido o enviado
              id_emisor_aceptable = MPI_ANY_SOURCE,     // identificador de emisor aceptable
	      cajas_libres 	  = n_cajas,
	      id_caja ;
   bool	      caja_ocupada[n_cajas];

   MPI_Status estado ;                 			// metadatos del mensaje recibido
   int        etiq_emisor,
	      tag_aceptable;

   for (int i = 0; i < n_cajas; i++)
      caja_ocupada[i] = false;

   while (true) {
     if (cajas_libres != 0) 
       tag_aceptable = MPI_ANY_TAG;
     else
       tag_aceptable = etiq_completado; 

     MPI_Recv( &valor, 1, MPI_INT, MPI_ANY_SOURCE, tag_aceptable, MPI_COMM_WORLD, &estado ); 

     if (estado.MPI_TAG == etiq_solicitar) {
       cajas_libres--;
      
       bool encontrado = false;
       for (int i = 0; i < n_cajas && !encontrado; i++)
	 if (caja_ocupada[i] == false) {
	   id_caja = i + n_usuarios + 1;		// Para calcular el id correcto (+1 por el controlador)
	   caja_ocupada[i] = true;
	   encontrado = true;
         }

       cout << "\t--- Entregando caja " << id_caja << " a usuario " << estado.MPI_SOURCE << endl << flush ;
       MPI_Ssend( &id_caja, 1, MPI_INT, estado.MPI_SOURCE, 0, MPI_COMM_WORLD);            

     } else if (estado.MPI_TAG == etiq_completado) {
       id_caja = valor;

       cout << "\t!! Una caja devuelta"<< endl << flush ;
       cajas_libres++;
       caja_ocupada[id_caja - n_usuarios - 1] = true;
     }
   }
}

// ---------------------------------------------------------------------
int main (int argc, char *argv[]) {
   int id_propio, num_procesos_actual;

   // Se inicializa MPI, leer identif. de proceso y número de procesos
   MPI_Init( &argc, &argv );
   MPI_Comm_rank( MPI_COMM_WORLD, &id_propio );
   MPI_Comm_size( MPI_COMM_WORLD, &num_procesos_actual );

   if (num_procesos_esperado == num_procesos_actual) {

      // ejecutar la operación apropiada a 'id_propio'
      if (id_propio < n_usuarios)
         funcion_usuario( id_propio );
      else if (id_propio == id_controlador)
         funcion_controlador( );
      else
         funcion_caja( id_propio );

   }
   else {
      if ( id_propio == 0 ) { // solo el primero escribe error, indep. del rol
        cout << "el número de procesos esperados es:    " << num_procesos_esperado << endl
             << "el número de procesos en ejecución es: " << num_procesos_actual << endl
             << "(programa abortado)" << endl ;
      }
   }

   // Al terminar el proceso, se finaliza MPI
   MPI_Finalize( );
   return 0;
}
