#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{
	int primero , segundo , tercero ;
		
	cout << "Introduzca tres n�meros" << endl ;
	cin >> primero >> segundo >> tercero ;
	
	if (primero < segundo && segundo < tercero)
		cout << "Est�n ordenados ascendentemente" << endl ;	
	else if (tercero < segundo && segundo < primero)
		cout << "Est�n ordenados descendentemente" << endl ;	
	else cout << "No est�n ordenados" << endl;

	return 0;
	system("pause");
}
