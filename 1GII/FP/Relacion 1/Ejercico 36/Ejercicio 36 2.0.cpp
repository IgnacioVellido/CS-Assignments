// Ignacio Vellido Exp�stio - F3

#include <iostream>
#include <stdlib.h>			// Busqu� en Internet la librer�a necesaria para usar la funci�n (system("pause")) por si desea utilizar el ejecutable
#include <string>
using namespace std ;

int main()
{
	int numero , digitos ;
	string auxiliar ;

	cout << "Introduzca un n�mero: " << endl ;
	cin >> numero ;
	
	do {
		
	digitos = numero % 2 ;
	digitos = to_string(digitos) ;
	numero = numero / 2 ;
	auxiliar =  auxiliar + digitos ;

	}	while (numero > 1) 	;

	cout << "Hacen falta " << auxiliar << " d�gitos" << endl ;
	
	system ("pause") ;
	return 0 ;
}
