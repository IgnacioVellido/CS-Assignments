// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{	
	const int TERMINADOR = -1 ;
	int contador = 1 , dato1 , dato2 ;
	
	cout << "Ingrese la cadena a comprimir: " << endl ;
	cin >> dato1 ;
	
	do {
		cin >> dato2 ;
		while (dato2 == dato1) {
			contador++;
			cin >> dato1 ;
			if (dato1 == TERMINADOR) {			// Para salir del programa en caso de que dato1 fuese el TERMINADOR
			cout << endl ;
			return 0 ;
			}
		}
		cout << contador << " " << dato1 << " " ;
		contador = 1 ;
	} while (dato2 != TERMINADOR) ;
	
	cout << endl ;

	return 0;
	system ("pause");
}

// 1 1 1 2 2 2 2 2 3 3 3 3 3 3 5 -1
