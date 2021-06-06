	/* Archivo flex - Ignacio Vellido Expósito */
	/*-----------Declaraciones-----------------*/
%option noyywrap

	int num_tab = 0, num_linea = 0;
	int println = 0, error_parentesis = 0;
	char *tab="\t";

	// Siempre queremos imprimir el salto de línea, ya que ignoramos el carácter en las reglas
	void imprime_lines () {
	  if (error_parentesis) {
	    printf("\t// ERROR: Falta paréntesis \")\"");
	    error_parentesis = 0;
	  }

	  printf("\n");
	  if (println)
	    printf("%d\t", num_linea);
	}

	void imprime_tabs () {
	  int i=0;

	  for (i; i<num_tab; i++)
	    printf("%s", tab);
	}
%%
	/*-----------------Reglas------------------*/

	/*-------Carácteres ignorados-----------------------------*/
\n				// Ignora los saltos de línea


	/*------------Llaves y paréntesis-------------------------*/
")"/"{"			printf(") "); 			/* Añadir espacio si ) está junto a 
								   {, con / decimos que la siguiente
								   parte pertenezca al siguiente token 
								   leído */

[^ ]/"(" 			printf("%c ", yytext[0]); 	/* Separamos el paréntesis del carácter */

[^f][^o][^r]"("/[^)]*[;{]	ECHO; error_parentesis = 1;	// Se debe tener cuidado con los bucles for

"{"				{ num_tab++; num_linea++; ECHO;
				  imprime_lines();
				  imprime_tabs();
				}


";}"				{ printf(";"); 			

				  num_tab--; num_linea++;
				  imprime_lines();
				  imprime_tabs();

				  printf("} ");
				}

"}"				{ num_tab--; num_linea++;	/* Para cuando hay } encadenados */
				  imprime_lines();	
				  imprime_tabs();

				  ECHO; printf(" ");
				}

"}"/[^ ][^e][^l][^s][^e]	{ num_tab--; num_linea++;	/* Para cuando hay } no seguido 
								   por un else */
				  imprime_lines();		
				  imprime_tabs();

				  ECHO;

				  imprime_lines();		/* Dejamos una línea adicional */
				  imprime_tabs();
				}

	/*--------------------Switch-------------------------------*/
:				{ ECHO; num_linea++;
				  imprime_lines();
				  imprime_tabs();
				} 

case[^ ]			{ printf("case ");  		/* Añadimos espacio tras "case" */
				  num_tab++;
				}

case				ECHO; num_tab++;

break				ECHO; num_tab--;

	/*---------------------If/else-----------------------------*/
"if("			 	printf("if (");
"else(" 			printf("else (");
"else"/"{"		 	printf("else ");

	/*--------------Operadores AND y OR------------------------*/
	/* Se separan los operadores de las variables.              
	   Se imprime el carácter anterior junto a un espacio para
	   la parte izquierda, y al contrario con la derecha	   */
[^ ]/"||" 			printf("%s ", yytext);
"||"/[^ ] 			printf("|| ");

[^ ]/"&&" 			printf("%s ", yytext);
"&&"/[^ ]		 	printf("&& ");

	/*--------------Operadores de comparación------------------*/
	/* Se separan los operadores de las variables              */
[^ ]/"==" 			printf("%s ", yytext);
"=="/[^ ]		 	printf("== ");

[^ ]/"!=" 			printf("%s ", yytext);
"!="/[^ ] 			printf("!= ");

[^ ]/"<=" 			printf("%s ", yytext);
"<="/[^ ] 			printf("<= ");

[^ ]/">=" 			printf("%s ", yytext);
">="/[^ ] 			printf(">= ");

[^ ]/"<" 			printf("%s ", yytext);
"<"/[^ ]		 	printf("< ");

[^ ]/">" 			printf("%s ", yytext);
">"/[^ ] 			printf("> ");

	/*---------------Saltos de línea---------------------------*/
"for"[^;]*;[^;]*;[^)]*/")"	ECHO;				/* El for se copia tal cual */

;				{ num_linea++; ECHO;
				  imprime_lines();
				  imprime_tabs();
				}

	/*--------------------------------------------------------*/
.				ECHO;				/* El resto de caracteres solo se imprimen */

<<EOF>>			{ printf("\n"); 		// Carácter de fin de archivo, añadimos 
								// salto de línea para la lectura en terminal

				  // Comprobar falta de llaves {} = num_tab al final es distinto de 0
				  if (num_tab != 0)
				    printf("Error: Se ha llegado al final del fichero a falta de }\n");

				  return 0;
				}
%%
	/*-----------Procedimientos----------------*/

	// Argumentos: ./beautifier <archivo.cpp> <y/n> [tabulación]
int main (int argc, char **argv) {
  if (argc == 3 || argc == 4) {
    yyin = fopen(argv[1], "rt"); // Se abre fichero para lectura en modo texto
    if (!yyin) { // Error
      printf("No se pudo abrir el fichero %s\n", argv[1]);
      return 0;
    }

    // Si queremos espacios se crea un array con el número indicado y se le asigna a tab
    if (argc == 4) {
      int tam = atoi(argv[3]);
      char *aux = malloc(tam*sizeof(aux));;

      int i=0;
      for (i; i<tam; i++)
	aux[i] = ' ';

      tab = aux;
    }
  }
  else {
    printf("Uso: ./beautifier <archivo.cpp> <y/n> <tabulacion>\n");
    exit(1);
  }

  if (argv[2][0] == 'y') {	// Comprobando si se quieren líneas
    println = 1;
    num_linea++;
    printf("%d\t", num_linea);
  }

  //------
  yylex();
  //------

  // Liberamos la memoria reservada si queríamos espacios
  if (argc == 4) {
    free(tab);
  }

  return 0;
}
