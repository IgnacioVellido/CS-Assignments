//Ignacio Vellido Exp�stio - F3 (Martes)

#include <iostream>
#include <stdlib.h>
using namespace std;

int main()
{
	double precio , importe ;													
	int cambio , 
		 uno , cincuenta , veinte , diez , cinco ;
	
	cout << "Inserte el precio y el importe introducido" << endl ;
	cin >> precio >> importe ;

	importe =  importe - precio ;
	cambio = importe * 100 ; 															// Pasando a c�ntimos el cambio
	
	uno = cambio / 100 ;
	cambio = cambio % 100 ;
	cincuenta = cambio / 50 ;
	cambio = cambio - (cincuenta * 50) ;
	
	if (cambio >= 20 ) {
		veinte = cambio / 20 ;
		cambio = cambio - (veinte * 20) ;
	}
	if (cambio >= 10) {
		diez = cambio / 10 ;
		cambio = cambio - (diez * 10) ;
	} 
	
	cinco = (cambio % 10) / 5 ;
	
	cout << "Monedas de 1 euro: " << uno << endl ;
	cout << "Monedas de 50 c�ntimos: " << cincuenta << endl ;
	cout << "Monedas de 20 c�ntimos: " << veinte << endl ;
	cout << "Monedas de 10 c�ntimos: " << diez << endl ;
	cout << "Monedas de 5 c�ntimos: " << cinco << endl ;
	
	return 0 ;
	system("pause") ;
}
