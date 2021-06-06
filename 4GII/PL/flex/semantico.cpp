/* Lista de funciones y procedimientos para manejo de la TS ----------------- */
#include "semantico.h"

/* -------------------------------------------------------------------------- */

void incrementarTOPE() {
    TOPE++;
    if (TOPE >= MAX_TS) {
        // printf("\n[Error semantico] alcanzado tope en la tabla de símbolos\n");
        yyerror("\n[Error semantico] alcanzado tope en la tabla de símbolos\n");
        exit(1);
    }
}

/* -------------------------------------------------------------------------- */

void TS_InsertaMARCA() {
    TS[TOPE].entrada = marca;
    incrementarTOPE();
}

/* -------------------------------------------------------------------------- */

void incrementarParamfSubprog() {
  int j=TOPE-1;

  // Buscar la función en la pila
  while(j>=0 && (TS[j].entrada != funcion)) {
    j--;
  }

  // Si encontrada, aumentar su PARAMF
  if (j>=0) {
    TS[j].parametros++;
  }
  else {
    yyerror("[Error semantico] función asociada al parámetro no encontrada");
  }
}

/* -------------------------------------------------------------------------- */

void TS_InsertaSUBPROG(atributos atrib) {
    TS[TOPE].entrada = funcion;
    TS[TOPE].nombre = atrib.lexema;
    TS[TOPE].tipoDato = atrib.tipo;
    TS[TOPE].parametros = 0;
    incrementarTOPE();
}

/* -------------------------------------------------------------------------- */

dtipo compruebaTipoIdent(atributos atrib) {
  switch(atrib.atrib) {
    case 0: return entero; break;
    case 1: return caracter; break;
    case 2: return booleano; break;
    case 3: return real; break;
    case 4: return lista; break;
  }

  printf("\n[Error: Tipo no reconocido(%d)\n", atrib.atrib);
  return desconocido;
}

/* -------------------------------------------------------------------------- */

dtipo compruebaTipoConst(atributos atrib) {
  // printf("%s\n\n\n", atrib.lexema);
  switch(atrib.atrib) {
    case 0: return booleano; break;
    case 1: return booleano; break;
    case 2: return caracter; break;
    case 3:     
      if (strstr(".", atrib.lexema) != NULL) {
        return real;
      }  
      else 
        return entero;
    break;  
  }
}

/* -------------------------------------------------------------------------- */

void TS_InsertaPARAMF(atributos atrib) {
    TS[TOPE].entrada = parametro_formal;
    TS[TOPE].tipoDato = atrib.tipo; // Se le debe asignar esto antes
    TS[TOPE].nombre = strdup(atrib.lexema);
    incrementarTOPE();
    incrementarParamfSubprog();
}

/* -------------------------------------------------------------------------- */

// Busca un identificador en la TS y devuelve el tipo.
// Si no lo encuentra, devuelve "deconocido"
dtipo buscaTS(char *ident) {
  // printf("HOLA\n\n\n");
  int j=TOPE-1, e=0;
  dtipo tip;

  while(j>=0 && (TOPE != 0)) {      
    if (!TS[j].tipoDato == marca) {
      if (!strcmp(TS[j].nombre, ident)) {
        tip = TS[j].tipoDato;
        e=1;
        return tip;
      }
    }
    j--;
  }

  // printf("HOLA2\n\n\n");

  if (e==0) {
    printf("\n[Error: Identificador no declarado %s]\n", ident);
    tip = desconocido;  
  }

  return tip;
}

/* -------------------------------------------------------------------------- */

// Busca un identificador en la TS.
// Devuelve true si existe uno con ese nombre
bool buscaIDENT(char *ident) {
  int j=0;

  while(j<=(TOPE-1)) {
    if (!strcmp(TS[j].nombre, ident)) {
      return true;
    }
    else {
      j++;
    }
  }

  return false;
}

// Devuelve el número de parámetros de una función
unsigned int buscaPARAM(char *ident) {
  int j=TOPE-1;

  while(j>=0) {
    if (!strcmp(TS[j].nombre, ident)) {
      return TS[j].parametros;
    }
    else {
      j--;
    }
  }

  printf("\n[Error: Función no encontrada %s]\n", ident);

  return -1;
}

