// Ignacio Vellido Exp�sito - F3
/* En el enunciado del ejercicio el resultado propuesto est� mal, pues intercambia 
"x" por "z", "y" por "x"  y "z" por "y" */

# include <iostream>
# include <stdlib.h>			// Busqu� en Internet la librer�a necesaria para usar la funci�n (system("pause")) por si desea utilizar el ejecutable
using namespace std ;

int main()
{	
	int variable_x , variable_y , variable_z , intercambiador ;
	
	cout << "Introduzca el valor de las variables \"X\", \"Y\", \"Z\" respectivamente: " << endl ;
	cin >> variable_x >> variable_y >> variable_z ;
	
	intercambiador = variable_x ;
	variable_x = variable_z ;
	variable_z = variable_y ;
	variable_y = intercambiador ;
	
	cout << endl ;
	
	cout << "Ahora cada variable vale: " << endl;
	cout << "X: " << variable_x << endl;
	cout << "Y: " << variable_y << endl;
	cout << "Z: " << variable_z << endl;

	system ("pause") ;
	return 0 ;
}
