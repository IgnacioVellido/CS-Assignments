// Ignacio Vellido Expósito - F3 
// Sacar filas y añadir filas de la clase Tabla

class Tabla 
	private:
		static const int FIL = 20 , COL = 20 ;
		int vector_utilizados[FIL][COL] ;
		int util_filas , util_columnas ;
	public:
		Tabla() 
		:util_filas(0) , util_columnas(0) {
		}
		void Aniade_fila (SecuenciaEnteros lista) {
			// Precondición: el tamaño de la lista es igual al tamaño de la tabla
			for (int recorre_lista = 0 ; recorre_lista < lista.TotalUtilizados() ; recorre_lista++) {
					vector_utilizados[util_filas][recorre_lista] = lista.Elemento(recorre_lista) ;
			}
			
			util_filas++ ;
		}
		void GetFila (int indice) {
			SecuenciaEnteros fila ;
			
			for (int i = 0 ; i < util_columnas ; i++) 
				fila.Aniade(vector_utilizados[indice][i]) ;
			
			return fila :
}
