// Ignacio Vellido Expósito - F3 (Martes)

#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{
	const int TERMINADOR = -1 ;
	int numero , suma , min , max ;
	
	cout << "Introduzca los números que desea sumar. \nPara finalizar introduzca -1" << endl ;
	cin >> numero ;
	
	min = numero ;
	max = numero ;
	suma = 0 ;
	
	while (numero != TERMINADOR)	{
		suma = suma + numero ;
		cin >> numero ;
		if (numero > max)
			max = numero ;
		if (numero < min && numero != TERMINADOR)
			min = numero ;
	}
	
	cout << "La suma vale: " << suma << endl ;
	cout << "El mínimo es: " << min << endl ;	
	cout << "El máximo es: " << max << endl ;	
	
	return (0);
	system ("pause");
}
