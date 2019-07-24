// Ignacio Vellido Expósito - F3
// Exámen F2

# include <cmath>

	voir Rotar (int veces) {
		int auxiliar ;
		
		for (int i = 0 ; i < veces ; i++) {
			auxiliar = vector_utilizados[0] ;
			for (int j = 1 ; j < total_utilizados ; j++)
				vector_privado[j-1] = vector_privado[j] ;
			vector_utilizados[total_utilizados - 1] = auxiliar ;
		}
	}
	// Dando por hecho que se quieren incluir las posiciones pasadas
	int Suma (int inicio , int final) {
		int suma = 0 ;
		
		for (int i = inicio ; i <= final ; i++)
			suma += vector_utilizados[i] ;
		
		return suma ;
	}
	int PuntoEquilibrio {
		int pos = 0 ,
			 min = 0 , comparador1 , comparador2 ,
			 diferencia ;
		
		
		for (int i = 1 ; i < total_utilizados - 1  ; i++) {
			comparador1 = Suma(0 , i) ;
			comparador2 = Suma(i+1 , total_utilizados - 1 ) ;
			diferencia = abs(comparador1 - comparador2)
			
			if (diferencia < min) {
				min = diferencia ;
				pos = i ;
			}
		}
		
		return pos ;
	}
	SecuenciaEnteros Intercala (SecuenciaEnteros nueva , int k) {
		SecuenciaEnteros resultado ;
		int recorre_nueva = 0 , recorre_principal = 0 ;
		bool fin = false ;
		
		// Según el ejemplo se intercala nueva en las posiciones impares
		do {
			// Para que solo entre una vez, pongo como condición que fin sea falso
			if (recorre_nueva == nueva.Total_utilizados() && !fin) 
				fin = true  ;
				
			if ((recorre_principal + 1) % 2 == 0) {
				if (fin)
					resultado.Aniade(k)
				else {
					resultado.Aniade(nueva.Elemento(recorre_nueva)) ;
					recorre_nueva++ ;
				}
			}
			else {
				resultado.Aniade(vector_utilizados[recorre_principal]) ;
				recorre_principal++ ;
			}
		} while (recorre_principal < total_utilizados) ;
		
		// En el ejemplo viene que acaba con un número de la secuencia nueva
		if (fin)
			resultado.Aniade(k)
		else {
			resultado.Aniade(nueva.Elemento(recorre_nueva)) ;
			recorre_nueva++ ;
		}
		
		return resultado ;
	}
