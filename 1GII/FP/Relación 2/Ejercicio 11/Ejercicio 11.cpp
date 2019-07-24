// Ignacio Vellido Expósito - F3
#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{
	int horas , casos ;
	double salario , valoracion , salario_final ;
	
	cout << "Introduzca el salario por hora, el número de horas, el número de casos \ny la media de valoraciones respectivamente" << endl;
	cin >> salario >> horas >> casos >> valoracion ;
	
	salario_final = salario * horas ;
	
	if (valoracion >= 4) 											// Se sube el salario a los que tengan más de 4 en valoración
		salario_final = salario_final * 1.02 ;
	if (casos > 30)													// Se sube el salario a los que tengan más de 30 casos
		salario_final = salario_final * 1.04 ;	
	else if (casos >= 20)
		salario_final = salario_final * 1.03 ; 				// Se sube el salario a los que tengan entre 20 y 30 casos
		
	cout << "El salario resultante es: " << salario_final << endl;
	
	return 0;
	system ("pause");
}
	
