// Ignacio Vellido Expósito - F3

#include <iostream>
using namespace std;
const int COL = 10 , FIL = 15 ;


int main() {
	// const int MAX_VOCALES = 5 ;
	// const char vocales[MAX_VOCALES] = { 'a' , 'e' , 'i', 'o', 'u' } ;
	char grafica [FIL][COL] = { };
	char B [30][30] ;
	const int frecuencia [5] = {10, 2 ,7, 8, 4} ;
	
	int i , j , k , c , f = 0 ;
	
	for (j = 0; j < FIL ; j++) {	
		c = 0 ;
		while (c < 2) {
			for (k = 0; k < frecuencia[f] ; k++) 
				grafica[i][k] = '*' ;
			i++ ;
			c++ ;
		}
		i++ ;
		f++ ;
	}

	
	for (i = 0; i < FIL ; i++) {
		for (j = 0; j < COL ; j++) {
				cout << grafica[i][j] ;
			}
			cout << endl ;
	}
	
	cout << "\n\n" ;
	
/*	// ¡ A rotar !
	for (i = 0 ; i < FILAS ; i++) {
		for (j= 0 ; j < COL ; j++) {
			B[FILAS - 1 - j][i] = grafica[i][j] ;
		}
	}
	
	
	for (i = 0; i < 30 ; i++) {
		for (j = 0; j < 30 ; j++) {
				// B[i][j] = 'a' ;
				cout << B[i][j] ;
			}
			cout << endl ;
	}
*/	
	
	return 0;	
}

/* Intento con clases
	class grafica {
	char m[30][30] ;
	void rotar (char m[30][30]) {
		for (int i = 0 ; i < 30 ; i++) {
			for (int j= 0 ; j < 30 ; j++) {
				m[FIL - 1 - j][i] = m[i][j] ;
			}
		}
	} ;
	void mostrar (char m[30][30]) {
		for (int i = 0; i < 30 ; i++) {
			for (int j = 0; j < 30 ; j++) {
					cout << m[i][j] ;
				}
			cout << endl ;
	}
}

		for (j = 0; j < 30 ; j++) {	
		c = 0 ;
		while (c < 2) {
			for (k = 0; k < frecuencia[f] ; k++) 
				grafica.m[i][k] = '*' ;
			i++ ;
			c++ ;
		}
		i++ ;
		f++ ;
	}

	grafica.mostrar ;
		
*/


/*
Versión bestia 
for (i = 0; i < ALTO ; i++) {
		if ( i == 0 || i == 1) {
			for (k = 0; k < 5 ; k++) 
				grafica[i][k] = '*' ;
			}
		if ( i == 3 || i == 4) {
			for (k = 0; k < 7 ; k++) 
				grafica[i][k] = '*' ;
			}
		if ( i == 6 || i == 7) {
			for (k = 0; k < 4 ; k++) 
				grafica[i][k] = '*' ;
			}
		if ( i == 9 || i == 10) {
			for (k = 0; k < 2 ; k++) 
				grafica[i][k] = '*' ;
			}
		if ( i == 12 || i == 13) {
			for (k = 0; k < 10 ; k++) 
				grafica[i][k] = '*' ;
			}
		
		for (j = 0; j < LARGO ; j++) {
			cout << grafica[i][j] ;
		}
		cout << endl ;
	}
*/

/*	
Mejorando
for (j = 0; j < ALTO ; j++) {	
		c = 0 ;
		while (c < 2) {
			for (k = 0; k < frecuencia[f] ; k++) 
				grafica[i][k] = '*' ;
			i++ ;
			c++ ;
		}
		i++ ;
		f++ ;
	}
	
	for (i = 0; i < ALTO ; i++) {
		for (j = 0; j < LARGO ; j++) {
				cout << grafica[i][j] ;
			}
			cout << endl ;
	}
	*/
	
/* Rotar 1º
		for (i = 0 ; i < LARGO ; i++) {	
		for (j = 0 ; j < ALTO ; j++) {
			B[j][i] = grafica [LARGO - 1 - i][j] ;
		}
	}
	
	for (i = 0; i < ALTO ; i++) {
		for (j = 0; j < LARGO ; j++) {
				cout << B[i][j] ;
			}
			cout << endl ;
	}
*/	
