// Ignacio Vellido Exp�stio - F3

# include <iostream>
# include <stdlib.h>			// Busqu� en Internet la librer�a necesaria para usar la funci�n (system("pause")) por si desea utilizar el ejecutable
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
