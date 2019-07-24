// Ignacio Vellido Expósito - F3 (martes)
// He supuesto que todas las temperaturas van a ser positivas

#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{	
	const int TERMINADOR = -1 ;
	double temperatura , comparador = 0;
	int posicion = 1 , longitud = 0 , holi = 1 , subsecuencia = 0 , otro = 1 ;
	
	cout << "Introduzca la secuencia de temperaturas (termina en -1)" << endl ;
	cin >> temperatura ;
	
	while (temperatura != TERMINADOR) {
		if (longitud > subsecuencia) {
			subsecuencia = longitud ;
			}
		
		if (temperatura >= comparador) {
			longitud++ ;
		}
		else {
			longitud = 1 ;
			holi = posicion ; 
		}
		
		comparador = temperatura ;
		posicion++ ;
		cin >> temperatura ;
	}

	
	cout << "La mayor subsecuencia comienza en la posicion " << holi << " y tiene longitud " << subsecuencia << endl ;
	
	return 0;
	system ("pause");
}
// 17.2 17.3 16.2 16.4 17.1 19.2 18.9 -1
/*
	
*/

/* while (temperatura != TERMINADOR) {
		otro = posicion ;
		longitud = 1 ;
		while (temperatura >= comparador && temperatura != TERMINADOR) {
			comparador = temperatura ;
			longitud++ ;
			cin >> temperatura ;
			posicion++ ;
			}
		if (longitud > subsecuencia) {
			subsecuencia = longitud ;
			holi = otro ;
			}
	}
*/
