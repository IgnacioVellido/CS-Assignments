// Ignacio Vellido Expósito - F3

# include <stdlib.h>			// Busqué en Internet la librería necesaria para usar la función (system("pause")) por si desea utilizar el ejecutable
# include <iostream>
using namespace std;

int main()
{
	double salario_base ;
	
	cout << "Introduzca su salario base: " << endl ;
	cin >> salario_base ;
		cout << endl ;
		
	salario_base = salario_base * 1.02 ; 
	
	/* Para no aumentar el tamaño asignado con otra variable, modifico la variable "salario_base" 
	con la operación necesario. Tampoco hago el cálculo en la sentencia "cout" para no
	sobrecargar la línea y dificultar la lectura */
	
	cout << "El salario final es: " << salario_base << endl; 
		cout << endl ;
	
	system ("pause") ;
	return 0 ;
}
