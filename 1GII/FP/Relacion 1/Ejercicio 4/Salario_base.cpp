// Ignacio Vellido Exp�sito - F3

# include <stdlib.h>			// Busqu� en Internet la librer�a necesaria para usar la funci�n (system("pause")) por si desea utilizar el ejecutable
# include <iostream>
using namespace std;

int main()
{
	double salario_base ;
	
	cout << "Introduzca su salario base: " << endl ;
	cin >> salario_base ;
		cout << endl ;
		
	salario_base = salario_base * 1.02 ; 
	
	/* Para no aumentar el tama�o asignado con otra variable, modifico la variable "salario_base" 
	con la operaci�n necesario. Tampoco hago el c�lculo en la sentencia "cout" para no
	sobrecargar la l�nea y dificultar la lectura */
	
	cout << "El salario final es: " << salario_base << endl; 
		cout << endl ;
	
	system ("pause") ;
	return 0 ;
}
