// Ignacio Vellido Expóstio - F3

#include <iostream>
#include <stdlib.h>			// Busqué en Internet la librería necesaria para usar la función (system("pause")) por si desea utilizar el ejecutable
#include <string>
using namespace std ;

int main()
{
	int numero , digitos ;
	string auxiliar ;

	cout << "Introduzca un número: " << endl ;
	cin >> numero ;
	
	do {
		
	digitos = numero % 2 ;
	digitos = to_string(digitos) ;
	numero = numero / 2 ;
	auxiliar =  auxiliar + digitos ;

	}	while (numero > 1) 	;

	cout << "Hacen falta " << auxiliar << " dígitos" << endl ;
	
	system ("pause") ;
	return 0 ;
}
