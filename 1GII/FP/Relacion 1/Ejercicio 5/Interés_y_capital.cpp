// Ignacio Vellido Exp�sito - F3

# include <stdlib.h>			// Busqu� en Internet la librer�a necesaria para usar la funci�n (system("pause")) por si desea utilizar el ejecutable
# include <iostream>
using namespace std ;

int main() 
{
	double total, capital, interes ;
	
	cout << "Introduzca el capital: " << endl ;
	cin >> capital ;
	
	cout << endl ;	
	
	cout << "Introduzca el inter�s: " << endl ;
	cin >> interes ;
	
	cout << endl ;
	
	total = capital + ( capital * ( interes/100 ) ) ;
	
	cout << "El dinero total es: " << total << endl ; 

	system ("pause") ;	
	return 0 ;
}

/* Perfectamente se podr�a sustituir la variable total por capital 
(ahorrando memoria), siempre que la cambiemos tanto en la operaci�n
como en "cout" */
