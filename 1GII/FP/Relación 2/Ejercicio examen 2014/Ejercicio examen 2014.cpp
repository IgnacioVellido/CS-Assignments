// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <stdlib.h>
#include <string>
using namespace std;

int main()
{	
	int min , max , cifra , numero , digito , contador= 0 , otro ;
	const int OPERADOR = 10 ;
	string resultado ;
	
	cout << "Introduzca un intervalo (min, max) y el digito que desea buscar: " ;
	cin >> min >> max >> cifra ;
	
	for (digito = min ; digito <= max ; digito++) {
		otro = digito ;
		while (otro > 0) {
			numero = otro % OPERADOR ;
			otro = otro / OPERADOR ;
			if (numero == cifra) {
			contador++ ;
			}
		}
	}
	
	resultado = "El numero " + to_string(cifra) + " aparece " + to_string(contador) + " veces en el intervalo." ;
	
	cout << resultado << endl ;
	
	return 0;
	system ("pause");
}

