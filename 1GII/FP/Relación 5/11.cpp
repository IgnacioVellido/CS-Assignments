// Ignacio Vellido Expósito - F3
// 11 V


	SecuenciaDoubles MayoresOrdenados (double referencia) {
		SecuenciaDoubles resultado ;
		
		// Se debería guardar en un objeto aparte 
		SecuenciaDoubles copia ;
		
		for (int i = 0 ; i < TotalUtilizados() ; i++) 
			copia.Aniade(Elemento(i)) ;
				
		copia.Ordena_por_BurbujaMejorado() ;
		
		for (int i = 0 ; i < copia.TotalUtilizados() ; i++) {
			x = copia.Elemento(i) ;
			if (x >= referencia) 
				resultado.Aniade(x) ;
		}
		
		return resultado ;
	}
