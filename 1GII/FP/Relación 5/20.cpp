// Ignacio Vellido Expósito - F3
// 20 V
// Pensé en un vector de boolianos pero realmente la única importante sería la última, por eso se usa a_buscar
// Habría que revisar si se puede acceder bien a todas las componentes de C2

bool Contiene (SecuenciaCaracteres C2) {
	bool contiene = false ; // Secuencia encontrada
	bool condicion_salida ;
	int a_buscar ;
	int buscador ;
	
	for (int recorre_C1 = 0 ; i < total_utilizados && !contiene ; recorre_C1++) {
		
		condicion_salida = false ;
		
		if (vector_privado[recorre_C1] == C2.Elemento(0)) {
			// Se ha encontrado la primera letra de C2
			a_buscar = 1 ;
			// Para que busque a partir de la siguiente posición de C1
			buscador = recorre_C1 + 1 ;
			do {
				// Si encuentra una letra que ya había sido encontrada, sale
				for (int terminar = 0 ; terminar < a_buscar && !condicion_salida ; terminar++){
					if (vector_utilizados[buscador] == C2.Elemento(terminar))
						condicion_salida = true ;
				}
				
				// Si encuentra la letra, avanza a_buscar
				if (vector_privado[buscador] == C2.Elemento(a_buscar) ) {
					a_buscar++ ;
				}
				
				// Si llega al final continua por el principio, si no, avanza
				if (buscador == total_utilizados - 1)
					buscador = 0 ;
				else
					buscador++ ;
					
			} while (!condicion_salida) ;
			
			// Si las ha encontrado todas, sale
			if (a_buscar == (C2.TotalUtilizados() - 1))
				contiene = true ;
		}
		// Pensé en un else pero como a_buscar se reiniciaría con el if si se vuelve a encontrar el Elemnto(0), creo que no hace falta
	}
	
	return contiene ;
} ;
