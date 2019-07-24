// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <stdlib.h>
#include <cmath>
using namespace std;

int main()
{	
	int numero_ingresado , numero_operador , digito , contador = 0 , operador ;
	
	cout << "Ingrese el numero" << endl ;
	cin >> numero_ingresado ;
	
	numero_operador = numero_ingresado ;
	
	while (numero_ingresado > 0) {
		numero_ingresado = numero_ingresado / 10 ;
		contador++ ;
	}
	
	contador--;
	operador = pow(10,contador) ;
	
	while (operador >= 1) {
		digito = numero_operador / operador ;
		cout << digito << " " ;
		numero_operador = numero_operador % operador ;
		operador = operador / 10 ;
	}
	
	cout << endl ;
	
	return 0;
	system ("pause");
}
