//Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <stdlib.h>
#include <cctype>
using namespace std;

int main() 
{
	const int TERMINADOR = -1 ;
	int sucursal , 
		 contador , contador_1 , contador_2 , contador_3 , 
		 max ;
	char producto ;	// En el enunciado se especifican 3 tipos dirferentes de productos, pero no se hace uso de ninguno
							// de ellos, por lo que lo dejo que como uno.
	
	cout << "Introduzca el identificador de sucursal, el codigo del producto y las unidades vendidas (para terminar introduzca -1)"  << endl ;
	cin >> sucursal ;
	
	while (sucursal != TERMINADOR) {
		cin >> producto >> contador ; 
		
		if (sucursal == 1)
			contador_1 = contador_1 + contador ;
		else if (sucursal == 2)
			contador_2 = contador_2 + contador ;
		else
			contador_3 = contador_3 + contador ;
			
		cin >> sucursal ;
	}
	
	if (contador_1 > contador_2)
		max = 1 ;
	else 
		max = 2 ;
	if (contador_2 < contador_3)
		max = 3 ;
				
	cout << "La sucursal que mas productos vendio fue: " << max << endl ;
	
	return 0;
	system ("pause");
}
