//Ignacio Vellido Expóstio - F3

#include <iostream>
#include <stdlib.h>
#include <string>
using namespace std;

int main()
{
	int puntos_A , puntos_B , comparador ;
	bool empate ;
	string resultado ;
	
	cout << "Introduzca los resultados de A y B respectivamente" << endl ;
	cin >> puntos_A >> puntos_B ;
	
	comparador = puntos_A - puntos_B ;
	empate = puntos_A == puntos_B ;
	
	// Se compara entre el empate y las distintas posibilidades
	
	if (empate)
		resultado = "El equipo A empató con B" ;
	else if (comparador > 0)
	{	if (comparador >=20)
			resultado = "El equipo A derrotó ampliamente a B" ;
		else	 
			resultado = "El equipo A derrotó a B" ;
	}
	else
	{	if (comparador <= -20)
			resultado = "El equipo B derrotó ampliamente a A" ;
		else	 
		   resultado = "El equipo B derrotó a A" ;	
	}
	
	cout << resultado << endl;
	
	return 0;
	system("pause");
}
