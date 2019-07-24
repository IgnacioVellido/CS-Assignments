// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
#include <string>
using namespace std;

int SumaDivisoresPropios (int numero) {
	int suma = 0 , divisor ;
	for (divisor = 1 ; divisor <= numero/2 ; divisor++) {
		if (numero % divisor == 0)
			suma += divisor ;
	}
	return (suma) ;
}

int main() {
	int a , b , 
		 divisores_a , divisores_b ,
		 n , contador ,
		 divisores_n , divisores_contador ;
	bool condicion1 , condicion2 ;
	string resultado1 , resultado2 = "Numeros amigos del numero introducido: ";
	
	cout << "Introduzca dos numeros para saber si son amigos: " ;
	cin >> a >> b ;
	// No se suma +1 porque ya se toma en cuenta como divisor en la función
	divisores_a = SumaDivisoresPropios(a) ;
	divisores_b = SumaDivisoresPropios(b) ;
	condicion1 = ( divisores_a == b && divisores_b == a ) ;
	
	if (condicion1)
		resultado1 = "Los numeros son amigos" ;
	else
		resultado1 = "Los numeros no son amigos" ;
	
	cout << resultado1 << endl ;
	
	cout << "Introduzca otro numero natural: " ;
	cin >> n ;
	
	divisores_n = SumaDivisoresPropios(n) ;
	
	for (contador = n - 3 ; contador <= n + 3 ; contador++) {
		divisores_contador = SumaDivisoresPropios(contador) ;
		condicion2 = ( divisores_n == contador && divisores_contador == n ) ;
		if (condicion2)
			resultado2 += contador ;
	}
	
	cout << resultado2 << endl ; 
	
	return (0);	
}
