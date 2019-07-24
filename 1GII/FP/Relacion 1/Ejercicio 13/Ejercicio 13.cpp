// Ignacio Vellido Expóstio - F3

#include <iostream>
# include <stdlib.h>			// Busqué en Internet la librería necesaria para usar la función (system("pause")) por si desea utilizar el ejecutable
using namespace std ;

int main()
{
	int valor , primero , segundo ;
	
	cout << "Introduzca un numero de 3 digitos: " << endl ;
	cin >> valor ;
	
	primero = valor % 10 ;
	valor = valor / 10 ;
	segundo = valor % 10 ;
	valor = valor / 10 ;
	
	cout << "Sus digitos son: " << valor << " " << segundo << " " << primero << endl ;
	
	system ("pause") ;
	return 0 ;
}
