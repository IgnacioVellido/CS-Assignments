// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <cmath>
using namespace std;

double raiz (double e, int x) {
	double provi , final ;
	bool salida ;
	provi = x / 2.0 ;
	do {
		final = provi - (provi * provi - x) / (2 * provi) ;		
		// la salida está pensada para que dé falso hasta que se cumpla la condición del ejercicio
		salida = abs(final - provi) > e ;
		provi = final ;
	} while (salida) ;
	return(final) ;
}

int main() {
	double e = 0.01 , resultado ;
	int x = 4 ;
	
	resultado = raiz(e,x) ;
	cout << resultado << endl ;
	
	return (0);	
}
