//-----------------------------------------------------------------------------------------------------
// Ignacio Vellido Expósito
//
// Sistemas concurrentes y Distribuidos.
// Práctica 2. Ejercicio_2
//
// archivo: ejercicio2.cpp
// compilacion: g++ -std=c++11 ejercicio2.cpp -o ejercicio2 HoareMonitor.hpp HoareMonitor.cpp -pthread
//
// Nota:
// - Tenía entendido que las variables condición podían no funcionar como si fuese FIFO, por lo que he
// implementado una cola FIFO para mantener el turno.
// - No lo he realizado para los superusuarios puesto que durante el examen ha dicho que en este caso
// si se mantiene el orden. Por evitar errores no he modificado lo que tenía.
//-----------------------------------------------------------------------------------------------------

#include <iostream>
#include <iomanip>
#include <cassert>
#include <random>
#include <thread>
#include "HoareMonitor.hpp"

using namespace std ;
using namespace HM ;

// numero de usuarios
const int num_usuarios = 2 ;

// numero de superusuarios
const int num_superusuarios = 2 ;

// mutex de escritura en pantalla
mutex mtx ;

//**********************************************************************

template< int min, int max > int aleatorio()
{
  static default_random_engine generador( (random_device())() );
  static uniform_int_distribution<int> distribucion_uniforme( min, max ) ;
  return distribucion_uniforme( generador );
}

//**********************************************************************

void Imprimir(int ih)
{
   mtx.lock();
   cout << "El usuario " << ih << " está imprimiendo" << flush << endl ;
   mtx.unlock();

   this_thread::sleep_for( chrono::milliseconds( aleatorio<300,600>() ));

   mtx.lock();
   cout << "El usuario " << ih << " ha finalizado de imprimir" << flush << endl ;
   mtx.unlock();
}
//----------------------------------------------------------------------

void ImprimirSuperU(int ihs)
{
   mtx.lock();
   cout << "\tEl superusuario " << ihs << " está imprimiendo" << flush <<  endl ;
   mtx.unlock();

   this_thread::sleep_for( chrono::milliseconds( aleatorio<300,600>() ));

   mtx.lock();
   cout << "\tEl superusuario " << ihs << " ha finalizado de imprimir" << flush <<  endl ;
   mtx.unlock();
}

// *****************************************************************************
// clase para monitor

class Impresora : public HoareMonitor
{
  int 
    puntero_seleccionar_turno,
    puntero_pedir_turno,
    turno_usuario[num_usuarios];   // Indica, dentro de los usuarios (normales), cuál debe ser el siguiente
  bool
    ocupada;
  CondVar
    usuarios[num_usuarios],
    superusuario;

 public:          // constructor y métodos públicos
   Impresora() ;    // constructor
   void obtenerImpresora( int ih );
   void liberarImpresora( int ih );
   void obtenerImpresoraSuperU( int ihs );
   void liberarImpresoraSuperU( );
} ;
// -----------------------------------------------------------------------------

Impresora::Impresora(  )
{
  //Inicializar variable/s condición
  //Inicializar variable/s estado
  puntero_seleccionar_turno = 0;
  puntero_pedir_turno = 0;
  ocupada = false;
  superusuario = newCondVar();
  for (int i = 0; i < num_usuarios; i++) 
    usuarios[i] = newCondVar();

}
// -----------------------------------------------------------------------------

void Impresora::obtenerImpresora( int ih )
{
  cout << "El usuario " << ih << " quiere imprimir" << flush << endl ;
  //Si la impresora está ocupada
  //  el usuario se bloquea en la cola de usuarios
  turno_usuario[puntero_pedir_turno] = ih;
  puntero_pedir_turno = (puntero_pedir_turno + 1) % num_usuarios;

  if (ocupada)
    usuarios[ih].wait();

  //En este punto el usuario ih puede obtener la impresora
  //modificar la/s variable/s de estado del monitor para indicar que la impresora está ocupada
  ocupada = true;
}
// -----------------------------------------------------------------------------

void Impresora::liberarImpresora( int ih )
{
  //modificar la/s variable/s de estado del monitor para indicar que la impresora está ahora libre
  ocupada = false;

  //Si el superusuario está esperando
  //  liberar al superusuario para que pueda acceder a la impresora
  //Si no
  //  liberar al siguiente usuario para que pueda acceder a la impresora
  if (!superusuario.empty())
    superusuario.signal();
  else {
    usuarios[puntero_seleccionar_turno].signal();
    puntero_seleccionar_turno = (puntero_seleccionar_turno + 1) % num_usuarios;
  }
}

// -----------------------------------------------------------------------------

void Impresora::obtenerImpresoraSuperU( int ihs )
{
  cout << "\tEl superusuario " << ihs << " quiere imprimir" << endl ;
  //Si la impresora está ocupada
  //  el superusuario se bloquea en una cola de superusuarios
  if (ocupada)
    superusuario.wait();

  //En este punto el superusuario puede obtener la impresora
  //modificar la/s variable/s de estado del monitor para indicar que la impresora está ocupada
  ocupada = true;
}
// -----------------------------------------------------------------------------

void Impresora::liberarImpresoraSuperU( )
{
  //modificar la/s variable/s de estado del monitor para indicar que la impresora está ahora libre
  ocupada = false;

  //liberar al siguiente usuario para que pueda acceder a la impresora
  if (superusuario.empty()) {
    usuarios[puntero_seleccionar_turno].signal();
    puntero_seleccionar_turno = (puntero_seleccionar_turno + 1) % num_usuarios;  
  }
  else
    superusuario.signal();
}

// *****************************************************************************
// funciones de hebras
// -----------------------------------------------------------------------------

void funcion_hebra_usuario( MRef<Impresora> monitor, int num_cliente )
{
   while( true )
   {
      this_thread::sleep_for( chrono::milliseconds( aleatorio<100,600>() ));
      monitor->obtenerImpresora( num_cliente );
      Imprimir( num_cliente );
      monitor->liberarImpresora( num_cliente );
   }
}

// -----------------------------------------------------------------------------

void funcion_hebra_superusuario( MRef<Impresora> monitor, int num_superusuario)
{
   while( true )
   {
      this_thread::sleep_for( chrono::milliseconds( aleatorio<1000,1200>() ));
      monitor->obtenerImpresoraSuperU( num_superusuario );
      ImprimirSuperU( num_superusuario );
      monitor->liberarImpresoraSuperU( );
   }
}

// *****************************************************************************

int main()
{
     cout << "-------------------------------------------------------------------------------" << endl
        << "Problema de la impresora (1 superusuario, "<<num_usuarios<<" usuarios, Monitor SU). " << endl
        << "-------------------------------------------------------------------------------" << endl
        << flush ;

   MRef<Impresora> impresora = Create<Impresora>( ); 

   thread superusuarios [num_superusuarios] ;
   thread usuarios [num_usuarios] ;


   for (int i = 0 ; i < num_usuarios ; i++)
	usuarios[i] = thread (funcion_hebra_usuario, impresora, i) ;

   for (int i = 0 ; i < num_usuarios ; i++)
	superusuarios[i] = thread (funcion_hebra_superusuario, impresora, i) ;

   // Es necesario los join para que el main no acabe antes
   for (int i = 0 ; i < num_usuarios ; i++)
	superusuarios[i].join() ;

   // Es necesario los join para que el main no acabe antes
   for (int i = 0 ; i < num_usuarios ; i++)
	usuarios[i].join() ;

}
