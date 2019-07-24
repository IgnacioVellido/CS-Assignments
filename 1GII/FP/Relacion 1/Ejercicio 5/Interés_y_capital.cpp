// Ignacio Vellido Expósito - F3

# include <stdlib.h>			// Busqué en Internet la librería necesaria para usar la función (system("pause")) por si desea utilizar el ejecutable
# include <iostream>
using namespace std ;

int main() 
{
	double total, capital, interes ;
	
	cout << "Introduzca el capital: " << endl ;
	cin >> capital ;
	
	cout << endl ;	
	
	cout << "Introduzca el interés: " << endl ;
	cin >> interes ;
	
	cout << endl ;
	
	total = capital + ( capital * ( interes/100 ) ) ;
	
	cout << "El dinero total es: " << total << endl ; 

	system ("pause") ;	
	return 0 ;
}

/* Perfectamente se podría sustituir la variable total por capital 
(ahorrando memoria), siempre que la cambiemos tanto en la operación
como en "cout" */
