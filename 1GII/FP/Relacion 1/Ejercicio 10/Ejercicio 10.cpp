// Ignacio Vellido Exp�stio - F3

#include <iostream>
#include <stdlib.h>			// Busqu� en Internet la librer�a necesaria para usar la funci�n (system("pause")) por si desea utilizar el ejecutable
#include <cmath>
using namespace std ;

int main()
{
	const double PI = 3.1416 ;
	double gaussiana , media , desviacion , abcisa ;
	
	cout << "Introduzca el valor de la media: " << endl ;
	cin >> media ;
	cout << "Introduzca el valor de la desviaci�n t�pica: " << endl ;
	cin >> desviacion ;
	cout << "Introduzca la abcisa: " << endl ;
	cin >> abcisa ;
	
	abcisa = (abcisa - media)/desviacion ;
	gaussiana = ( 1 / ( desviacion * sqrt (2*PI) ) ) * exp ( -0.5 * pow (abcisa , 2) ) ;
	
	cout << "La funci�n toma el valor: " << gaussiana << endl ;
	
	system ("pause") ;
	return 0 ;
}
