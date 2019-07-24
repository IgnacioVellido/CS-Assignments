#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{
	int primero , segundo , tercero ;
		
	cout << "Introduzca tres números" << endl ;
	cin >> primero >> segundo >> tercero ;
	
	if (primero < segundo && segundo < tercero)
		cout << "Están ordenados ascendentemente" << endl ;	
	else if (tercero < segundo && segundo < primero)
		cout << "Están ordenados descendentemente" << endl ;	
	else cout << "No están ordenados" << endl;

	return 0;
	system("pause");
}
