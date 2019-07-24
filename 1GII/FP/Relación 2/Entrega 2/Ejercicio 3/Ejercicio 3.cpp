//Ignacio Vellido Expóstio - F3 (Martes)

#include <iostream>
#include <stdlib.h>
#include <cctype>
#include <cmath>
using namespace std;

int main()
{
	//		Apartado a) Dos valores enteros, A>B 
	
	int numero_A , numero_B ;
		
	do{
		cout << "Introduzca dos números (A,B) que cumplan A > B " << endl ;
		cin >> numero_A >> numero_B ;
	}while (numero_A <= numero_B) ;
		
	-----------------------------------------------------------------------
	//		Apartado b) Char != dígito 
	
	char caracter_c ;
	
	do{
		cout << "Introduzca un carácter no numérico" << endl ;
		cin >> caracter_c ;
	}while (caracter_c >= '0' && caracter_c <= '9') ;
	
	
	----------------------------------------------------------------------
	//	Apartado c) Dos reales (A,B), se cumple que el valor absoluto de la diferencia es mayor que 0,1 milésimas
	
	double numero_A , numero_B , diferencia ;
	bool condicion ;
	
	do{
		cout << "Introduzca dos reales" << endl ;
		cin >> numero_A >> numero_B ;
		
		diferencia = abs (numero_A - numero_B);
		condicion = diferencia < pow (10,-4) ;
		
	}while (condicion) ;
	
	----------------------------------------------------------------------
	//	Apartado d) Tres enteros (A,B,C) y tienen que estar en orden ascendente o descendente
	
	int numero_A , numero_B , numero_C ;
	bool condicion ;
	
	do{
		cout << "Introduce tres enteros" << endl ;
		cin >> numero_A >> numero_B >> numero_C ;
		
		// condicion = (numero_A < numero_B || numero_B < numero_C) && (numero_A > numero_B || numero_B > numero_C) ;	- No se me ocurre otra manera de simplificarlo,
		condicion = (numero_B < numero_C && numero_A > numero_B) || (numero_A < numero_B && numero_B > numero_C) ; 	  // solo cambiando los operadores
	}while (condicion) ;
	
	return 0 ;
	system("pause") ;
}
