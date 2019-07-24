// Ignacio Vellido Expóstio - F3

#include <iostream>
# include <stdlib.h>	
using namespace std ;

int main()
{
	int multiplicando , multiplicador , resultado = 0 ;
	bool impar ;
	
	cout << "Ingrese los numeros que desea multiplicar" << endl ;
	cin >> multiplicando >> multiplicador ;
	
do {
		impar = (multiplicando + 1) % 2 == 0 ;
		if (impar)
			resultado = resultado + multiplicador ;
		multiplicando = multiplicando / 2 ;
		multiplicador = multiplicador / (1/2.0) ;
	} while (multiplicando >= 1 ) ;
	
	cout << "El resultado de la multiplicacion es: " << resultado << endl ;
	return 0 ;
	system ("pause") ;
}

/* 	do {
			impar = (multiplicador + 1) % 2 == 0 ;
			if (impar)
				resultado = resultado + operador ;
			contador++ ;
			operador = pow(2, contador) ;
			multiplicador = multiplicador / 2 ;
		} while (multiplicador >= 1 ) ;
			
*/
