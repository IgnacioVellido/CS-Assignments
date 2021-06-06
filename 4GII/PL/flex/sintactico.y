%{
/*********************************************************
**
** Fichero: PRUEBA.Y
** Función: Pruebas de YACC para practicas de PL
**
********************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// Para quitar warnings
int yylex();

/** La siguiente declaracion permite que ’yyerror’ se pueda invocar desde el
*** fuente de lex (prueba.l)
**/
void yyerror(const char * msg ) ;

/** La siguiente variable se usará para conocer el numero de la línea
*** que se esta leyendo en cada momento. También es posible usar la variable
*** ’yylineno’ que también nos muestra la línea actual. Para ello es necesario
***  invocar a flex con la opción ’-l’ (compatibilidad con lex).
**/
int linea_actual = 1 ;

// Análisis semántico 
#include "semantico.cpp"

%}

/** Para uso de mensajes de error sintáctico con BISON.
*** La siguiente declaración provoca que ’bison’, ante un error sintáctico,
*** visualice mensajes de error con indicación de los tokens que se esperaban
*** en el lugar en el que produjo el error (SÓLO FUNCIONA CON BISON>=2.1).
***
*** Para Bison<2.1 es mediante
*** #define YYERROR_VERBOSE
***
*** En caso de usar mensajes de error mediante ’mes’ y ’mes2’ (ver apéndice D)
*** nada de lo anterior debe tenerse en cuenta.
**/

%error-verbose

/** A continuación declaramos los nombres simbólicos de los tokens.
*** byacc se encarga de asociar a cada uno un código
**/
%left OP_OR
%left OP_AND
%left OP_EXOR
%left OP_IGUALDAD
%left OP_RELACION
%right OP_ADITIVO
%left OP_MULTIPLICATIVO
%right OP_UNARIO
%left OP_BINARIO OP_TERNARIODOSBINARIO OP_TERNARIOUNO

%token IDENTIFICADOR CONSTANTE
%token AVANRETRO
%token CORIZQ CORDCH PARIZQ PARDCH LLAVEIZQ LLAVEDCH
%token SCANF PRINT
%token SWITCH BREAK CASE DEFAULT
%token TIPO
%token ASIGN
%token LISTOF
%token RETURNCOMIENZO
%token IF ELSE
%token WHILE
%token MAIN
%token VARIABLES
%token COMA PYC PUNTO2
%token CADENA
%%

/** Sección de producciones que definen la gramática. **/

programa                    : cabecera_programa bloque {printf("Fin análisis sintáctico");};
cabecera_programa           : MAIN ;

bloque                      : LLAVEIZQ { TS_InsertaMARCA(); }
                              declar_de_variables_locales
                              declar_de_subprogs
                              sentencias
                              LLAVEDCH {TS_BorrarBloque();};

declar_de_variables_locales : marca_ini_declar_variables
                              variables_locales
                              marca_fin_declar_variables 
                            | ;

marca_ini_declar_variables  : VARIABLES LLAVEIZQ ;
variables_locales           : variables_locales cuerpo_declar_variables
                            | cuerpo_declar_variables ;
cuerpo_declar_variables     : declar_variable
                            | declar_contenedor ;
declar_variable             : TIPO { tipoTmp= $1.tipo; } lista_variables pyc { tipoTmp=no_asignado; }
                            | error;
declar_contenedor           : LISTOF TIPO { tipoTmp= $2.tipo ; listofTmp = true;} lista_variables pyc { tipoTmp=no_asignado; } ;

marca_fin_declar_variables  : LLAVEDCH ;

declar_de_subprogs          : declar_de_subprogs declar_subprog 
                            | ;

declar_subprog              : cabecera_subprograma  { subProg= 1; } bloque { subProg= 0 ; };

cabecera_subprograma        : TIPO IDENTIFICADOR PARIZQ PARDCH { $2.tipo=compruebaTipoIdent($1); TS_InsertaSUBPROG($2); }
                            | TIPO IDENTIFICADOR PARIZQ { $2.tipo=compruebaTipoIdent($1); TS_InsertaSUBPROG($2); } decl_parametros PARDCH
                            | error ;

decl_parametros             : decl_parametros coma TIPO IDENTIFICADOR {  $4.tipo = compruebaTipoIdent($3); TS_InsertaPARAMF ($4) ;}
                            | TIPO IDENTIFICADOR { $2.tipo = compruebaTipoIdent($1); TS_InsertaPARAMF($2); }
                            | error ;


/** ------------------------------------------------------------ **/

sentencias                  : sentencias Sentencia
                            | Sentencia ;
       
