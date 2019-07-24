#include <iostream>
# include <stdlib.h>
using namespace std;

int main()
{
	int hora1 , minuto1 , segundo1 , hora2 , minuto2, segundo2 ;		// Franjas de tiempo
	double asignador ;																// Asigna la tarifa
	const double OPERADOR = 60.0 ;
	const double TARIFA1 = 0.0412 , TARIFA2 = 0.0370 , TARIFA3 = 0.0493 ; 
	
	cout << "Introduzca las horas, minutos y segundos inciales y finales respectivamentes: " << endl ;
	cin >>  hora1 >> minuto1 >> segundo1 >> hora2 >> minuto2 >> segundo2 ;
	
	segundo1 = (hora1 * OPERADOR * OPERADOR) + (minuto1 * OPERADOR) + segundo1 ;
	segundo2 = (hora2 * OPERADOR * OPERADOR) + (minuto2 * OPERADOR) + segundo2 ;

	asignador = (segundo2 - segundo1) / OPERADOR ;
	
	if (asignador <= 0)
		asignador = 0 ;

	else if (asignador < 31)
		asignador = asignador * TARIFA1 ;
	
	else if (asignador < 91)
		{ asignador = asignador - 30 ;
		  asignador = (30 * TARIFA1) + (asignador * TARIFA2) ;
		}
	
	else if (asignador < 660)
		{ asignador = asignador - 90 ;
		  asignador = (30 * TARIFA1) + (60 * TARIFA2) + (asignador * TARIFA3) ;
		}
	else 
		asignador = 31.55 ;
		
	cout << "Precio a pagar: " << asignador << endl ;


/*	if (asignador >= 660)
		cout << "La tarifa es: 31,55 €" << endl ;
		
	else if (asignador >= 91)
		{	asignador  = (30 * TARIFA1) + (60 * TARIFA2) + (asignador - 60 ) * TARIFA3 ;
		cout << "La tarifa es: " << asignador << " €" << endl ;
		}
	
	else if (asignador >= 31)
		{	asignador  = 30 * TARIFA1 + (asignador - 30)  * TARIFA2 ;
		cout << "La tarifa es: " << asignador << " €" << endl ;
		}
	
	else if (asignador > 0 )
		{	asignador  = asignador * TARIFA1 ;
		cout << "La tarifa es: " << asignador << " €" << endl ;
		}
		
	else 
		cout << "Hora mal definidas, la final menor que la inicial" << endl ;
*/		
	system ("pause") ;
	return 0 ;
}
	
