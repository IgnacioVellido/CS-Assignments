// Ignacio Vellido Exp�stio - F3

#include <iostream>
#include <stdlib.h>			// Busqu� en Internet la librer�a necesaria para usar la funci�n (system("pause")) por si desea utilizar el ejecutable
#include <cmath>
using namespace std ;

int main()
{
	int numero ;
	double real ;
	
	cout << "Introduzca un n�mero: " << endl ;
	cin >> numero ;
	
	real = log2 (numero) ;
		
	cout << "Hacen falta " << real << " d�gitos" << endl ;
	
	system ("pause") ;
	return 0 ;
}
