// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <string>
using namespace std;

int sumaCuadrados(int numero) {
	int suma = 0 , digito ;
	const int OPERADOR = 10 ;
	do {
		digito = numero % OPERADOR ;
		suma += digito * digito ;
		numero /= OPERADOR ;
	} while (numero > 0) ;
	
	return suma ;	
}

int main() {
	int n , k ,
		 contador ;
	string resultado ;
	
	// Se da por hecho que el usuario introduce números enteros
	cout << "Introduzca el numero y el grado para saber si es feliz:" << endl ;
	cin >> n >> k ;

	for (contador = 0 ; contador < k ; contador++) {
		n = sumaCuadrados(n) ;
	}
	if (n == 1)
		resultado = "El numero es feliz para esa cantidad de iteraciones" ;
	else 
		resultado = "El numero no es feliz para esa cantidad de iteraciones" ;
		
	cout << resultado << endl ;
					
	return (0);	
}
