# BNF de gramática abstracta

```
                      <Programa> ::= <Cabecera_programa> <bloque>
             <Cabecera_programa> ::= #MAIN#

                        <bloque> ::= #LLAVEIZQ#
                                      <Declar_de_variables_locales>
                                      <Declar_de_subprogs>
                                      <Sentencias>
                                     #LLAVEDCH#
				      
            <Declar_de_subprogs> ::= <Declar_de_subprogs> <Declar_subprog>
                                      |				      
                <Declar_subprog> ::= <Cabecera_subprograma> <bloque>
          <Cabecera_subprograma> ::= #TIPO# #IDENTIFICADOR# #PARIZQ# <decl_parametros> #PARDCH#
	  				| #TIPO# #IDENTIFICADOR# #PARIZQ# #PARDCH#
               <decl_parametros> ::= <decl_parametros> #COMA# #TIPO#  #IDENTIFICADOR# |
                                     #TIPO# #IDENTIFICADOR#
				     
   <Declar_de_variables_locales> ::= #VARIABLES# #LLAVEIZQ#
				     <Variables_locales>
				      #LLAVEDCH#
                       		     |				     
	     <Variables_locales> ::= <Variables_locales> <Cuerpo_declar_variables>
                                     | <Cuerpo_declar_variables>
       <Cuerpo_declar_variables> ::= <declar_variable> | <declar_contenedor>
	       <declar_variable> ::= #TIPO# <lista_variables> #PYC#
	     <declar_contenedor> ::= #LISTOF# #TIPO# <lista_variables> #PYC#
	     
		-------------------------------------------------------------------------
		
                    <Sentencias> ::= <Sentencias> <Sentencia>
                                     | <Sentencia>
                     <Sentencia> ::= <bloque>
                                     | <sentencia_asignacion>
                                     | <sentencia_if>
                                     | <sentencia_while>
                                     | <sentencia switch>
                                     | <sentencia_entrada>
                                     | <sentencia_salida>
                                     | <sentencia_return>
				     | <sentencia_avanza>
				     | <sentencia_retroceder>
				     | <sentencia_comienzo>
				     
           <sentencia_asignacion> ::= #IDENTIFICADOR# = <expresion> #PYC#		     
         	   <sentencia_if> ::= <sentencia_if> ::= #IF# #PARIZQ# <expresion> #PARDCH# <Sentencia> 
				     | #IF# #PARIZQ# <expresion> #PARDCH# <Sentencia> #ELSE# <Sentencia>
        	<sentencia_while> ::= #WHILE# #PARIZQ# <expresion> #PARDCH# <Sentencia>		   

                <sentencia_switch> ::= #SWITCH# #PARIZQ# #IDENTIFICADOR# #PARDCH# <bloque_switch>
                  <bloque_switch> ::= #LLAVEIZQ# <cuerpo_switch> #LLAVEDCH#
		  			| #LLAVEIZQ# <cuerpo_switch> <sentencia_default> #LLAVEDCH#
                  <cuerpo_switch> ::= <cuerpo_switch> #CASE# #CONSTANTE# #PUNTO2# <sentencias> <sentencia_break>
		  			<cuerpo_switch> #CASE# #CONSTANTE# #PUNTO2# <sentencias>
                		      | #CASE# #CONSTANTE# #PUNTO2# <sentencias> <sentencia_break>
				      | #CASE# #CONSTANTE# #PUNTO2# <sentencias>
	      <sentencia_default> ::= #DEFAULT# #PUNTO2# <sentencias>	            				      

              <sentencia_entrada> ::= #SCANF# #PARIZQ# #CADENA# #COMA# <lista_variables> #PARDCH# #PYC#
               <sentencia_salida> ::= #PRINT# #PARIZQ# <lista_expr_o_cadena> #PARDCH# #PYC#
               <sentencia_return> ::= #RETURNCOMIENZO# <expresion> #PYC#

                <sentencia_break> ::= #RETURNCOMIENZO# #PYC#				      

               <sentencia_avanza> ::= <expresion> #AVANRETRO# #PYC#
	   <sentencia_retroceder> ::= <expresion> #AVANRETRO# #PYC#
             <sentencia_comienzo> ::= #RETURNCOMIENZO# <expresion> #PYC#
	     
	     -------------------------------------------------------------------------
	     
	              <expresion> ::= #PARIZQ# <expresion> #PARDCH#
                                      | #OP_UNARIO# <expresion>
                                      | <expresion> #OP_BINARIO# <expresion>
                                      | #IDENTIFICADOR#
                                      | #CONSTANTE#
				      | <lista_explicita>
                                      | <funcion>
				      | <expresion> #OP_TERNARIO1# <expresion> #OP_TERNARIO2BINARIO# <expresion>

		<lista_explicita> ::= #CORIZQ# <lista_constantes> #CORDCH#
	       <lista_constantes> ::= <lista_constantes> #COMA# #CONSTANTE#
	       			      | #CONSTANTE#
				      
                        <funcion> ::= #IDENTIFICADOR# #PARIZQ# <lista_expresiones> #PARDCH#
					| #IDENTIFICADOR# #PARIZQ# #PARDCH#
	      <lista_expresiones> ::= <lista_expresiones> #COMA# <expresion> 
				    | <expresion>
                <lista_variables> ::= <lista_variables> #COMA# #IDENTIFICADOR#
                	              | #IDENTIFICADOR#				     
			                                         
		      
            <lista_expr_o_cadena> ::= <lista_expr_o_cadena> #COMA# <expresion>
				      | <lista_expr_o_cadena> #COMA# #CADENA#
				      | <expresion>
                		      | #CADENA#		
```
