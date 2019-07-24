// -----------------------------------------------------------------------------
//
// Sistemas concurrentes y Distribuidos.
// Práctica 3. Implementación de algoritmos distribuidos con MPI
//
// Archivo: filosofos_camarero_ex.cpp
// Implementación del problema de los filósofos (con camarero).
//
// Ignacio Vellido Expósito
//
// Compilación:
// mpicxx -std=c++11 -o filosofos_camarero_ex filosofos_camarero_ex.cpp
// 
// Ejecución:
// mpirun -np 12 ./filosofos_camarero_ex
//
// -----------------------------------------------------------------------------


#include <mpi.h>
#include <thread> // this_thread::sleep_for
#include <random> // dispositivos, generadores y distribuciones aleatorias
#include <chrono> // duraciones (duration), unidades de tiempo
#include <iostream>

using namespace std;
using namespace std::this_thread ;
using namespace std::chrono ;

const int
   num_filosofos = 5,
   num_procesos  = 2*num_filosofos + 2,
   
   id_camarero = num_procesos-2,
   id_cuchara  = num_procesos-1,

   etiq_sentarse   = 0,
   etiq_levantarse = 1,
   etiq_cogerC     = 2,
   etiq_soltarC    = 3;


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
int solicitar_tenedor( int id, int id_tenedor, bool izq) {
  if (izq) // Si es el tenedor de la izq
    cout << "- Filósofo " << id << " solicita ten. izq." << id_tenedor << endl;
  else
    cout << "- Filósofo " << id << " solicita ten. der." << id_tenedor << endl;

  MPI_Ssend( &id_tenedor, 1, MPI_INT, id_tenedor, 0, MPI_COMM_WORLD );

  return id_tenedor;
}

int soltar_tenedor( int id, int id_tenedor, bool izq) {
  if (izq)
    cout << "- Filósofo " << id <<" suelta ten. izq. " << id_tenedor << endl;
  else
    cout << "- Filósofo " << id <<" suelta ten. der. " << id_tenedor << endl;

  MPI_Ssend( &id_tenedor, 1, MPI_INT, id_tenedor, 0, MPI_COMM_WORLD );

  return id_tenedor;
}

// ---------------------------------------------------------------------
void funcion_filosofos( int id ) {
  int id_ten_izq = (id+1)              % (num_procesos-2), //id. tenedor izq.
      id_ten_der = (id+num_procesos-3) % (num_procesos-2), //id. tenedor der.
      valor      = 0;				       //valor cualquiera (se usa por legibilidad)
  MPI_Status estado ;       

  while ( true ) {
    // Solicitar mesa
    MPI_Send( &valor, 1, MPI_INT, id_camarero, etiq_sentarse, MPI_COMM_WORLD );
    MPI_Recv( &valor, 1, MPI_INT, id_camarero, etiq_sentarse, MPI_COMM_WORLD, &estado );

    id_ten_der = solicitar_tenedor (id, id_ten_der, false);
    id_ten_izq = solicitar_tenedor (id, id_ten_izq, true);

    cout << "Filósofo " << id << " comienza a comer" << endl;
    sleep_for( milliseconds( aleatorio<10,100>() ) );	

    id_ten_der = soltar_tenedor (id, id_ten_der, false);
    id_ten_izq = soltar_tenedor (id, id_ten_izq, true);

    // Tomarse un postre
    MPI_Send( &valor, 1, MPI_INT, id_cuchara, etiq_cogerC, MPI_COMM_WORLD );
    MPI_Recv( &valor, 1, MPI_INT, id_cuchara, etiq_cogerC, MPI_COMM_WORLD, &estado );

    cout << "Filósofo " << id << " toma un postre" << endl;
    sleep_for( milliseconds( aleatorio<10,100>() ) );	

    MPI_Ssend( &valor, 1, MPI_INT, id_cuchara, etiq_soltarC, MPI_COMM_WORLD );

    // Levantarse de la mesa
    MPI_Ssend( &valor, 1, MPI_INT, id_camarero, etiq_levantarse, MPI_COMM_WORLD );

    cout << "Filosofo " << id << " comienza a pensar" << endl;
    sleep_for( milliseconds( aleatorio<10,100>() ) );
  }
}

