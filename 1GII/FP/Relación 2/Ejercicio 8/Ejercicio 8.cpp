#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{
	int year , condicion1 , condicion2 ;
	bool verificador ;
	
	cout << "Introduzca el a�o: " << endl;
	cin >> year ;
	
	condicion1 = year % 100 ;
	condicion2 = year % 4 ;
	
	verificador = (condicion1 && condicion2) == 0 ;
	
	if (verificador)
		cout << "A�o bisiesto" << endl;
	else cout << "A�o no bisiesto" << endl;
		
	return 0;
	system("pause");
}
