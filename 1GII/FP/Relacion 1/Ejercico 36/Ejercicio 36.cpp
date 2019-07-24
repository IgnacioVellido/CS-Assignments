// Ignacio Vellido Expóstio - F3

#include <iostream>
#include <stdlib.h>			// Busqué en Internet la librería necesaria para usar la función (system("pause")) por si desea utilizar el ejecutable
#include <cmath>
using namespace std ;

int main()
{
	int numero ;
	double real ;
	
	cout << "Introduzca un número: " << endl ;
	cin >> numero ;
	
	real = log2 (numero) ;
		
	cout << "Hacen falta " << real << " dígitos" << endl ;
	
	system ("pause") ;
	return 0 ;
}
