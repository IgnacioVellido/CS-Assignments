// Ignacio Vellido Exp�sito - F3
#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{
	int horas , casos ;
	double salario , valoracion , salario_final , ;
	
	cout << "Introduzca el salario por hora, el n�mero de horas, el n�mero de casos \ny la media de valoraciones respectivamente" << endl;
	cin >> salario >> horas >> casos >> valoracion ;
	
	salario_final = salario * horas ;
	salario = salario_final ;
	
	if (valoracion >= 4)												// Se sube el salario a los que tengan m�s de 4 en valoraci�n
		salario_final = salario_final + salario * 0.02 ;
	if (casos > 30)								         		// Se sube el salario a los que tengan m�s de 30 casos
		salario_final = salario_final + salario * 0.04 ;
		
	cout << "El salario resultante es: " << salario_final << endl;
	
	return 0;
	system ("pause");
}
	
