// Ignacio Vellido Expósito - F3 (Martes)

#include <iostream>
#include <stdlib.h>
#include <ctime>
#include <cstdlib>
using namespace std;

int main()
{
	const int MIN = 1,MAX = 100 ;
	const int NUM_VALORES = MAX-MIN + 1 ; 
	int numero , repetir , incognita ; 
	time_t tiempo ;
	
	do {
		srand(time(&tiempo)) ; 
		incognita = (rand() % NUM_VALORES) + MIN ;	
	
		cout << "\n¡Adivine el numero! (Entre 1 y 100)" << endl ;
		cin >> numero ;
	
		while (numero != incognita) {
			if (numero > incognita)
				cout << "No, ese numero es mayor" << endl ;
			else
				cout << "No, ese numero es menor" << endl ;
			
			cout << "\nIntroduzca otro" << endl ;
			cin >> numero ;
		}
		
		cout << "Acertaste, el número es: " << incognita << endl ;
		
		cout << "Si quiere jugar otra vez introduzca 0" << endl ;
		cin >> repetir ;
		
	} while (repetir == 0) ;
	
	return (0);
	system ("pause");
}
