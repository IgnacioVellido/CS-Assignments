// Francisco José Cotán López
// Ignacio Vellido Expósito

#include "../include/quienesquien.h"
#include <sstream>
#include <iostream>
#include <iterator>
#include <math.h>
#include <algorithm>

// -----------------------------------------------

QuienEsQuien::QuienEsQuien(){
  //TODO :)
}

// -----------------------------------------------

QuienEsQuien::QuienEsQuien(const QuienEsQuien &quienEsQuien){
  //TODO :)
}

// -----------------------------------------------

QuienEsQuien& QuienEsQuien::operator= (const QuienEsQuien &quienEsQuien){
  //TODO :)
  return *this;
}

// -----------------------------------------------

QuienEsQuien::~QuienEsQuien(){
  this->limpiar();
}

// -----------------------------------------------

void QuienEsQuien::limpiar(){
  //TODO :)
}

// -----------------------------------------------

template <typename T>
std::ostream& operator<< (std::ostream& out, const std::vector<T>& v) {
  if ( !v.empty() ) {
    out << '[';
    std::copy (v.begin(), v.end(), std::ostream_iterator<T>(out, ", "));
    out << "\b\b]";
  }
  return out;
}

// -----------------------------------------------

void QuienEsQuien::mostrar_estructuras_leidas(){
  cout << "personajes: "<< (this->personajes) << endl;
  cout << "atributos:  "<< (this->atributos)  << endl;
  cout << "tablero:    "<< endl;

  // Escribe la cabecera del tablero
  for(vector<string>::iterator it_atributos = this->atributos.begin();
      it_atributos != this->atributos.end();
      it_atributos++){

    cout << *it_atributos << "\t";
  }

  cout <<endl;

  int indice_personaje = 0;
  for(vector<vector<bool>>::iterator it_tablero_atributos = tablero.begin();
      it_tablero_atributos!= tablero.end();
      it_tablero_atributos++){

    string personaje = this->personajes[indice_personaje];
    int indice_atributo = 0;
    for(vector<bool>::iterator it_atributos_personaje = (*it_tablero_atributos).begin();
	it_atributos_personaje != (*it_tablero_atributos).end();
	it_atributos_personaje++){

      cout << *it_atributos_personaje<<"\t";

      indice_atributo++;
    }

    cout << personaje << endl;

    indice_personaje++;
  }
}

// -----------------------------------------------

/**
  * @brief Devuelve una copia de la cadena original sin las subcadenas no deseadas.
  * 
  * @param cadena_original Cadena de la que se eliminan las subcadenas no deseadas.
  * @param cadena_a_eliminar Subcadena que se busca y se elimina.
  *
  * @return Copia de la cadena original sin las subcadenas no deseadas.
  */
string limpiar_string(string cadena_original,string cadena_a_eliminar){
  string linea(cadena_original);

  while(linea.find_first_of(cadena_a_eliminar) != std::string::npos){
    linea.erase(linea.find_first_of(cadena_a_eliminar),cadena_a_eliminar.length());
  }

  return linea;
}

// -----------------------------------------------

istream& operator >> (istream& is, QuienEsQuien &quienEsQuien) {
  quienEsQuien.limpiar();
	
  if(is.good()){
    string linea;
    getline(is, linea, '\n');

    linea = limpiar_string(linea,"\r");
    	
    while(linea.find('\t') != string::npos ){
      string atributo = linea.substr(0,linea.find('\t'));
      quienEsQuien.atributos.push_back(atributo);
      linea = linea.erase(0,linea.find('\t')+1);
    }

    assert(linea ==  "Nombre personaje");
  }
	
  while( is.good() ) {
    string linea;
    getline(is, linea, '\n');
    linea = limpiar_string(linea,"\r");

    //Si la linea contiene algo extrae el personaje. Si no lo es, la ignora.
    if(linea != ""){;
      vector<bool> atributos_personaje;
	    	
      int indice_atributo=0;
      while(linea.find('\t') != string::npos){
	string valor = linea.substr(0,linea.find('\t'));
	    		
	assert(valor == "0" || valor == "1");
	    		
	bool valor_atributo = valor == "1";
	    		
	atributos_personaje.push_back(valor_atributo);
				
	linea = linea.erase(0,linea.find('\t')+1);
	indice_atributo++;
      }
			
      string nombre_personaje = linea;
	    	
      quienEsQuien.personajes.push_back(nombre_personaje);
      quienEsQuien.tablero.push_back(atributos_personaje);
    }
  }
  	
  return is;
}

