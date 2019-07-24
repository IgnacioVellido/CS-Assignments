// Ignacio Vellido Expóstio - F3

# include <iostream>
# include <stdlib.h>			// Busqué en Internet la librería necesaria para usar la función (system("pause")) por si desea utilizar el ejecutable
# include <cctype>
using namespace std ;

int main()
{
	char mayuscula ;
	int numero ;
		
	cout << "Introduzca una letra: " << endl ;
	cin >> mayuscula ;
	
	numero = mayuscula - 'A' ;
	
	cout << "El programa muestra: " << numero << endl ;
	
	system ("pause") ;
	return 0 ;
}
