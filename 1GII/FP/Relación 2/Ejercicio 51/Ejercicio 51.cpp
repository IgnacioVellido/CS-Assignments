// Ignacio Vellido Expósito - F3 (martes)

#include <iostream>
using namespace std;

int main () {
	int numero , i , k , h , j , l ;
	
	cin >> numero ;
	h = numero / 2 ;
	j = 1 ;
	
	for (i = h ; i >= 0 ; i--) {
		for (k = i ; k > 0 ; k--) {
			cout << " " ;
		}
		for (l = j ; l > 0 ; l--) {
			cout << "*" ;
		}
		cout << endl ;
		j= j + 2 ;
	}
	for (i = 0 ; i < 2 ; i++ ) {
		for (k = h ; k > 0 ; k--) {
			cout << " " ;
		}
		for (j = h ; j > 0 ; j--) {
			cout << "*" ;
		}
		cout << endl ;
	}
	return 0;	
}