// -----------------------------------------------

ostream& operator << (ostream& os, const QuienEsQuien &quienEsQuien){
  //Escribimos la cabecera, que contiene los atributos y al final una columna para el nombre
  for(vector<string>::const_iterator it_atributos = quienEsQuien.atributos.begin();
      it_atributos != quienEsQuien.atributos.end();
      it_atributos++){

    os  << *it_atributos << "\t";
  }
  os << "Nombre personaje" << endl;

  //Rellenamos con ceros y unos cada línea y al final ponemos el nombre del personaje.
  for(int indice_personaje=0;indice_personaje<quienEsQuien.personajes.size();indice_personaje++){
    for(int indice_atributo=0;indice_atributo<quienEsQuien.personajes.size();indice_atributo++){

      os  << quienEsQuien.tablero[indice_personaje][indice_atributo] << "\t";
    }
    os  << quienEsQuien.personajes[indice_personaje] << endl;
  }

  return os;
}

// -----------------------------------------------

/**
  * @brief Convierte un número a un vector de bool que corresponde 
  *        con su representación en binario con un numero de digitos
  *        fijo.
  *
  * @param n Número a convertir en binario.
  * @param digitos Número de dígitos de la representación binaria.
  *
  * @return Vector de booleanos con la representación en binario de @e n 
  *      con el número de elementos especificado por @e digitos. 

  */
vector<bool> convertir_a_vector_bool(int n, int digitos) {
  vector<bool> ret;
  while(n) {
    if (n&1){
      ret.push_back(true);
    } else{
      ret.push_back(false);
    }
    n>>=1;  
  }

  while(ret.size()<digitos){
  	ret.push_back(false);
  }

  reverse(ret.begin(),ret.end());
  return ret;
}

// -----------------------------------------------

bintree<Pregunta> QuienEsQuien::crear_arbol() {
  Pregunta raiz (atributos[0], 0);				// Comienza en 0, puesto que el primer personaje aumenta el contador
  bintree<Pregunta> arbol(raiz);

  bintree<Pregunta>::node nodo_actual;
  bintree<Pregunta>::node padre;

  vector<vector<bool>>::const_iterator t_it;
  vector<bool>::const_iterator it;
  int pos,
      pos_p = 0;

  // Para cada fila del tablero, añadimos un personaje
  for (t_it = tablero.begin(), pos_p; t_it != tablero.end(); ++t_it, pos_p++) {
    // Para cada columna de la fila, comprobamos si el atributo está en ese
    // posición, y en caso contrario se inserta
    // Mientras se recorre se aumentan los contadores de num_personajes
    nodo_actual = arbol.root();	
    pos = 0;

    // Damos por hecho que el nº de columnas de tablero y el de atributos es el mismo
    for (it = t_it->begin(); it != t_it->end(); ++it, pos++) {

      if (nodo_actual.null()) {
        Pregunta nueva_pregunta(atributos[pos], 1);
	
	// Insertar a dch o izq según corresponda
        if (*(it-1) == true) {
          arbol.insert_left(padre, nueva_pregunta);	   
          padre = padre.left();
        }
        else {
          arbol.insert_right(padre, nueva_pregunta);       	
          padre = padre.right();
        }

        // Situamos el puntero actual donde corresponda
        if (*it == true)
	  nodo_actual = padre.left();				
        else
	  nodo_actual = padre.right();        
      }
      else {
        (*nodo_actual).aumentar_num_personajes(); 		// como estamos añadiendo un personaje más, aumentamos el contador

	padre = nodo_actual;
        if (*it == true)
  	  nodo_actual = nodo_actual.left();
        else
	  nodo_actual = nodo_actual.right();	
      }
    }
    // Añadir personaje y repetir para la siguiente fila
    Pregunta nuevo_personaje(personajes[pos_p], 1);

    // Se inserta izq o dch según el último parámetro de los atributos
    if (*(it-1) == true)
      arbol.insert_left(padre, nuevo_personaje);
    else
      arbol.insert_right(padre, nuevo_personaje);
  }
 	
  return arbol;
}

