#include <iostream>
#include <cctype>
# include <stdlib.h>	
using namespace std;

int main()
{
	char letra_original , letra_convertida ;
	const int OPERADOR = 'a' - 'A' , comparador_1 = 'A' , comparador_2 = 'Z' ;
	
	cout << "Introduzca un carácter: " << endl ; 
	cin >> letra_original ; 
	
	if (letra_original >= comparador_1 && letra_original <= comparador_2 )
		letra_convertida = letra_original + OPERADOR ;
	else 
		letra_convertida = letra_original ;
	
	cout << "El resultado es: " << letra_convertida << endl ;
	
	system ("pause") ;
	return 0 ;
}
