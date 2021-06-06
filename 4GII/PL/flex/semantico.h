#include <stdbool.h>
// #include <vector>

#define MAX_TS 500

// Estructuras de datos --------------------------------------------------------
typedef enum {
  marca,            
  funcion,
  variable,
  parametro_formal,
} tipoEntrada;

typedef enum {
  entero,
  real,
  caracter,
  booleano,
  lista,
  desconocido,
  no_asignado
} dtipo;

typedef struct {
  tipoEntrada  entrada;
  char         *nombre;
  dtipo        tipoDato;
  unsigned int parametros;
  // bool         esLista;
} entradaTS;

unsigned int TOPE=0 ;   /* Tope de la pila */
unsigned int subProg ;  /* Indicador de comienzo de bloque de un subprog */
unsigned int contadorFuncion = 0;

dtipo tipoTmp; /* Variable global temporal que almacena el tipo de una lista de variables */
bool listofTmp; /* Variable global temporal que será true en caso de que haya dos tipos y uno de ellos sea LISTOF*/
dtipo switchTipoTmp;

entradaTS TS[MAX_TS] ; /* Pila de la tabla de símbolos */

typedef struct {
  int atrib ;     /* Atributo del símbolo (si tiene) */
  char *lexema ;  /* Nombre del lexema */
  dtipo tipo ;    /* Tipo del símbolo */
} atributos ; 

#define YYSTYPE atributos   /* A partir de ahora, cada símbolo tiene */
                            /* una estructura de tipo atributos /

// Funciones -------------------------------------------------------------------

/* Las que son comprobaciones pero no devuelven bool notifican del error */

void incrementarTOPE(); // Incrementa TOPE y avisa de error si se 
                        // alcanza el máximo
void incrementarParamfSubprog(); // Incrementa en 1 el nº de parámetros
                                 // de la última función

void comprobarReturn(atributos atrib); // Comprueba tipos
dtipo compruebaTipoIdent(atributos atrib); // Devuelve el tipo del identificador
dtipo compruebaTipoConst(atributos atrib); // Devuelve el tipo de la constante

// Comprueba que los tipos de los dos atributos sean igual
void comprobarIgualdadTipos(atributos atrib1, atributos atrib2);

/** Comprobaciones de operadores
 * Se le pasan los atributos implicados en la operación, y en
 * algunos casos también se incluye el operador
 */
void comprobarTipoOpUNARIO(atributos op, atributos atrib);
void comprobarTipoOpAVANRETRO(atributos op, atributos atrib);
void comprobarTipoOpRELACION(atributos atrib1, atributos atrib2);
void comprobarTipoOpBOOLEANO(atributos atrib1, atributos atrib2);
void comprobarTipoOpADITIVOMULTIPLICATIVO(atributos atrib1, atributos atrib2);
void comprobarTipoOpBINARIO(atributos op, atributos atrib1, atributos atrib2);
void comprobarTipoOpTERNARIO(atributos atrib1, atributos atrib2, atributos atrib3);

dtipo buscaTipoFuncion(); // Devuelve el tipo de la última función en la TS
dtipo buscaTS(char *ident); // Busca identificador en la TS
bool buscaIDENT(char *ident);   // true si existe el identificador en la TS
bool buscaIDENTbloque(char *ident); // true si existe el ident en el bloque actual
unsigned int buscaPARAM(char *ident); // Devuelve el número de parámetros de una función
entradaTS getIDENT(char *ident);

void TS_InsertaMARCA(); // Añade marca a la TS
void TS_InsertaPARAMF(atributos atrib);  // Inserta paramf y incrementa parametros en subprog
void TS_InsertaIDENT(atributos atrib); // Inserta y comprueba identificador
void TS_InsertaSUBPROG(atributos atrib); // Introduce subprog con su tipo

void TS_BorrarBloque(); // Borra hasta encontrar la última marca


// Por hacer -----------------------------
// void comprobarPARAMFfuncion(vector<atributos> v_atrib); // Comprueba nº y tipos