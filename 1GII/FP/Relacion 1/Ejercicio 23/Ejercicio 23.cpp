// Ignacio Vellido Exp�sito - F3

# include <iostream>
# include <stdlib.h>			// Busqu� en Internet la librer�a necesaria para usar la funci�n (system("pause")) por si desea utilizar el ejecutable
using namespace std ;

int main()
{
	int dias , horas , minutos , segundos ;
	
	cout << "Introduzca el n�mero de horas, minutos y segundos respectivamente: " << endl ;
	cin >> horas >> minutos >> segundos ;
	
	minutos = minutos + ( segundos / 60 ) ;
	segundos = segundos % 60 ;
	horas = horas + ( minutos / 60 ) ;
	minutos = minutos % 60 ;
	dias = horas / 24 ;
	horas = horas % 24 ;

	cout << endl ;
	
	cout << "La transformaci�n nos da: " << endl ;
	cout << "D�as: " << dias << endl;
	cout << "Horas: " << horas << endl;
	cout << "Minutos: " << minutos << endl;
	cout << "Segundos: " << segundos << endl;
	
	system ("pause") ;
	return 0 ;
}
