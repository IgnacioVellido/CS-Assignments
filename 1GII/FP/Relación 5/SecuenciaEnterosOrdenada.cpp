// Ignacio Vellido Expósito - F3

class SecuenciaEnterosOrdenada {
	private:
		static const int TAM = 50 ;
		int vector_utilizados[TAM] ;
		int total_utilizados ;
	public:
		SecuenciaEnterosOrdenada AniadeSecuencia (SecuenciaEnterosOrdenada sec2) {
			SecuenciaEnterosOrdenada final ;
			int recorre1 = 0 , recorre2 = 0 ;
			int ele1, ele2
			
			do {
				ele1 = Elemento(recorre1);
				ele2 = sec2.Elemento(recorre2) ;
				if (ele1 < ele2) {	
					final.Aniade(ele1) ;
					recorre1++ ;
				}
				else {
					final.Aniade(ele2) ;
					recorre2++ ;
				}
			} while (recorre1 < total_utilizados && recorre2 < sec2.TotalUtilizados()) ;
			
			// Sobra el if/else , porque si no si ha salido del while no va a entrar en uno de los for
			//if (recorre1 < total_utilizados) {
			for (recorre1 ; recorre1 < total_utilizados ; recorre1++) 
				fila.Aniade(vector_utilizados[recorre1]) ;
			//else 
			for (recorre2 ; recorr2 < sec2.total_utilizados ; recorre2++) 
				fila.Aniade(sec2.vector_utilizados[recorre2]) ;
					
			return final ;
		}
}
