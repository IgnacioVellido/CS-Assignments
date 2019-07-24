// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <stdlib.h>
#include <string>
using namespace std;

int main()
{	
	int longitud , digito , contador , k , suma ;
	string resultado ;
	
	cout << "Introduzca un digito mayor que 1: " ;
	cin >> longitud ;
	cout << "Sus descomposiciones son: " << endl ;
	
	for (k = 1 ; k <= longitud ; k++) {
		for (contador = 1 ; contador <= longitud ; contador++) {
			suma = 0 ;
			resultado = "0";
			for (digito = k; digito < contador ; digito ++) {
			suma += digito ;
			resultado = resultado + " + " + to_string(digito) ;
			}
			if (suma == longitud)
				cout << resultado << endl ;
		}
	}
	
	return 0;
	system ("pause");
}

