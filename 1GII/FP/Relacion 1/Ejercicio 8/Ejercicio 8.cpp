// Ignacio Vellido Exp�sito - F3

# include <iostream>
# include <stdlib.h>			// Busqu� en Internet la librer�a necesaria para usar la funci�n (system("pause")) por si desea utilizar el ejecutable
using namespace std ;

int main ()
{
	double metros , pulgadas , pies , yardas , millas ;
	
	cout << "Introduzca la cantidad de metros: " << endl;
	cin >> metros ;
	
	pulgadas = metros / 0.0254 ;
	pies = metros / 0.3048 ;
	yardas = metros / 0.9144 ;
	millas = metros / 1609.344 ;
	
	cout << "Las conversiones son: " << endl ;
	cout << "Pulgadas: " << pulgadas << endl ;
	cout << "Pies: " << pies << endl ;
	cout << "Yardas: " << yardas << endl ;
	cout << "Millas: " << millas << endl ;
	
	system ("pause") ;
	return 0 ;
}
