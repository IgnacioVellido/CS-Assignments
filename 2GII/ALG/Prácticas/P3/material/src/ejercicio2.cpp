#include <iostream>
#include <vector>
#include <cstdlib>

#include <fstream>

using namespace std;

#define PRINT

// En S solución (elementos que coges)
void Suma(vector<int> &C, vector<bool> &S, int L){
  int n = C.size(),
      M[n+1][L+1]; 

  // Rellenar primera col a 0
  for (int i = 0; i <= L; i++)
    M[0][i] = 0;

  // Rellenar primera fil a 0
  for (int i = 0; i <= n; i++)
    M[i][0] = 0;

  // Rellenar matriz
  for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= L; j++) {

      if (j-C[i-1] >= 0) { // Si es casilla válida, ver el máximo
	if (M[i-1][j] > (M[i-1][j-C[i-1]] + C[i-1]))
	  M[i][j] = M[i-1][j];

	else
	  M[i][j] = M[i-1][j - C[i-1]] + C[i-1];
      }
      else		  // En otro caso, heredar
        M[i][j] = M[i-1][j];
    }
  }

  #ifdef PRINT
    for (int i = 0; i <= n; i++){
      cout << endl;
      for (int j = 0; j <= L; j++)
        cout << M[i][j] << " ";
    }
    cout << "\n" << endl;
  #endif


  int j = L;

  // Recuperar solución
  for (int i = n; i > 0; i--) {
    if (j <= 0 || M[i][j] == M[i-1][j])  // Si es igual que el de arriba
      S[i-1] = false;		   	// No se coge
    else {
      S[i-1] = true;
      j = j - C[i-1];		   	// Se coge en caso contrario			
    }
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

  cout << "Solucion:\nValor: " << valor << endl;
  for (unsigned i = 0; i < v.size(); i++) {
    cout << v[i] << " ";
    cout << b[i] << " " << endl;
  }
}
