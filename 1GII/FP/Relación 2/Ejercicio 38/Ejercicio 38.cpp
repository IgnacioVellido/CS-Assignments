// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <stdlib.h>
#include <cmath>
using namespace std;

int main()
{	
	int digitos , numero , contador , operador , narcisista = 0 , resultado ;
	
	cout << "Introduzca un numero para saber si es narcisista: " << endl ;
	cin >> numero ;
	
	operador = numero ;
	resultado = numero ;
	
	do {
		operador = operador / 10 ;
		digitos++ ;
	} while (operador != 0) ;
	
	for (contador = 0 ; contador < digitos ; contador++) {
		narcisista = narcisista + pow(numero % 10 , digitos) ;
		numero = numero / 10 ;
	}
		
	if (resultado == narcisista)
		cout << "El numero es narcisista" << endl ;
	else
		cout << "El numero no es narcisista" << endl ;
	
	return 0;
	system ("pause");
}
