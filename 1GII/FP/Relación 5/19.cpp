// Ignacio Vellido Expósito - F3
// 19 V
// Falla cuando no hay elementos

# include <iostream>
using namespace std ;

class ConjuntoOrdenado {
	private:
		static const int TAM = 50 ;
		int vector_privado[TAM] ;
		int total_utilizados ;
	public :
		ConjuntoOrdenado ()
			:total_utilizados(0) {
			}
		int TotalUtilizados () {
			return total_utilizados ;
		}
		int Elemento (int n) {
			return vector_privado[n] ;
		}
		void Aniade (int elemento) {
			// Falla cuando no hay elementos
			for (int i = 0 ; i < total_utilizados ; i++) {
				if (elemento >= vector_privado[i] && elemento <= vector_privado[i+1])
					// Se desplaza el vector una posición a la derecha a partir del número anterior a elemento 
					for (int j = total_utilizados ; j > i ; j--)
						vector_privado[j+1] = vector_privado[j] ;
					total_utilizados++ ;
					vector_privado[i+1] = elemento ;
			}
		}
		ConjuntoOrdenado Union (ConjuntoOrdenado conj2) {
			ConjuntoOrdenado total ;
			bool encontrado ;
			
			for (int i = 0 ; i < total_utilizados ; i++) {
				total.Aniade(vector_privado[i]) ;
			}
			for (int j = 0 ; j < conj2.TotalUtilizados() ; j++) {
				encontrado = false ;
				// Se podría buscar en "total", pero al contenener los mismos elementos que el objeto actual, no importa
				for (int i = 0 ; i < total_utilizados && !encontrado ; i++) {
					if (conj2.Elemento(j) == vector_privado[i])
						encontrado = true ;
				}
				if (!encontrado)
					total.Aniade(conj2.Elemento(j)) ;
			}
			return total ;
		}
		ConjuntoOrdenado Interseccion (ConjuntoOrdenado conj2) {
			ConjuntoOrdenado interseccion ;
			for (int i = 0 ; i < total_utilizados ; i++) {
				for (int j = 0 ; j < conj2.TotalUtilizados() ; j++) {
					if (vector_privado[i] == conj2.Elemento(j))
						interseccion.Aniade(vector_privado[i]) ;
				}
			}
			return interseccion ;
		}
} ;

int main () {
	ConjuntoOrdenado lista1 , lista2 ;
	ConjuntoOrdenado suma , intersec ;
	
	for (int i = 0 ; i < 1000 ; i++)
		lista1.Aniade(i) ;
	for (int i = 0 ; i < 1000 ; i=i+2)
		lista2.Aniade(i) ;
	
	intersec = lista1.Interseccion(lista2) ;
	suma = lista2.Union(lista1) ;
	
	// Mostrando los elementos, algunos se podrían hacer dentro de los bucles anteriores
	for (int i = 0 ; i < lista1.TotalUtilizados() ; i++) 
		cout << lista1.Elemento(i) ;
	cout << endl ;
	for (int i = 0 ; i < lista2.TotalUtilizados() ; i++) 
		cout << lista2.Elemento(i) ;
	cout << endl ;
	for (int i = 0 ; i < intersec.TotalUtilizados() ; i++) 
		cout << intersec.Elemento(i) ;
	cout << endl ;
	for (int i = 0 ; i < suma.TotalUtilizados() ; i++) 
		cout << suma.Elemento(i) ;
	cout << endl ;
	
	return 0 ;
}
