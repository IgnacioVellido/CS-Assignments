// Ignacio Vellido Expósito - F3
#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{
	int horas , casos , salario_final ;
	double salario , valoracion , mensual ;
	
	cout << "Introduzca el salario por hora, el número de horas, el número de casos \ny la media de valoraciones respectivamente" << endl;
	cin >> salario >> horas >> casos >> valoracion ;
	
	salario_final = salario * horas ;
	
	if (casos > 30)
		salario_final = salario_final * 1.04 ;
		
	cout << "El salario resultante es: " << salario_final << endl;
	
	return 0;
	system ("pause");
}
	
