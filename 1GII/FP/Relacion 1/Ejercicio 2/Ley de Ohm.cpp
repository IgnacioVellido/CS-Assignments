// Ignacio Vellido Expósito - F3

	#include <iostream>
	# include <stdlib.h>			// Busqué en Internet la librería necesaria para usar la función (system("pause")) por si desea utilizar el ejecutable
	using namespace std;
	
	int main()
	{
		double INTENSIDAD, RESISTENCIA, VOLTAJE;
		
		cout << "Introduzca el valor de la intensidad (I): " << endl;
		cin >> INTENSIDAD;
		
		cout << endl;
		
		cout << "Introduzca el valor de la resistencia (R): " << endl;
		cin >> RESISTENCIA;
		
		cout << endl;
		
		VOLTAJE = INTENSIDAD * RESISTENCIA ;
		
		cout << "Siguiendo la Ley de Ohm  (V=I*R) el valor del voltaje es: " << VOLTAJE << endl;
		
		cout << endl;
		
		system ("pause");
		return 0;
	}
		
	
	