// ---------------------------------------------------------------------
void funcion_tenedores( int id ) {
  int valor, id_filosofo ;  // valor recibido, identificador del filósofo
  MPI_Status estado ;       // metadatos de las dos recepciones

  while ( true ) {
     // Recibiendo petición de cualquier filósofo
     MPI_Recv( &valor, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &estado );

     id_filosofo = estado.MPI_SOURCE;
     cout << "# Ten. " << id << " ha sido cogido por filo. " << id_filosofo << endl;

     // Recibiendo liberación de filósofo
     MPI_Recv( &valor, 1, MPI_INT, id_filosofo, MPI_ANY_TAG, MPI_COMM_WORLD, &estado );
     cout << "# Ten. " << id << " ha sido liberado por filo. " << id_filosofo << endl ;
  }
}

// ---------------------------------------------------------------------
void funcion_camarero( ) {
  int valor = 0, id_filosofo,   // valor recibido, identificador del filosofo
      sentados = 0,             // numero de filosofos en la mesa
      etiq_emisor,
      tag_aceptable;

  MPI_Status estado ;           // metadatos de las dos recepciones

  while (true) {
     if (sentados < 4) 
       tag_aceptable = MPI_ANY_TAG;
     else
       tag_aceptable = etiq_levantarse; 

     MPI_Recv( &valor, 1, MPI_INT, MPI_ANY_SOURCE, tag_aceptable, MPI_COMM_WORLD, &estado ); 
     id_filosofo = estado.MPI_SOURCE;

     if (estado.MPI_TAG == etiq_sentarse) {
       sentados++;
       cout << "\t# Filosofo " << id_filosofo << " se sienta a al mesa. " << endl;
       MPI_Send( &valor, 1, MPI_INT, id_filosofo, etiq_sentarse, MPI_COMM_WORLD );
 
     } else if (estado.MPI_TAG == etiq_levantarse) {
       sentados--;
       cout << "\t# Filosofo " << id_filosofo << " se levanta de la mesa. " << endl ; 
     }
  }
}

// ---------------------------------------------------------------------
void funcion_cuchara( ) {
  int valor = 0, id_filosofo,   // valor recibido, identificador del filosofo
      cucharas = 3,             // numero de filosofos en la mesa
      etiq_emisor,
      tag_aceptable;

  MPI_Status estado ;           // metadatos de las dos recepciones

  while (true) {
     if (cucharas > 0) 
       tag_aceptable = MPI_ANY_TAG;
     else
       tag_aceptable = etiq_soltarC; 

     MPI_Recv( &valor, 1, MPI_INT, MPI_ANY_SOURCE, tag_aceptable, MPI_COMM_WORLD, &estado ); 
     id_filosofo = estado.MPI_SOURCE;

     if (estado.MPI_TAG == etiq_cogerC) {
       cucharas--;
       cout << "\t# Filosofo " << id_filosofo << " coge una cuchara. " << endl;
       MPI_Ssend( &valor, 1, MPI_INT, id_filosofo, etiq_cogerC, MPI_COMM_WORLD );
 
     } else if (estado.MPI_TAG == etiq_soltarC) {
       cucharas++;
       cout << "\t# Filosofo " << id_filosofo << " suelta la cuchara. " << endl ; 
     }
  }
}

// ---------------------------------------------------------------------
int main( int argc, char** argv ) {
   int id_propio, num_procesos_actual ;

   MPI_Init( &argc, &argv );
   MPI_Comm_rank( MPI_COMM_WORLD, &id_propio );
   MPI_Comm_size( MPI_COMM_WORLD, &num_procesos_actual );


   if ( num_procesos == num_procesos_actual ) {

      // Ejecutando la función correspondiente a 'id_propio'
      if ( id_propio == id_camarero )
	 funcion_camarero();
      else if ( id_propio == id_cuchara )
	 funcion_cuchara();
      else if ( id_propio % 2 == 0 )          // si es par
         funcion_filosofos( id_propio ); 	//   es un filósofo
      else                                    // si es impar
         funcion_tenedores( id_propio ); 	//   es un tenedor

   } else {
      if ( id_propio == 0 ) { // solo el primero escribe error, indep. del rol
        cout << "el número de procesos esperados es:    " << num_procesos << endl
             << "el número de procesos en ejecución es: " << num_procesos_actual << endl
             << "(programa abortado)" << endl ;
      }
   }

   MPI_Finalize( );
   return 0;
}