// ----------------------------------------------------------------

void QuienEsQuien::usar_arbol(bintree<Pregunta> arbol_nuevo){
	arbol = arbol_nuevo;
}

// ----------------------------------------------------------------

bool QuienEsQuien::esHoja(bintree<Pregunta> arb, bintree<Pregunta>::node nodo) const{
  if (nodo.null()) 
    return false;
  else if (!nodo.right().null() || !nodo.left().null())
      return false;  

  return true;
}

// ----------------------------------------------------------------

// @pre Al menos hay dos personajes
void QuienEsQuien::iniciar_juego(){
  bool fin = false;
  int num_pregunta = 1, 
      respuesta;
  bintree<Pregunta> copia(arbol),
		    auxiliar;

  jugada_actual = copia.root();

  cout << "------| 1 = SI ||| 0 = NO |------" << endl;
  while (!fin) {
    // Formular pregunta
    cout << "Pregunta num." << num_pregunta << ":\n" << (*jugada_actual).obtener_pregunta() << endl;
    cin >> respuesta;

    if (respuesta == 1) {
      copia.prune_left(jugada_actual, auxiliar);
      copia = auxiliar;
    } 
    else if (respuesta == 0) {
      copia.prune_right(jugada_actual, auxiliar);  
      copia = auxiliar;
    }
    else {
      cout << "Respuesta incorrecta\n" << "------| 1 = SI ||| 0 = NO |------" << endl;
      continue;
    }

    // Comprobamos si es hoja, también se podría haber utilizado la función esHoja
    jugada_actual = copia.root();

    // El nodo es una hoja si su num_personajes vale 1
    fin = (*jugada_actual).obtener_num_personajes() == 1 ? true : false; 

    preguntas_formuladas(jugada_actual);
  }
 
  cout << "--------"
       << "Lo se, tu personaje es " << (*jugada_actual).obtener_personaje() 
       << "--------" << endl;
}

// ----------------------------------------------------------------

set<string> QuienEsQuien::informacion_jugada(bintree<Pregunta>::node jugada_actual){
	
  //TODO :)
  set<string> personajes_levantados;
  return personajes_levantados;
}

// ----------------------------------------------------------------

void escribir_esquema_arbol(ostream& ss,
			    const bintree<Pregunta>& a, 
		    	    bintree<Pregunta>::node n,
			    string& pre) {
  if (n.null()){
    ss << pre << "-- x" << endl;

  } else {
    ss << pre << "-- " << (*n) << endl;
    if ( !n.right().null() || !n.left().null()) {// Si no es una hoja
      pre += "   |";
      escribir_esquema_arbol(ss,a, n.right(), pre);
      pre.replace(pre.size()-4, 4, "    ");
      escribir_esquema_arbol (ss,a, n.left(), pre);
      pre.erase(pre.size()-4, 4);    
    }
  }
}

// ----------------------------------------------------------------

void QuienEsQuien::escribir_arbol_completo() const{
  string pre = "";
  escribir_esquema_arbol(cout,this->arbol,this->arbol.root(),pre);
}

// ----------------------------------------------------------------

