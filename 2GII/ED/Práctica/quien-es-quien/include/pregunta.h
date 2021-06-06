#ifndef _PREGUNTA_H_
#define _PREGUNTA_H_

#include <string>
#include <iostream>
#include <cassert>

using namespace std;

/**
  * @brief En cada estructura pregunta se almacena la cadena de la pregunta y el 
  *        número de personajes que aún no han sido eliminados. Si el 
  *        número de personajes es 1, entonces la cadena pregunta 
  *        contiene el nombre del personaje.
  */
class Pregunta{

	private: 
		/**
		  * @brief Atributo sobre el que se pregunta en este nodo. En el caso de que haya un único
		  *        personaje restante, este campo almacena su nombre.
		  */
		string atributo;

		/**
		  * @brief Número de personajes que quedan al llegar a esta pregunta.
		  */
		int num_personajes;

	public:
		/**
		  * @brief Constructor por defecto de la pregunta.
		  *
		  * Reserva los recursos.
		  */
		Pregunta();

		/**
	          * @brief Constructor de copias
	          * @param pregunta Pregunta a copiar
	          * 
	          * Construye la pregunta duplicando el contenido de @e pregunta en la pregunta
	          * receptora.
	          */
		Pregunta(const Pregunta & pregunta);

		/**
		  * @brief Constructor de la pregunta
		  * @param atributo Atributo sobre el que se pregunta en este nodo. En el caso de que haya un único
		  *        personaje restante, este campo almacena su nombre.
		  * @param num_personajes Número de personajes que quedan al llegar a esta pregunta.
		  */
		Pregunta(const string atributo, const int num_personajes);

		/**
		  * @brief Destructor
      		  *
	      	  * Libera los recursos ocupados por la pregunta receptora.
      		  */
		~Pregunta();

		/**
 	          * @brief Operador de asignación
	  	  * @param pregunta Pregunta a copiar
		  * @return Referencia a la pregunta receptora.
	          *
	          * Asigna el valor de la pregunta duplicando el contenido de @e pregunta en la
	          * pregunta receptora.
	          */
		Pregunta & operator = (const Pregunta & pregunta);

		/**
		  * @brief Operador de inserción de flujo.
		  * @param os Stream de salida.
		  * @param pregunta Pregunta a escribir.
		  * @return Referencia al stream de salida.
		  *
		  * Escribe en la salida la pregunta, escribiendo primero la cadena de la pregunta y
		  * después el número de personajes que quedan al llegar a esta pregunta.
		  */
		friend ostream& operator<< (ostream& os, const Pregunta &pregunta);

		/**
		  * @brief Devuelve el atributo sobre el que se pregunta en el nodo.
		  *
		  * @pre El nodo debe ser un nodo de pregunta (num_personaje>1).
		  */
		string obtener_pregunta() const;

		/**
		  * @brief Devuelve el personaje del nodo
		  *
		  * @pre El nodo debe ser un nodo de personaje (num_personaje==1).
		  */
		string obtener_personaje() const;

		/**
		  * @brief Devuelve el número de personajes sin eliminar al llegar a esta pregunta.
		  */
		int obtener_num_personajes() const;

		// Añadido
		/**
		  * @brief Aumenta en 1 el valor de num_personajes.
		  */
		void aumentar_num_personajes();

		/**
		  * @brief Devuelve true si el nodo es de personaje.
		  */
		bool es_personaje() const;

		/**
		  * @brief Devuelve true si el nodo es de pregunta.
		  */
		bool es_pregunta() const;


		// Añadido --------------------------------------------------------
		bool operator == (const Pregunta &p) {
		   if(atributo == p.atributo && num_personajes == p.num_personajes)
		     return true;
		   else
		     return false;
		}
};

#endif
