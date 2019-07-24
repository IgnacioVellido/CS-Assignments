// Ignacio Vellido Expósito - F3

# include <iostream>
# include <stdlib.h>			// Busqué en Internet la librería necesaria para usar la función (system("pause")) por si desea utilizar el ejecutable
using namespace std ;

int main()
{	
	char mayuscula ;
	int operador ;
	
	cout << "Introduzca una mayúscula: " << endl ;
	cin >> mayuscula ;
	
	operador = 'a' - 'A' ;
	mayuscula = mayuscula + operador ;
	
	cout << endl ;
	cout << "Se transforma en: " << mayuscula << endl ;
	
	system ("pause") ;
	return 0 ;
}
