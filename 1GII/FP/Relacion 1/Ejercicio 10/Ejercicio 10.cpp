// Ignacio Vellido Expóstio - F3

#include <iostream>
#include <stdlib.h>			// Busqué en Internet la librería necesaria para usar la función (system("pause")) por si desea utilizar el ejecutable
#include <cmath>
using namespace std ;

int main()
{
	const double PI = 3.1416 ;
	double gaussiana , media , desviacion , abcisa ;
	
	cout << "Introduzca el valor de la media: " << endl ;
	cin >> media ;
	cout << "Introduzca el valor de la desviación típica: " << endl ;
	cin >> desviacion ;
	cout << "Introduzca la abcisa: " << endl ;
	cin >> abcisa ;
	
	abcisa = (abcisa - media)/desviacion ;
	gaussiana = ( 1 / ( desviacion * sqrt (2*PI) ) ) * exp ( -0.5 * pow (abcisa , 2) ) ;
	
	cout << "La función toma el valor: " << gaussiana << endl ;
	
	system ("pause") ;
	return 0 ;
}
