//Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <stdlib.h>
#include <string>
using namespace std;

int main() 
{
	const int TERMINADOR = 0 ;
	int dato , max ;
	string resultado = "\nTodos los valores de la primera secuencia son mayores que todos los de la segunda" ; ;
	
	cout << "Introduzca la primera y la segunda secuencia (finalizan con un 0)" << endl ;
	cin >> dato ;
	max = dato ;
	
	do  {
		cin >> dato ;
		if (dato > max)
			max = dato ;
	} while (dato != TERMINADOR) ;
	
	do {
		cin >> dato ;
		if ((dato < max) && dato != TERMINADOR)
			resultado = "\nHay al menos un valor de la segunda secuencia menor que uno de la primera" ;
	} while (dato != TERMINADOR) ;
	
	cout << resultado << endl ;	

	return 0;
	system ("pause");
}
