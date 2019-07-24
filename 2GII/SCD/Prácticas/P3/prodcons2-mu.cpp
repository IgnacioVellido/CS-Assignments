// -----------------------------------------------------------------------------
//
// Sistemas concurrentes y Distribuidos.
// Práctica 3. Implementación de algoritmos distribuidos con MPI
//
// Archivo: prodcons2.cpp
// Implementación del problema del productor-consumidor con
// un proceso intermedio que gestiona un buffer finito y recibe peticiones
// en orden arbitrario
// (versión con múltiples productores y múltiples consumidores)
//
// Ignacio Vellido Expósito
//
// Compilación:
// mpicxx -std=c++11 -o prodcons2-mu prodcons2-mu.cpp
// 
// Ejecución:
// mpirun -np 10 ./prodcons2-mu
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
   n_productores         = 4 ,
   n_consumidores        = 5 ,
   n_buffers             = 1 ,
   id_buffer             = n_productores,	// Este id es igual al n_productores, 0...n_productores son los id_productores
   num_procesos_esperado = n_productores + n_consumidores + n_buffers ,
   num_items             = 20,
   tam_vector            = 10,

   etiq_productor	 = 0,
   etiq_consumidor	 = 1;

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


// producir produce los numeros en secuencia [id*k, id*k + k - 1]
// siendo k = num_items / n_productores
// y llama a una espera aleatoria
int producir( const int id) {
   static int contador = id * (num_items / n_productores);

   sleep_for( milliseconds( aleatorio<10,100>()) );
   contador++ ;
   cout << "- Productor " << id << " ha producido valor " << contador << endl << flush;

   return contador;
}

// ---------------------------------------------------------------------
void funcion_productor(const int id) {
   int total_producir 	= num_items / n_productores;

   for (unsigned int i = 0; i < total_producir; i++) {
      // producir valor
      int valor_prod = producir(id);

      // enviar valor
      cout << "# Productor " << id << " va a enviar valor " << valor_prod << endl << flush;
      MPI_Ssend( &valor_prod, 1, MPI_INT, id_buffer, etiq_productor, MPI_COMM_WORLD );
   }
//   cout << "--- Productor " << id << " dice adios" << endl;
}

// ---------------------------------------------------------------------
void consumir( int id, int valor_cons ) {
   // espera bloqueada
   sleep_for( milliseconds( aleatorio<110,200>()) );
   cout << "\t- Consumidor " << id << " ha consumido valor " << valor_cons << endl << flush ;
}

// ---------------------------------------------------------------------
void funcion_consumidor( const int id ) {
   int         peticion,
               valor_rec = 1 ,
	       total_consumir = num_items/n_consumidores;
   MPI_Status  estado ;

   for (unsigned int i=0 ; i < total_consumir; i++) {
      MPI_Ssend( &peticion,  1, MPI_INT, id_buffer, etiq_consumidor, MPI_COMM_WORLD);
      MPI_Recv ( &valor_rec, 1, MPI_INT, id_buffer, etiq_consumidor, MPI_COMM_WORLD, &estado );

      cout << "\t# Consumidor " << id << " ha recibido valor " << valor_rec << endl << flush ;
      consumir(id, valor_rec);
   }
//   cout << "\t--- Consumidor " << id << " dice adios" << endl;
}

// ---------------------------------------------------------------------
void funcion_buffer() {
   int        buffer[tam_vector],      			// buffer con celdas ocupadas y vacías
              valor,                   			// valor recibido o enviado
              primera_libre       = 0, 			// índice de primera celda libre
              primera_ocupada     = 0, 			// índice de primera celda ocupada
              num_celdas_ocupadas = 0, 			// número de celdas ocupadas
              id_emisor_aceptable = MPI_ANY_SOURCE;     // identificador de emisor aceptable
   MPI_Status estado ;                 			// metadatos del mensaje recibido

   int        etiq_emisor;


   for (unsigned int i=0 ; i < num_items*2 ; i++) {

      // 1. determinar si puede enviar solo prod., solo cons, o todos
      if ( num_celdas_ocupadas == 0 )               // si buffer vacío
         etiq_emisor = etiq_productor ;       	 	// solo prod.
      else if ( num_celdas_ocupadas == tam_vector ) // si buffer lleno
         etiq_emisor = etiq_consumidor ;      		// solo cons.
      else                                          // si no vacío ni lleno
         etiq_emisor = MPI_ANY_TAG ;          		// cualquiera

      // 2. recibir un mensaje del emisor o emisores aceptables
      MPI_Recv( &valor, 1, MPI_INT, id_emisor_aceptable, etiq_emisor, MPI_COMM_WORLD, &estado );

      // 3. procesar el mensaje recibido 
      switch( estado.MPI_TAG ) { // leer emisor del mensaje en metadatos      
         case etiq_productor: 				// si ha sido el productor: insertar en buffer
            buffer[primera_libre] = valor ;
            primera_libre = (primera_libre+1) % tam_vector ;
            num_celdas_ocupadas++ ;
            cout << "· Buffer ha recibido valor " << valor << endl ;
            break;

         case etiq_consumidor: 				// si ha sido el consumidor: extraer y enviarle
            valor = buffer[primera_ocupada] ;
            primera_ocupada = (primera_ocupada+1) % tam_vector ;
            num_celdas_ocupadas-- ;
            cout << "· Buffer va a enviar valor " << valor << endl ;
            MPI_Ssend( &valor, 1, MPI_INT, estado.MPI_SOURCE, etiq_consumidor, MPI_COMM_WORLD);
            break;
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
      if (id_propio == 0)
	cout << "--------------------------------------------------------" << endl
             << "Problema de los productores-consumidores (solución MPI)." << endl
             << "--------------------------------------------------------" << endl
             << flush ;

      // ejecutar la operación apropiada a 'id_propio'
      if (id_propio < n_productores)
         funcion_productor( id_propio );
      else if (id_propio == id_buffer)
         funcion_buffer( );
      else
         funcion_consumidor( id_propio );

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