Sentencia                   : bloque
                            | sentencia_asignacion
                            | sentencia_if
                            | sentencia_while
                            | sentencia_switch
                            | sentencia_entrada
                            | sentencia_salida
                            | sentencia_return_comienzo
                            | sentencia_avanza_retroceder;
      
sentencia_asignacion        : IDENTIFICADOR ASIGN expresion pyc { 
                                  comprobarIgualdadTipos($1,$3);
                            }
                            ;

sentencia_if                : IF PARIZQ expresion PARDCH Sentencia { 
                                  if($3.tipo != booleano)
                                    yyerror("Error semantico. La expresión del IF debe ser booleana");
                            }
                            | IF PARIZQ expresion PARDCH  Sentencia ELSE Sentencia { 
                                  if($3.tipo != booleano)
                                    yyerror("Error semantico. La expresión del IF debe ser booleana");
                            }
                            ;
       
sentencia_while             : WHILE PARIZQ expresion PARDCH  { 
                                  if($3.tipo != booleano)
                                    yyerror("Error semantico. La expresión del WHILE debe ser booleana");
                            } Sentencia
                            ;


sentencia_switch            : SWITCH PARIZQ IDENTIFICADOR PARDCH bloque_switch { 
                                  switchTipoTmp =  compruebaTipoIdent($3);
                                  
                            }
                            ; 

bloque_switch               : LLAVEIZQ cuerpo_switch LLAVEDCH
                            | LLAVEIZQ cuerpo_switch sentencia_default LLAVEDCH 
                            ;

cuerpo_switch               : cuerpo_switch CASE CONSTANTE  PUNTO2 sentencias { 
                                  if(compruebaTipoConst($3)!= switchTipoTmp)
                                    yyerror("Error semantico. No coinciden el tipo de la constante con el tipo de switch");
                            }

                            | cuerpo_switch CASE CONSTANTE PUNTO2 sentencias sentencia_break { 
                                  if(compruebaTipoConst($3) != switchTipoTmp)
                                    yyerror("Error semantico. No coinciden el tipo de la constante con el tipo de switch");
                            }
                            | CASE CONSTANTE PUNTO2 sentencias { 
                                  if(compruebaTipoConst($2) != switchTipoTmp)
                                    yyerror("Error semantico. No coinciden el tipo de la constante con el tipo de switch");
                            }
                            | CASE CONSTANTE PUNTO2 sentencias sentencia_break  { 
                                  if(compruebaTipoConst($2) != switchTipoTmp)
                                    yyerror("Error semantico. No coinciden el tipo de la constante con el tipo de switch");
                            }
                            ;
        
sentencia_break             : BREAK pyc;

sentencia_default           : DEFAULT PUNTO2 sentencias;

sentencia_entrada           : SCANF PARIZQ CADENA coma lista_variables PARDCH pyc;

sentencia_salida            : PRINT PARIZQ lista_expr_o_cadena PARDCH pyc;

sentencia_return_comienzo   : RETURNCOMIENZO expresion{
                                if($1.atrib==0)
                                    comprobarReturn($2);
                                } pyc;

sentencia_avanza_retroceder : expresion AVANRETRO{
                                comprobarTipoOpAVANRETRO($2,$1);
                              }
                              pyc;

/** ------------------------------------------------------------ **/

