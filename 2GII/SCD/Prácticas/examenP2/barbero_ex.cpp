//-----------------------------------------------------------------------------------------------------
// Ignacio Vellido Expósito
//
// Sistemas concurrentes y Distribuidos.
// Práctica 2. Barbero_ex
//
// archivo: barbero_ex.cpp
// compilacion: g++ -std=c++11 barbero_ex.cpp -o barbero_ex HoareMonitor.hpp HoareMonitor.cpp -pthread
//-----------------------------------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <random>
#include "HoareMonitor.hpp"

using namespace std ;
using namespace HM ;

//----------------------------------------------------------------------
// Variables globales
static const int NUM_CLIENTES = 3;
static const int NUM_BARBEROS = 2;

mutex esperando;		// Para evitar fallos a la hora de mostrar los mensajes

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

//-------------------------------------------------------------------------
// Función que simula la acción de esperar, con un retardo aleatoria de la hebra
void esperarFueraBarberia( int num_cliente ) {
   // calcular milisegundos aleatorios de duración de la acción de fumar)
   chrono::milliseconds duracion_esperar( aleatorio<100,500>() );

   // informa de que comienza a fumar
   esperando.lock();
   cout << "- Cliente "         << num_cliente << "  :"
        << " sale de la barberia (" << duracion_esperar.count() << " milisegundos)" << endl;
   esperando.unlock();

   // espera bloqueada un tiempo igual a ''duracion_esperar' milisegundos
   this_thread::sleep_for( duracion_esperar );

   // informa de que ha terminado de fumar
   esperando.lock();
//   cout << "$ Cliente " << num_cliente << "  : le ha crecido el pelo, entra en la barbería." << endl;
   esperando.unlock();
}

void cortarPeloACliente( int num_barbero ) {
   // calcular duración aleatoria del corte de pelo
   chrono::milliseconds duracion_pelar( aleatorio<100,500>() );

   // informando de que empieza a pelar
   esperando.lock();
   cout << "- El barbero " << num_barbero << " comienza a pelar mientras relata su vida (" 
	<< duracion_pelar.count() << " milisegundos)" << endl;
   esperando.unlock();

   // espera bloqueada un tiempo igual a ''duracion_pelar' milisegundos
   this_thread::sleep_for( duracion_pelar );

   esperando.lock();
   cout << "\t* El barbero " << num_barbero << " termino de pelar" << endl;
   esperando.unlock();
}

//-------------------------------------------------------------------------
// Monitor SU
class Barberia : public HoareMonitor {
 private:
  int 
   visitantes;
  bool
   durmiendo;						// True si algún barbero está dormido
  CondVar
   sala,						// Sala de espera
   silla,						// Silla de pelar
   rincon;						// Cola para que descanse el barbero

 public:
  Barberia();
  void siguienteCliente( ); 
  void cortarPelo(int);
  void finCliente( );
};

Barberia::Barberia() {
 visitantes = 0;
 durmiendo = false;					// Si se inicializa a true el resultado es incorrecto

 sala = newCondVar();
 silla = newCondVar();
 rincon = newCondVar();
}

void Barberia::siguienteCliente( )  {
 // Mira cuantas visitas han hecho
 if (visitantes >= 3) {
    visitantes = 0;
    cout << "\t- Voy a prohibir las visitas" << endl;
 }

 // En el primer instante el barbero comienza a pelar antes de que alguien llegue a la barberia
 if (silla.empty()) {
   if (sala.empty()) 
      rincon.wait();
   sala.signal();
 }

 if (rincon.empty())
    durmiendo = false;					   // Si todos los barberos están despiertos 
 sala.signal();
}

void Barberia::cortarPelo(int num_cliente) {
   cout << "$ Cliente " << num_cliente << "  : le ha crecido el pelo, entra en la barbería." << endl;
 // Decidir si visita o no
 int visita = aleatorio<0,1>();

 if (visita) {
    cout << "Cliente " << num_cliente << " estoy de visita" << endl;
    visitantes++;
 }
 else {
   if (durmiendo)
      rincon.signal();
   else 
      sala.wait();
     
   cout << "Me toca pelarme: " << num_cliente << endl ;
   silla.wait();
 }
}

void Barberia::finCliente( ) {
 cout << "\t+ Ya hay un pelado nuevo en la ciudad" << endl;
 silla.signal();					   // Le dice al cliente que se largue
 if (sala.empty()) {
//    if (!rincon.empty())				   // Si hay alguien durmiendo, lo deja a true
       durmiendo = true;
    rincon.wait();					   // Duerme si no hay nadie en la tienda
 }
}

//----------------------------------------------------------------------
// Función que ejecuta la hebra del cliente
void  funcion_hebra_cliente( int num_cliente, MRef<Barberia> Barberia ) {
 while( true ) {
    Barberia->cortarPelo(num_cliente); 	
    esperarFueraBarberia(num_cliente) ;
 }
}

//----------------------------------------------------------------------
// función que ejecuta la hebra del barbero

void funcion_hebra_barbero( int num_barbero, MRef<Barberia> Barberia){
 while (true) { 
   Barberia->siguienteCliente();
   cortarPeloACliente(num_barbero);   
   Barberia->finCliente();
 }
}

// -----------------------------------------------------------------------------
int main() {
   cout << "-------------------------------------------------------------------------------" << endl
        << "Problema de la barbería ("<<NUM_BARBEROS<<" barberos, "<<NUM_CLIENTES<<" clientes, Monitor SU). " << endl
        << "-------------------------------------------------------------------------------" << endl
        << flush ;

   MRef<Barberia> barberia = Create<Barberia>( ); 

   thread barberos [NUM_BARBEROS] ;
   thread clientes [NUM_CLIENTES] ;

   for (int i = 0 ; i < NUM_BARBEROS ; i++)
	barberos[i] = thread (funcion_hebra_barbero, i, barberia) ;

   for (int i = 0 ; i < NUM_CLIENTES ; i++)
	clientes[i] = thread (funcion_hebra_cliente, i, barberia) ;

   // Es necesario los join para que el main no acabe antes
   for (int i = 0 ; i < NUM_CLIENTES ; i++)
	clientes[i].join() ;

   for (int i = 0 ; i < NUM_BARBEROS ; i++)
	barberos[i].join() ;

}
