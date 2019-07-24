// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{	
	const int TERMINADOR = -1 ;
	int contador = 1 , actual , anterior ;
	
	cout << "Ingrese la cadena a comprimir: " << endl ;
	cin >> anterior ;
	
	while (anterior != TERMINADOR){
		cin >> actual ;
		if (actual == anterior)	
			contador++ ;
		else {
			cout << contador << " " << anterior << " " ;
			contador = 1 ;
		}
		anterior = actual ;
	}
	
	cout << endl ;

	return 0;
	system ("pause");
}

// 1 1 1 2 2 2 2 2 3 3 3 3 3 3 5 -1
