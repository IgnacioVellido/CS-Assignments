//Ignacio Vellido Exp�stio - F3

#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{
	char letra;
	
	do {
		cout << "Introduzca una may�scula: " ;
		cin >> letra ;
		
	} while (letra < 'A' || letra > 'Z') ;
	
	letra = letra + ('a' - 'A')  ;
	
	cout << "Su min�scula: " << letra << endl ;
	
	return 0;
	system("pause");
}
