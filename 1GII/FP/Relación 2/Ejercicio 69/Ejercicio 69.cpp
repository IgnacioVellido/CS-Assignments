// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <stdlib.h>
#include <string>
using namespace std;

bool perfecto (int numero) {
	int contador , suma = 0 ;
	bool condicion ;
	
	for (contador = 1; contador < numero ; contador++ ) {
	condicion = numero % contador == 0 ;
	if (condicion)
		suma = suma + contador ;
	}
	
 	if (suma == numero)
 		return (true) ;
 	else 
 		return (false) ;
}

int main()
{	
	int dato , intervalo, final ;
	bool comprobacion ;
	string resultado ;
	
	cout << "Introduzca un numero: " << endl ;
	cin >> intervalo ;
	
	for (dato = 1 ; dato < intervalo ; dato++ ) {
		comprobacion = perfecto(dato) ;
		if (comprobacion)
			final = dato ;
	}
	resultado = "El mayor numero perfecto menor que el numero introducido es: " + to_string(final) ;
	cout << resultado << endl ;
	
	return 0;
	system ("pause");
}
