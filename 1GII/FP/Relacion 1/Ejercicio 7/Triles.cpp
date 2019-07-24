// Ignacio Vellido Expósito - F3

#include <stdlib.h>			// Busqué en Internet la librería necesaria para usar la función (system("pause")) por si desea utilizar el ejecutable
#include <iostream>
using namespace std ;

int main()
{
	double caja_izda, caja_dcha, intercambio ;
	
	
	cout << "Introduzca dinero en la caja izquierda: " << endl ;
	cin >> caja_izda ;
	cout << "Introduzca dinero en la caja derecha: " << endl ;
	cin >> caja_dcha ;
	
	intercambio = caja_izda ;
	caja_izda = caja_dcha ;
	caja_dcha = intercambio ;
	
	cout << "Ahora en la caja izquierda hay: " << caja_izda << endl ;
	cout << "Ahora en la caja derecha hay: " << caja_dcha << endl ;
	
	system ("pause") ;
	return 0 ;
}
