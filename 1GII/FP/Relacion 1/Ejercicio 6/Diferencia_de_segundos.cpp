// Ignacio Vellido Expósito - F3

# include <stdlib.h>			// Busqué en Internet la librería necesaria para usar la función (system("pause")) por si desea utilizar el ejecutable
# include <iostream>
using namespace std;

int main()
{
	int horas1 , minutos1 , segundos1 ;
	
	cout << "Introduzca el número de horas, minutos y segundos iniciales: " << endl,
	cin >> horas1 ;
	cin >> minutos1 ;
	cin >> segundos1 ;
	
	segundos1 = ( horas1 * 3600 ) + ( minutos1 * 60 ) + segundos1 ;
	
	int horas2 , minutos2 , segundos2 ;
	
	cout << "Introduzca el número de horas, minutos y segundos finales: " << endl,
	cin >> horas2 ;
	cin >> minutos2 ;
	cin >> segundos2 ;
	
	segundos2 = ( horas2 * 3600 ) + ( minutos2 * 60 ) + segundos2 ;
	
	int diferencia ;
	
	diferencia = segundos2 - segundos1 ;
	
	cout  << "La diferencia de segundos entre los dos instantes es: " << diferencia << endl ;
	
	system ("pause") ;
	return 0 ;
}
