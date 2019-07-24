// Ignacio Vellido Expósito - F3

# include <iostream>
# include <stdlib.h>			// Busqué en Internet la librería necesaria para usar la función (system("pause")) por si desea utilizar el ejecutable
using namespace std;

int main()
{
	double X, Y, Z;
	
	cout << "Introduce valor A: " << endl;
	cin >> X;
	
	cout << endl;
		
	cout << "Introduce valor B: " << endl;
	cin >> Y;

	Z = X;
	X = Y;
	Y = Z;
	
	cout << endl;
	
	cout << "Ahora A y B valen: " << endl;
	cout << " A: " << X << endl;
	cout << " B: " << Y << endl;
	
	system("pause");
	return 0;
}
