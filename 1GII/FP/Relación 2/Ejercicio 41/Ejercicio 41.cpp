// Ignacio Vellido Expósito - F3 (Martes)

#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{
	int n , m , diferencia , auxiliar ,
		 contador = 0 ;
	
	cout << "Introduzca los numeros \"n\" y \"m\" (n >= m): " << endl ;
	cin >> n >> m ;
	
	auxiliar = n ;
	contador_1 = n ;
	contador_2 = m ;
	diferencia = n - m ;
	
	while (contador_1 > 1) {
		n-- ;
		auxiliar = auxiliar * n;
		contador-- ;
	}
	while (contador_2 > 1)
	
	cout << auxiliar << endl ;
	
	
	return (0);
	system ("pause");
}
