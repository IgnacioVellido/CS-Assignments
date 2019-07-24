#include <iostream>
#include <ctime>
#include <cstdlib>
#include <string>

using namespace std;

int main(){
	const int TAM = 10;	
	const int MIN = -10, MAX=10, NUM_VALORES = MAX-MIN+1;
	
	int A[TAM], B[TAM];
	int i, j, k, util_a, util_b = 0;
	bool cambio = true ;
	
	char C[] = {'l','a',' ','c','a','s','a',' ','d','e','l',' ','p','e','r','r','o',' ','e','s',' ','d','e',' ', 'm','a','d','e','r','a'};
	int util_c = 30 , contador = 0 ;
	string cadena = "";
	
	time_t t;
	srand ((int) time(&t));
	
	for(i = 0; i < TAM; i++)
	   A[i] = (rand() % NUM_VALORES) + MIN;

	util_a = TAM;
	
	// Mostrar vector A
	for(i = 0; i < util_a; i++) {
		cout << A[i] << " " ;
	}
	cout << endl ;
	
	// Ej 1) Mostrar la posición de los elementos positivos de A
	cout << "Numeros positivos en las posiciones: " ;
	for(i = 0; i < util_a; i++) {
		if (A[i] > 0)
			cout << i << " " ;
	}
	
	// Ej 2) Crear Vector B con los valores de las posiciones impares de A en orden inverso
	i=0;
	for(j = util_a - 1 ; j > 0 ; j = j - 2 ) {
		B[i] = A [j] ;
		i++ ;
		util_b++;
	}

	// mostrar B
	for(i = 0; i < util_b; i++) {
		cout << B[i] << " " ;
	}
	cout << endl ;

	//Ej 3) Insertar -20 en la posición 3 de B, desplazando los elementos siguientes hacia la derecha (desplazar primero)
	for(i = util_b - 1; i > 0 ; i--){
		B[i + 1] = B[i] ; 
	}
	util_b++;
	B[3] = -20 ;
	
	for(i = 0; i < util_b; i++) {
		cout << B[i] << " " ;
	}
	
	//Ej 4) Borrar el elemento en la posición 2 de B, desplazando los elementos siguientes hacia la izquierda (desplazar y decrementar util_b)
	j = B[2];
	for(i = 3; i < util_b ; i++){
		B[i - 1] = B[i] ; 
	}
	B[util_b - 1] = j ;
	for(i = 0; i < util_b; i++) {
		cout << B[i] << " " ;
	}
	
	//Ej 5) Rotar A dos posiciones a la izquierda (el primero al final dos veces(for))
	for(k = 0; k < 2 ; k++) {
		j = A[0];
		for(i = 1; i < util_a ; i++){
			A[i - 1] = A[i] ; 
		}
		A[util_a - 1] = j;
	}
	for(i = 0; i < util_a; i++) {
		cout << A[i] << " " ;
	}
	
	//Ej 6) Ordenar A
	k = 0 ;	
	for (j = 0 ; j < util_a && cambio ; j++) {	
		cambio = false ;
		for(i = 0; i < util_a; i++) {
			if (A[i] > A[i+1]) {
				k = A[i] ;
				A[i] = A[i+1] ;
				A[i+1] = k ;
				cambio = true ;
			}
		}
	}
	
	for(i = 0; i < util_a; i++) {
		cout << A[i] << " " ;
	}
	cout << endl ;


	for(i = 0; i < util_c; i++) {
		if (C[i] == ' ' ) {
			cadena += to_string(contador) + " " ;
			contador = 0 ;
		}
		else
			contador++;
	}
	// La última palabra, al no acabar en espacio, hace que el último contador no se muestre (revisar)
	cadena += to_string(contador) + " " ;

	cout << cadena << endl ;

	return 0;
}
