// Francisco José Cotán López
// Ignacio Vellido Expósito

#include <fstream>
#include <iostream>
#include <string>
#include <math.h>

#include "../include/quienesquien.h"

using namespace std;

int main(int argc, char * argv[]){

	bool jugar = false;
	bool limpiar = false;
	QuienEsQuien quienEsQuien;
	
	if(argc == 2) {
		string parametroAleatorio = "aleatorio";

		if(argv[1]== parametroAleatorio) { 
			cout << "Creando un QuienEsQuien aleatorio"<< endl;
			int numero_de_personajes;
		   	int numero_de_atributos;

		   	do{
		   		cout << "¿Número de personajes? ";
		   		cin >>numero_de_personajes;
		   	} while(numero_de_personajes<=0);

		   	quienEsQuien.tablero_aleatorio(numero_de_personajes);

		   	string nombreFicheroSalida = string("datos/tablero") +
		   		"-num-per="+to_string(numero_de_personajes);

		   	cout << "Guardando tablero aleatorio en "<<nombreFicheroSalida<<endl;
		   	ofstream archivoDeSalida(nombreFicheroSalida);
		   	archivoDeSalida << quienEsQuien;

		   	cout << "Guardado"<<endl;
		   	return 0;

		} else {
			cout << "Cargando fichero para jugar'"<< argv[1] <<"'"<< endl;
			ifstream f (argv[1]);

			if (!f){
				cout<<"No puedo abrir el fichero "<<argv[1]<<endl;
				return 1;
			}

			f >> quienEsQuien;
			jugar = true;
		}
	} else if (argc == 3 ) {
		string parametroLimpiar = "limpiar";

		if(parametroLimpiar== argv[2]){
			cout << "Cargando fichero para limpiar (sin jugar) '"<< argv[1] <<"'"<< endl;
			ifstream f (argv[1]);

			if (!f){
				cout<<"No puedo abrir el fichero "<<argv[1]<<endl;
				return 1;
			}

			f>> quienEsQuien;
			jugar = false;
		} else {
			cout << "Modo '"<<argv[2]<<"' no reconocido"<<endl;
			return 1;
		}

	} else {
		cout << "No se reconocen los argumentos. Ejemplos de uso:" << endl;
		cout << "\tJugar:               ./bin/quienesquien RUTA_FICHERO"<< endl;
		cout << "\tLimpiar sin jugar:   ./bin/quienesquien RUTA_FICHERO limpiar"<< endl;
		cout << "\tGenerar aleatorio:   ./bin/quienesquien aleatorio"<< endl;
		return 1;
	}

	quienEsQuien.mostrar_estructuras_leidas();
	quienEsQuien.usar_arbol(quienEsQuien.crear_arbol());
	
	cout << "=========== Arbol en crudo ===========" << endl;
	quienEsQuien.escribir_arbol_completo();
	
	cout << "Profundidad promedio de las hojas del arbol: ";
	cout << quienEsQuien.profundidad_promedio_hojas() << endl; 
	cout << "======================================" << endl << endl << endl;

	quienEsQuien.eliminar_nodos_redundantes();
	
	cout << "=========== Arbol ===================="<<endl;
	quienEsQuien.escribir_arbol_completo();
	cout << "Profundidad promedio de las hojas del arbol: ";
	cout << quienEsQuien.profundidad_promedio_hojas()<<endl; 
	cout << "======================================" << endl << endl << endl;

	bool fin = false;
	int respuesta;
	do {
		if(jugar) {
			quienEsQuien.iniciar_juego();
		}

		cout << "======================================" << endl << endl << endl;
		cout << "Jugar otra vez ?" << endl;
		cout << "------| 1 = SI ||| 0 = NO |------" << endl;
		cin >> respuesta;

		if (!respuesta)
			fin = true;
	} while (!fin);
        
	return 0;
}