entradaTS getIDENT(char *ident) {
  int j=TOPE-1;

  while(j>=0) {
    if (!strcmp(TS[j].nombre, ident)) {
      return TS[j];
    }
    else {
      j--;
    }
  }

  printf("\n[Error: Identificador no encontrado %s]\n", ident);
  exit(1);
}

/* -------------------------------------------------------------------------- */

void TS_InsertaIDENT(atributos atrib) {
  if (buscaIDENT(atrib.lexema)) {
    printf("\n[Error: Identificador '%s' duplicado.\n", atrib.lexema);
  }
  else {
    // Comprobar si el tipo está asignado
    if (atrib.tipo == no_asignado) {
      printf("\n[Error semantico] asignando variable sin tipo\n");
    }

    TS[TOPE].tipoDato = atrib.tipo;
    TS[TOPE].nombre = strdup(atrib.lexema);
    TS[TOPE].entrada = variable;
    incrementarTOPE();    
  }
}

/* -------------------------------------------------------------------------- */

void TS_BorrarBloque() {
  int j=TOPE;

  do {
    TOPE--;
    j--;
  } while(j>=0 && (TS[j].entrada != marca));
}

/* -------------------------------------------------------------------------- */

/**
 * True si existe el identificador en el bloque actual
 */
bool buscaIDENTbloque(char *ident) {
  int j=TOPE-1;

  while(j>=0 && TS[j].entrada != marca) {
    if (!strcmp(TS[j].nombre, ident)) {
      return true;
    }
    else {
      j--;
    }
  }

  return false;  
}

/* -------------------------------------------------------------------------- */

/**
 * Devuelve el tipo de la última función en la TS
 */
dtipo buscaTipoFuncion() {
  int j=TOPE-1;

  while(j>=0 && TS[j].entrada != funcion) {
    j--;
  }

  if (TS[j].entrada == funcion) {
    return TS[j].tipoDato;
  }
  else {
    printf("[Error semantico] función no encontrada\n");
    exit(1);
  }
}

/* -------------------------------------------------------------------------- */

/**
 * True si existe el identificador en el bloque actual
 */
void comprobarReturn(atributos atrib) {
  dtipo tipoFuncion = buscaTipoFuncion();

  if (atrib.tipo != tipoFuncion) {
    yyerror("[Error semantico] El tipo no coincide con el de la función\n");
  }
}

/* -------------------------------------------------------------------------- */

// void comprobarPARMFfuncion() {

// }

/* -------------------------------------------------------------------------- */

void comprobarIgualdadTipos(atributos atrib1, atributos atrib2) {
  if (atrib1.tipo != atrib2.tipo) {
    printf("%d %s\n\n\n", atrib1.tipo, atrib1.lexema);
    printf("%d %s\n\n\n", atrib2.tipo, atrib2.lexema);
    yyerror("[Error semantico] Tipos no válidos\n");
  }
}

/* -------------------------------------------------------------------------- */

void comprobarTipoOpAVANRETRO(atributos op, atributos atrib) {
  switch (atrib.tipo) {
    case entero:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case real:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case caracter:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case booleano:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case lista:
      break;
    
    default:
      yyerror("[Error semantico] identificador sin tipo\n");
  }
}