expresion 			        :   PARIZQ expresion PARDCH {$$.tipo = $2.tipo;}
                            | expresion OP_OR expresion 
                              {if($1.tipo == booleano && $3.tipo == booleano)
                                $$.tipo = booleano;
                              else
                                yyerror("Error semantico. Se esperaba expresión booleana.");
                              }

                            | expresion OP_AND expresion  
                              {if($1.tipo == booleano && $3.tipo == booleano)
                                $$.tipo = booleano;
                              else
                                yyerror("Error semantico. Se esperaba expresión booleana.");
                              }

                            | expresion OP_EXOR expresion 
                              {if($1.tipo == booleano && $3.tipo == booleano)
                                $$.tipo = booleano;
                              else
                                yyerror("Error semantico. Se esperaba expresión booleana.");
                              }

                            | expresion OP_IGUALDAD expresion 
                              {comprobarIgualdadTipos($1, $3);
                                $$.tipo = $1.tipo;
                              }

                            | expresion OP_RELACION expresion 
                              {comprobarTipoOpRELACION($1, $3);
                                $$.tipo = booleano;
                              }

                            | expresion OP_ADITIVO expresion 
                              {comprobarTipoOpADITIVOMULTIPLICATIVO($1, $3);
                                $$.tipo = $1.tipo;
                              }

                            | expresion OP_MULTIPLICATIVO expresion 
                              {comprobarTipoOpADITIVOMULTIPLICATIVO($1, $3);
                                $$.tipo = $1.tipo;
                              }

                            | expresion OP_BINARIO expresion 
                              {
                                /*
                                if($1.esLista)
                                {
                                  switch($2.atrib)
                                  {
                                    case 0:
                                      if($3.tipo == entero)
                                        $$.tipo == $1.tipo;
                                      else
                                        yyerror("Error semantico. El segundo elemento no es un entero."); 
                                      break;
                                    case 1:
                                      if($3.esLista)
                                      {
                                        $$.esLista = true;
                                        $$.tipo == $1.tipo;
                                      }
                                      else
                                        yyerror("Error semantico. El segundo elemento no es una lista."); 
                                      break;
                                  }
                                }
                                else
                                  yyerror("Error semantico. El primer elemento no es una lista.");
                                  */

                                  comprobarTipoOpBINARIO($2, $1, $3);
                                  $$.tipo = $1.tipo;
                              } 

                            | IDENTIFICADOR {$$.tipo = buscaTS($1.lexema);}

                            | CONSTANTE {printf("Holahola %s\n\n\n", $1.lexema); $$.tipo = compruebaTipoConst($1);}

                            | OP_UNARIO expresion                             
                              {
                              /*
                                if($2.tipo == booleano && $1.atrib = 0)
                                  $$.tipo = $2.tipo;
                                else if($2.esLista)
                                  {
                                    $$.esLista = true;
                                    $$.tipo = $2.tipo;
                                  }
                                else
                                  yyerror("Error semantico. La expresión no es de tipo correcto");
                                  */

                                  comprobarTipoOpUNARIO($1, $2);
                                  $$.tipo = $2.tipo;
                              }

                            | OP_ADITIVO expresion %prec OP_UNARIO 
                              {if ($2.tipo == entero || $2.tipo == real) 
                                $$.tipo = $2.tipo;
                              else
                                yyerror("Error semantico. Se esperaba tipo entero o float.");
                              }

                            | lista_explicita 
                              {
                                $$.tipo = $1.tipo;
                              }

                            | funcion
                              {
                                $$.tipo = $1.tipo;
                              }

                            | expresion OP_TERNARIOUNO expresion OP_TERNARIODOSBINARIO expresion
                              {/*
                                if($1.esLista &&
                                  $3.tipo == $1.tipo &&
                                  $5.tipo == entero)
                                  {
                                      $$.esLista = true;
                                      $$.tipo = $1.tipo;
                                  }
                                else
                                  yyerror("Error semantico. Los elementos son de tipo incorrecto");
                                */

                                comprobarTipoOpTERNARIO($1, $3, $5);
                                $$.tipo = $1.tipo;
                              }

                            | error
                            ;
	
lista_explicita		          : CORIZQ lista_constantes CORDCH ;
lista_constantes	          : lista_constantes coma CONSTANTE
					                  | CONSTANTE ;

funcion 			              : IDENTIFICADOR PARIZQ PARDCH
                              {$$.tipo = compruebaTipoIdent($1);}
					                  | IDENTIFICADOR PARIZQ {contadorFuncion = 0;} lista_expresiones PARDCH 
                            {
                              if(buscaPARAM($1.lexema) != contadorFuncion)
                                yyerror("Número de parámetros incorrecto.");
                              $$.tipo =compruebaTipoIdent($1);
                            }
                            ;
					
lista_expresiones	          : lista_expresiones coma expresion {contadorFuncion++;}
					                  | expresion {contadorFuncion++;};

lista_variables		          : lista_variables coma IDENTIFICADOR 
                              {$3.tipo = tipoTmp;}
					                  | IDENTIFICADOR 
                              {$1.tipo = tipoTmp;}
                            | error ;

lista_expr_o_cadena	        : lista_expr_o_cadena coma expresion
                            | lista_expr_o_cadena coma CADENA
                            | expresion
                            | CADENA ;
			
/** ------------------Para el tratamiento de errores---------------------------- **/

/* Falta ; */

pyc                         : PYC
                            | error ;

/* Falta , */

coma                        : COMA
                            | error ;

%%

/** aqui incluimos el fichero generado por el ’lex’
*** que implementa la función ’yylex’
**/

#ifdef DOSWINDOWS       /* Variable de entorno que indica la plataforma */
  #include "lexyy.c"
#else
  #include "lex.yy.c"
#endif

/** se debe implementar la función yyerror. En este caso
*** simplemente escribimos el mensaje de error en pantalla
**/

void yyerror(const char *msg ) {
  fprintf(stderr,"[Linea %d]: %s\n", linea_actual, msg) ;
}
