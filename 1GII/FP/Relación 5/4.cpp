// Ignacio Vellido Expósito - F3
// 19 V
// Falla cuando no hay elementos

# include <iostream>
using namespace std ;

	SecuenciaCaracteres Descodifica () {
		SecuenciaCaracteres mensaje ;
		
		if (Elemento(0) != ' ')
			mensaje.Aniade(Elemento(i)) ;
			
		for (int i = 1 ; i < TotalUtilizados() - 1 ; i++) {
			if (Elemento(i) != ' ' && Elemento(i+1) == ' ' || Elemento(i-1) == ' ')
				mensaje.Aniade(Elemento(i)) ;
		}
		return  mensaje ;
	}
