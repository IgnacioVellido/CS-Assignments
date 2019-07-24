// Ignacio Vellido Expósito - F3

#include <iostream>
#include <stdlib.h>
#include <string>
using namespace std;

int fibonacci (int orden){
	int anterior = 1 , total = 0 , suma = 0 , contador ;
	
	for (contador = 1 ; contador <= orden ; contador++ ) {	
		suma = total + anterior ;
		anterior = total ;
		total = suma ;
	}
	return (suma) ;
}

int main(){
	int numero , limite , contador , resultado , suma ;
	string solucion = "La sucesion de Fibonaci hasta el limite es: " ;
	
	cout << "Introduzca el orden del numero de Fibonacci: " ;
	cin >> numero ;
	cout << "Introdzca el limite de la sucesion: " ;
	cin >> limite ;
	
	for (contador = 1 ; contador <= limite ; contador++ ) {	
		suma = fibonacci(contador) ;
		solucion = solucion + " " + to_string(suma) ; 
	}
	
	resultado = fibonacci(numero) ;
	
	cout << "El numero de Fibonacci de orden " << numero << " es: " << resultado << endl ; 
	cout << solucion ;

	return 0;
	system ("pause");	
}
