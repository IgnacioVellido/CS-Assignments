#include <iostream>
#include <cmath>
# include <stdlib.h>
using namespace std;

int main()
{
	int numero1 , numero2 ;
	int operador1 , operador2 ;
	
	cout << "Introduzca los números: " << endl ; 
	cin >> numero1 >> numero2 ; 
	
	operador1 = numero1 % numero2 ;
	operador2 = numero2 % numero1 ;
	
	if (operador1 == 0 || operador2 == 0 )
		cout << "Son divisibles" << endl ;
	else
		cout << "No son divisibles" << endl ;
		
	system ("pause") ;
	return 0 ;
}
	
