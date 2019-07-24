#include <iostream>
#include <vector>
#include <cstdlib>

#include <fstream>

using namespace std;

void burbuja(vector<int> &C, int nelem) {
  int swap;

  for (int i=0; i < nelem-1; i++){
    for (int j=0; j < nelem-i-1; j++) {
      if (C[j+1] > C[j]) {
	swap = C[j];
	C[j] = C[j+1];
	C[j+1] = swap;	
      }  
    }
  }
}

void Suma (vector<int> &C, vector<bool> &S, int M){
  int n = C.size(),
      cantidad_actual = 0,
      x = 0,
      indice = 0;

  burbuja(C, C.size());	// Ordenación del vector (de menor a mayor)

  while (indice < n && cantidad_actual < M){
    x = C[indice];

    if (C[indice] + cantidad_actual <= M){
      S[indice] = true;
      cantidad_actual += x;
    }
    else	// Está inicializado a false, no afecta
      S[indice] = false;

    indice++;
  }
}


int main (int argc, char *argv[]) {
  if (argc != 3) {
    cerr << "Uso: " << argv[0] << " <nombre_archivo> <valor_a_sumar>" << endl;
    exit(1);
  }

  fstream f(argv[1]);
  if (!f) {
    cerr << "No se puede abrir el fichero" << endl;
    exit(1);
  }

  vector<int> v;
  vector<bool> b;
  int valor = atoi(argv[2]);

  string linea;

  while (f >> linea) {
    v.push_back(atoi(linea.c_str()));
    b.push_back(false);    
  }

  
  Suma (v, b, valor);

  cout << "Valor: " << valor << endl;

  for (unsigned i = 0; i < v.size(); i++)
    cout << v[i] << " " << b[i] << endl;
}

