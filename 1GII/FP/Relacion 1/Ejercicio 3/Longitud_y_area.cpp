// Ignacio Vellido Exp�sito - F3

# include <iostream>
# include <stdlib.h>			// Busqu� en Internet la librer�a necesaria para usar la funci�n (system("pause")) por si desea utilizar el ejecutable
using namespace std;

int main()
{
	double RADIO, LONGITUD, AREA, PI ;
	
	PI = 3.141592 ;
	
	cout << "Introduzca el valor del radio: " << endl ;
	cin >> RADIO ;
		cout << endl ;
		
	LONGITUD = 2 * RADIO	* PI ;
	AREA = PI * RADIO * RADIO ;
	
	cout << "La longitud de la circunferencia vale: " << LONGITUD << endl ;
		cout << endl ;
	cout << "El �rea de la circunferencia vale: " << AREA << endl ;
		cout << endl ;
		
	system ("pause") ;
	return 0 ;
}
