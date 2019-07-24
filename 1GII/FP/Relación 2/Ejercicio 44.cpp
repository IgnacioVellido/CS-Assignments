// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{	
	int longitud , digito , otro , contador ;
	
	cout << "Introduzca un digito mayor que 0" << endl ;
	cin >> longitud ;
	
	otro = longitud ;
	
	for (contador=1 ; contador <= longitud ; contador++) {
		digito = contador ;
		do {
			cout << digito << " " ;
			digito++ ;
		} while (digito <= otro) ;
		cout << endl ;
		otro++ ;
	}
	
	return 0;
	system ("pause");
}
