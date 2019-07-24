// Ignacio Vellido Expóstio - F3

#include <iostream>
#include <stdlib.h>			// Busqué en Internet la librería necesaria para usar la función (system("pause")) por si desea utilizar el ejecutable
using namespace std ;

int main()
{
	long int inicial , final ;
	int natalidad , mortalidad , migracion ;
	double t_natalidad , t_mortalidad , t_migracion ;
	
	cout << "Introduzca la poblacion inicial: " << endl ;
	cin >> inicial ;
	cout << "Introduzca la tasa de natalidad: " << endl ;
	cin >> natalidad ;
	cout << "Introduzca la tasa de mortalidad: " << endl ;
	cin >> mortalidad ;
	cout << "Introduzca la tasa de migracion: " << endl ;
	cin >> migracion ;
	
	t_natalidad = natalidad / 1000.0 ;
	t_mortalidad = mortalidad / 1000.0 ;
	t_migracion = migracion / 1000.0 ;
	
	final = inicial + ( inicial * t_natalidad ) - ( inicial * t_mortalidad ) + ( inicial * t_migracion ) ;
	final = final + ( final * t_natalidad ) - ( final * t_mortalidad ) + ( final * t_migracion ) ;
	final = final + ( final * t_natalidad ) - ( final * t_mortalidad ) + ( final * t_migracion ) ;
	
	cout << "La poblacion final es: " << final << endl ;	

	system ("pause") ;
	return 0 ;
}