void comprobarTipoOpUNARIO(atributos op, atributos atrib) {
  switch (op.atrib) {
    case 0: // !
      switch (atrib.tipo) {
        case entero:
          yyerror("[ERROR semantico] Tipo no válido con el operador\n");
          break;
        
        case real:
          yyerror("[ERROR semantico] Tipo no válido con el operador\n");
          break;
        
        case caracter:
          yyerror("[ERROR semantico] Tipo no válido con el operador\n");
          break;
        
        case booleano:
          break;
        
        case lista:
          yyerror("[ERROR semantico] Tipo no válido con el operador\n");
          break;
        
        default:
          yyerror("[Error semantico] identificador sin tipo\n");
      }

      break;

    case 1: // #
      switch (atrib.tipo) {
        case entero:
          yyerror("[ERROR semantico] Tipo no válido con el operador\n");
          break;
        
        case real:
          yyerror("[ERROR semantico] Tipo no válido con el operador\n");
          break;
        
        case caracter:
          yyerror("[ERROR semantico] Tipo no válido con el operador\n");
          break;
        
        case booleano:
          yyerror("[ERROR semantico] Tipo no válido con el operador\n");
          break;
        
        case lista:
          break;
        
        default:
          yyerror("[Error semantico] identificador sin tipo\n");
      }

      break;

    case 2: // ?
      switch (atrib.tipo) {
        case entero:
          yyerror("[ERROR semantico] Tipo no válido con el operador\n");
          break;
        
        case real:
          yyerror("[ERROR semantico] Tipo no válido con el operador\n");
          break;
        
        case caracter:
          yyerror("[ERROR semantico] Tipo no válido con el operador\n");
          break;
        
        case booleano:
          yyerror("[ERROR semantico] Tipo no válido con el operador\n");
          break;
        
        case lista:
          break;
        
        default:
          yyerror("[Error semantico] identificador sin tipo\n");
      }

      break;

    default:
      yyerror("[Error semantico] operador unario sin atributo\n");
  }
}

/* -------------------------------------------------------------------------- */

void comprobarTipoOpTERNARIO(atributos atrib1, atributos atrib2, atributos atrib3) {
  if (atrib1.tipo != lista) {
    yyerror("[ERROR semantico] Tipo del primer operando no válido con el operador\n");
  }
  if (atrib2.tipo != entero) {
    yyerror("[ERROR semantico] Tipo del segundo operando no válido con el operador\n");
  }
  if (atrib3.tipo != entero) {
    yyerror("[ERROR semantico] Tipo del tercer operando no válido con el operador\n");
  }
}

/* -------------------------------------------------------------------------- */

void comprobarTipoOpADITIVOMULTIPLICATIVO(atributos atrib1, atributos atrib2) {
  switch (atrib1.tipo) {
    case entero:
      break;
    
    case real:      
      break;
    
    case caracter:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case booleano:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case lista:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    default:
      yyerror("[Error semantico] identificador sin tipo\n");
  }

  switch (atrib2.tipo) {
    case entero:
      break;
    
    case real:      
      break;
    
    case caracter:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case booleano:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case lista:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    default:
      yyerror("[Error semantico] identificador sin tipo\n");
  }
}

void comprobarTipoOpRELACION(atributos atrib1, atributos atrib2) {
  switch (atrib1.tipo) {
    case entero:
      /* code */
      break;
    
    case real:
      /* code */
      break;
    
    case caracter:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case booleano:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case lista:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    default:
      yyerror("[Error semantico] identificador sin tipo\n");
  }

  switch (atrib2.tipo) {
    case entero:
      break;
    
    case real:
      break;
    
    case caracter:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case booleano:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case lista:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    default:
      yyerror("[Error semantico] identificador sin tipo\n");
  }
}

// PARA TODOS LOS BOOLEANOS (and, or, exor)
void comprobarTipoOpBOOLEANO(atributos atrib1, atributos atrib2) {
  switch (atrib1.tipo) {
    case entero:
      break;
    
    case real:
      break;
    
    case caracter:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case booleano:
      break;
    
    case lista:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    default:
      yyerror("[Error semantico] identificador sin tipo\n");
  }

  switch (atrib2.tipo) {
    case entero:
      break;
    
    case real:
      break;
    
    case caracter:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    case booleano:
      break;
    
    case lista:
      yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      break;
    
    default:
      yyerror("[Error semantico] identificador sin tipo\n");
  }
}

void comprobarTipoOpBINARIO(atributos op, atributos atrib1, atributos atrib2) {
  switch (op.atrib) {
    case 0: // --
      if (atrib1.tipo != lista) {
        yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      } 
      if (atrib2.tipo != entero) {        
        yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      }

      break;

    case 1: // **
      if (atrib1.tipo != lista) {
        yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      } 
      if (atrib2.tipo != lista) {        
        yyerror("[ERROR semantico] Tipo no válido con el operador\n");
      }
      
      break;

    default:
      yyerror("[Error semantico] operador unario sin atributo\n");
  }
}