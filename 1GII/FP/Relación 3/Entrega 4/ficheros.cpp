// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
using namespace std;

// Indicar número intermedio de tres
int central (int primero, int segundo, int tercero) {
	int centro ;
	
	if (primero < segundo)
		centro = primero ;
	else
		centro = segundo ;
	if (tercero > centro)
		centro = tercero ;		
			
	return (centro) ;
}

// Devuelve el número de dígitos
int digitos (int entero) {
	int contador = 0 ;
	const int OPERADOR = 10 ;
	
	do {
		entero = entero / OPERADOR ;
		contador++ ;
	} while (entero > 0) ;
	
	return (contador);
}

// Se suma si el número es par
int suma (int k, bool pares) {
	int numero , suma = 0 ;
	const int OPERADOR = 10 ;
	
	do {
		numero = k % OPERADOR ;
		if (pares) {
			if (numero % 2 == 0)
				suma += numero ;	
			}
		else {
			if (numero % 2 != 0)
				suma += numero ;
			}
		k /= OPERADOR ;
	} while (k > 0) ;
		
	return (suma);
}

// Sumar las cifras pares o las impares
int sum (int k, bool pares) {
	int numero , sum = 0 , contador = 0 ;
	const int OPERADOR = 10 ;
	
	do {
		numero = k % OPERADOR ;
		if (pares) {
			if (contador % 2 == 0)
				sum += numero ;
		}
		else {
			if (contador % 2 != 0)
				sum += numero ;
		}
		k /= OPERADOR ;
		contador++ ;	
	} while (k > 0) ;
	
	return (sum) ;
}

int main () {
	int primero = 10 , segundo = -3 , tercero = 1 , entero = 2 , k = 243341 ; 
	bool pares = true ;
	
// Para ahorrar variables pongo las operaciones en los cout	
	cout << central(primero,segundo,tercero) << endl ;
	cout << digitos(entero) << endl ;
	cout << suma(k,pares) << endl ;
	cout << sum(k,pares) << endl ;	

	return 0;	
}
