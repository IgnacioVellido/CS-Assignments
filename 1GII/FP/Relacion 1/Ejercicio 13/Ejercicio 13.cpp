// Ignacio Vellido Exp�stio - F3

#include <iostream>
# include <stdlib.h>			// Busqu� en Internet la librer�a necesaria para usar la funci�n (system("pause")) por si desea utilizar el ejecutable
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
