// Ignacio Vellido Exp�sito - F3

# include <iostream>
# include <stdlib.h>			// Busqu� en Internet la librer�a necesaria para usar la funci�n (system("pause")) por si desea utilizar el ejecutable
using namespace std ;

int main()
{	
	char mayuscula ;
	int operador ;
	
	cout << "Introduzca una may�scula: " << endl ;
	cin >> mayuscula ;
	
	operador = 'a' - 'A' ;
	mayuscula = mayuscula + operador ;
	
	cout << endl ;
	cout << "Se transforma en: " << mayuscula << endl ;
	
	system ("pause") ;
	return 0 ;
}
