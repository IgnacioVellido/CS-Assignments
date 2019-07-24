// Ignacio Vellido Expóstio - F3

#include <iostream>
#include <stdlib.h>
#include <string>			
using namespace std ;

int main()
{	
	int min , max , nuevo , contador ;
	string frase ;
	bool condicion ;
	
	do {
		cout << "Introduzca un valor positivo (min): " ;
		cin >> min ;
	} while (min < 0) ;
	do {
		cout << "\nIntroduzca un valor mayor que 'min' (max): " ;
		cin >> max ;
	} while (max < min) ;
	
	contador = 0 ;
	
	do {
		cout << "\nIntroduzca un valor dentro del intervalo (min, max): " ;
		cin >> nuevo ; 
		contador++ ;
		condicion = (nuevo < min || nuevo > max) ;
		} while ( condicion && contador <3) ;
	
	if (!condicion) {
		min = nuevo - min ;
		max = max - nuevo ;
		frase = "\nLos resultados son: " + to_string(min) + " y " + to_string(max) ;
	}
	else 
		frase = "\nNumero de intentos sobrepasado" ;
	
	cout << frase << endl ;
	
	system ("pause") ;
	return 0 ;
}
