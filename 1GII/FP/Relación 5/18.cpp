// Ignacio Vellido Expósito - F3
// 18 V

# include <iostream>
using namespace std;

class SecuenciaCaracteres {
	private:
		static const int TAM = 50 ;
		char vector_utilizados[TAM] ;
		int total_utilizados ;
	public:	
		SecuenciaCaracteres () 
			:total_utilizados(0){
			}
		void Aniade (char elemento) {
			vector_utilizados[total_utilizados] = elemento ;
			total_utilizados++ ;
		}
		int TotalUtilizados () {
			return total_utilizados ;
		}
		char Elemento (int posicion) {
			return vector_utilizados [posicion] ;
		}
		void Replace (int posicion, int eliminar, SecuenciaCaracteres nueva) {
			int desplazamiento = nueva.TotalUtilizados - eliminar ;
			
			for (int z ; z < desplazamiento ; z++) {
				// Se podría a llamar a un método desplaa a la derecha
				for (int i ; i < total_utilizados - 1 ; i++) {
					vector_utilizados [i + 1] = vector_utilizados [i] ;
					total_utilizados++ ;
				}
			}
			
			int recorre_nueva = 0 ;
			for (int inicio = posicion ; inicio < eliminar ; inicio++) {
				vector_utilizados [inicio] = nueva.Elemento(recorre_nueva) ;
				recorre_nueva++ ;
			}
		}
} ;

int main () {
	SecuenciaCaracteres secuencia1 , secuencia2 ;
	const char TERMINADOR = '#' ;
	char entrada ;
	int pos , n ;
	
	cout << "Introduzca la secuencia 1" << endl ;
	do {
		cin >> entrada ;
		secuencia1.Aniade(entrada) ;
	} while (entrada != TERMINADOR) ;
	
	cout << "Introduzca la secuencia 2" << endl ;
	do {
		cin >> entrada ;
		secuencia2.Aniade(entrada) ;
	} while (entrada != TERMINADOR) ;
	
	cout << "Introduzca la posicion de inicio en la secuencia 1 y el numero de caracteres a reemplazar" << endl ;
	cin >> pos >> n ;
	
	secuencia1.Replace(pos , n , secuencia2) ;
	
	for (int i ; i < secuencia1.TotalUtilizados() ; i++) {
		cout << secuencia1.Elemento(i) ;
	cout << endl ;
	
	return 0 ;
}
