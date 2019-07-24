// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <stdlib.h>
#include <string>
using namespace std;

int main()
{	
	int tope , digito , contador , suma ;
	string resultado ;
	
	cout << "Introduzca un digito mayor que 1: " ;
	cin >> tope ;
	cout << "Los numeros triangulares menores que el son: " << endl ;
	
	for (contador = 1 ; contador <= tope ; contador++) {
		suma = 0 ;
		resultado = to_string(contador) + " = 0" ;
		for (digito = 1; digito < contador ; digito ++) {
		suma += digito ;
		resultado = resultado + " + " + to_string(digito) ;
		}
		if (suma == contador)
			cout << resultado << endl ;
	}
	
	return 0;
	system ("pause");
}

