// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{
	double numero ;
	int exponente , contador_potencia , contador_factorial ;
	long long int potencia , factorial = 1  ;
	
	cout << "Introduzca el numero que desea elevar (x): " << endl;
	cin >> numero ;
	
	do {	
		cout << "y la potencia (n) a la que tiene que ser elevado" << endl ;
		cin >> exponente ;
	} while (exponente < 0) ;
	
	potencia = numero ;
	
	for (contador_potencia = 1 ; contador_potencia < exponente ; contador_potencia++)
		potencia = potencia * numero ;
	
	if (exponente == 0)
		factorial = 1 ;
	else
		for (contador_factorial = exponente ; contador_factorial > 0 ; contador_factorial--)
			factorial = factorial * contador_factorial ;
			
	cout << numero << "^" << exponente << " = " << potencia << endl ;	
	cout << "Tambien se ha calculado el facorial de " << exponente << ", que es: " << factorial << endl ;
	
	return 0;
	system ("pause");
}
