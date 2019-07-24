//Ignacio Vellido Expóstio - F3

#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{
	char letra;
	
	do {
		cout << "Introduzca una mayúscula: " ;
		cin >> letra ;
		
	} while (letra < 'A' || letra > 'Z') ;
	
	letra = letra + ('a' - 'A')  ;
	
	cout << "Su minúscula: " << letra << endl ;
	
	return 0;
	system("pause");
}
