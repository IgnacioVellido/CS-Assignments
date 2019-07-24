// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{	
	int longitud , digito , contador ;
	
	cout << "Introduzca un digito mayor que 0" << endl ;
	cin >> longitud ;
	
	for (contador=1 ; contador <= longitud ; contador++) {
		digito = 1 ;
		do {
			cout << digito << " " ;
			digito++ ;
		} while (digito <= contador) ;
		cout << endl ;
	}
	
	return 0;
	system ("pause");
}

/*
	for (contador1= 1; contador1 <0 contador ; contador1 ++)
		cout << contador << " " ;
		*/
