// Ignacio Vellido Expósito - F3
// 14 V

class SecuenciaCarateres {
	private:
		static const int TAM = 50 ;
		char vector_utilizados[TAM] ;
		int total_utilizados ;
	public:
		bool ExisteRango (int inicio, int final, char letra){
			bool existe = false ;
			
			for (inicio ; inicio < final; inicio++){
				if (vector_utilizados[inicio] == letra)
					existe = true ;
			}
			
			return existe ;
		}
		bool Similares (SecuenciaCaracteres sec2){
			bool similar = true ;
			bool comprueba[total_utilizados] ;
			
			int primero = sec2.Elemento(0) , 
				 ultimo = sec2.Elemento(sec2.TotalUtilizados()) ;
				 
			if (total_utilizados != sec2.TotaUtilizados()) 
				similar = false ;	 
			else if ( primero != vector_utilizados[0] || ultimo != vector_utilizados[total_utilizados])
				similar = false ;
			else {
				// Añadimos al booleano los posiciones primera y última
				comprueba[0] = true ;
				comprueba[sec2.TotalUtilizados()] = true ;
				
				// Buscamos el resto
				for (int i = 1 ; i < total_utilizados - 1 ; i++) {
					comprueba[i] = sec2.ExisteRango(0 , sec2.total_utilizados - 1 , Elemento(i))
					/*for (int j = 1 ; j < sec2.TotalUtilizados - 1; j++){
						if (vector_utilizados[i] == sec2.Elemento(j))
							comprueba[j] = true ;
					}*/
				}
				
				// Comprobamos que están todos
				for (int i = 0 ; i < total_utilizados ; i++) {
					if (!comprueba[i])
						similar = false ;
				}
				
			}	
				
			return similar ;
		}
};

int main () {
	
}