void QuienEsQuien::eliminar_nodos_redundantes(bintree<Pregunta>::node nodo) {
  // Si el nodo es nulo no se hace nada
  if (nodo.null() || esHoja(arbol, nodo)) {
  }
  // Si es el izquierdo, el nodo se sustituye por su hijo derecho y se llama a la función sobre este
  else if (nodo.left().null()) {
    eliminar_nodos_redundantes(nodo.right());  

    bintree<Pregunta> hijo;
    arbol.prune_right(nodo, hijo);
    arbol.replace_subtree(nodo, hijo, hijo.root());
  }
  // Respectivamente con el derecho
  else if (nodo.right().null()) {
    eliminar_nodos_redundantes(nodo.left());  

    bintree<Pregunta> hijo;
    arbol.prune_left(nodo, hijo);
    arbol.replace_subtree(nodo, hijo, hijo.root());
  }
  // En otro caso, se llama a la función sobre los dos hijos
  else {
    eliminar_nodos_redundantes(nodo.right());
    eliminar_nodos_redundantes(nodo.left());    
  }
}

// Llama a una función recursiva que interactua sobre cada nodo
// eliminando los redundantes desde abajo a arriba
void QuienEsQuien::eliminar_nodos_redundantes(){
  eliminar_nodos_redundantes(arbol.root());
}

// ----------------------------------------------------------------

float QuienEsQuien::profundidad_promedio_hojas(){
  //TODO :)

  return -1;
}

// ----------------------------------------------------------------

/**
 * @brief Genera numero enteros positivos aleatorios en el rango [min,max).
**/
int generaEntero(int min, int max){
    int tam= max -min;
    return ((rand()%tam)+min);
}

// ----------------------------------------------------------------

void QuienEsQuien::tablero_aleatorio(int numero_de_personajes){
  srand(0);

  this->limpiar();

  float log_2_numero_de_personajes = log(numero_de_personajes)/log(2);

  int numero_de_atributos = ceil(log_2_numero_de_personajes);

  cout << "Petición para generar "<< numero_de_personajes<<" personajes ";
  cout << "con "<<numero_de_atributos<< " atributos"<<endl;
  cout << "Paso 1: generar "<< pow(2,numero_de_atributos) << " personajes"<<endl;

  //Fase 1: completar el tablero con todos los personajes posibles
  //Completo el tablero y los nombres de personajes a la vez
  for(int indice_personaje=0;indice_personaje< pow(2,numero_de_atributos);indice_personaje++){
    vector<bool> atributos_personaje = convertir_a_vector_bool(indice_personaje,numero_de_atributos);
    string nombre_personaje = "Personaje_"+to_string(indice_personaje);

    this->personajes.push_back(nombre_personaje);
    this->tablero.push_back(atributos_personaje);
  }

  // Completo los nombres de los atributos.
  for(int indice_atributo=0;indice_atributo<numero_de_atributos;indice_atributo++){
    string nombre_atributo = "Atributo_"+to_string(indice_atributo);
    this->atributos.push_back(nombre_atributo);
  }

  cout << "Paso 2: eliminar "<< (pow(2,numero_de_atributos)-numero_de_personajes) << " personajes"<<endl;
  //Fase 2. Borrar personajes aleatoriamente hasta que quedan solo los que hemos pedido.
  while(personajes.size()>numero_de_personajes){
    int personaje_a_eliminar = generaEntero(0,personajes.size());

    personajes.erase(personajes.begin()+personaje_a_eliminar);
    tablero.erase(tablero.begin()+personaje_a_eliminar);
  }
}

// ----------------------------------------------------------------

// MAL
void QuienEsQuien::preguntas_formuladas(bintree<Pregunta>::node jugada) {
  bintree<Pregunta>::preorder_iterator it;

  // Si encuentra esa jugada sale del bucle
  for (it = arbol.begin_preorder(); it != arbol.end_preorder(); ++it) {
    if ((*it).obtener_pregunta() == (*jugada).obtener_pregunta()) {
      break; }
  }

  jugada = *it;

  if (jugada != arbol.root()) { 
    bintree<Pregunta>::node padre = (*it).parent();

    while (padre != arbol.root()) {
      cout << *padre << endl;  
      padre = padre.parent();
    }
    cout << *padre << endl;
    cout << "Pero aún no sé quién es" << endl;
  }
  else {
    cout << (*jugada).obtener_pregunta() << endl;
  }
}
