#include<iostream>
#include<vector>
#include<string>

#include <cstdlib>

#include <fstream>

using namespace std;

enum Operador {
  HEREDAR,
  SUMAR,
  RESTAR,
  MULTIP,
  DIVIDIR
};

struct Casilla {
  vector<bool> op {false, false, false, false, false};	// 5 posibles operaciones en una casilla
  int valor;
};

ostream& operator<< (ostream &os, const Casilla &C) {
  os << C.valor << " ";

  if (C.op[HEREDAR]) os << "↓ "; else os << "  ";
  if (C.op[SUMAR])   os << "+ "; else os << "  ";
  if (C.op[RESTAR])  os << "- "; else os << "  ";
  if (C.op[MULTIP])  os << "* "; else os << "  ";
  if (C.op[DIVIDIR]) os << "/ "; else os << "  ";

  return os;
}

int Maximo(int a, int b, int c, int d, int e) {
  int max=a;

  if (max < b) max = b;
  if (max < c) max = c;
  if (max < d) max = d;
  if (max < e) max = e;

  return max;
}

void imprimir(int fil, int col, Casilla **M) {
  for (int i=0; i<fil; i++) {
 
    for (int j=0; j<col; j++)
      cout << M[i][j] << "|";

    cout << endl;
    cout << endl;
  }
}

vector<string> recuperarSolucion(Casilla **M, int i, int j, string actual, vector<int> &S) {
  vector<string> solucion;

  
  if (M[i][j].valor == 0) {
    solucion.push_back(actual.append(")"));
    return solucion;
  }
  else {
    int k = S[i-1];
    string k_string = to_string(k);
  
    vector<string> heredar, sumar, restar, multip, dividir;   

    if(M[i][j].op[HEREDAR])
      heredar = recuperarSolucion(M, i-1, j, actual.append(""), S);

    if(M[i][j].op[SUMAR]){
      string kk=actual;
      k_string = to_string(k);
      sumar   = recuperarSolucion(M, i-1, j-k, kk.append(k_string.append("+(")), S); 
    }

    if(M[i][j].op[RESTAR]){
      string kk=actual;
      k_string = to_string(k);
      restar  = recuperarSolucion(M, i-1, j+k, kk.append(k_string.append("-(")), S); 
    }	

    if(M[i][j].op[MULTIP]){
      string kk=actual;
      k_string = to_string(k);
      multip  = recuperarSolucion(M, i-1, j/k, kk.append(k_string.append("*(")), S); 
    }

    if(M[i][j].op[DIVIDIR]){
      string kk=actual;
      k_string = to_string(k);
      dividir = recuperarSolucion(M, i-1, j*k, kk.append(k_string.append("/(")), S);  
    }

    solucion.insert(solucion.end(), heredar.begin(), heredar.end());
    solucion.insert(solucion.end(), sumar.begin(),   sumar.end());
    solucion.insert(solucion.end(), restar.begin(),  restar.end());
    solucion.insert(solucion.end(), multip.begin(),  multip.end());
    solucion.insert(solucion.end(), dividir.begin(), dividir.end());

    return solucion;
  }
}


int maxValor(vector<int> &S) {
  int maximo, n = S.size();

  for (int i=0; i<n; i++)
    if (S[i] > maximo)
      maximo = S[i];


  return maximo;
}

int Cifras(int V, vector<int> &S, vector<string> &solu) {
  int N = S.size() + 1, 
      colMax = V*maxValor(S) + 1;


  Casilla **M = new Casilla *[N];
  for (int i=0; i < N; i++) 
    M[i] = new Casilla [colMax];
  

  // Rellenar primera fila a 0
  for (int i=0; i < colMax; i++) 
    M[0][i].valor = 0;

  // Rellenar primera colu a 0
  for (int i=0; i < N; i++)
    M[i][0].valor = 0;
  

  // Rellenar matriz
  int m, valor, heredar, sumar, restar, multip, dividir;
  
  for (int i=1; i < N; i++) {
    for (int j=1; j < colMax; j++) {
      m = j;
      heredar = sumar = restar = multip = dividir = 0; 	// Inicialización

      heredar = M[i-1][j].valor;      			// No cogerlo

      if (m-S[i-1] >= 0)
        sumar   = M[i-1][m-S[i-1]].valor + S[i-1];	// Cogerlo con suma

      if (m+S[i-1] < colMax)
        restar  = M[i-1][m+S[i-1]].valor - S[i-1];	// Cogerlo con resta

      if (m%S[i-1] == 0)    				// Por ahora, si no es divisible no se plantea
        multip  = M[i-1][m/S[i-1]].valor * S[i-1];	// Cogerlo con multiplicación

      if (m*S[i-1] < colMax)      
        dividir = M[i-1][m*S[i-1]].valor / S[i-1];	// Cogerlo con división

      valor = Maximo(heredar, sumar, restar, multip, dividir);
      M[i][j].valor = valor;

      if (valor == heredar) M[i][j].op[HEREDAR] = true;
      if (valor == sumar)   M[i][j].op[SUMAR]   = true;
      if (valor == restar)  M[i][j].op[RESTAR]  = true;
      if (valor == multip)  M[i][j].op[MULTIP]  = true;
      if (valor == dividir) M[i][j].op[DIVIDIR] = true;
    }
  }

//  imprimir(N, 8, M);

  // Recuperar solución - hasta que llegue a fila 0 o columna 0
  solu = recuperarSolucion(M, N-1, V, "", S);
 
  return M[N-1][V].valor;
}

int main (int argc, char *argv[]) {
  if (argc != 3) {
    cerr << "Uso: " << argv[0] << " <nombre_archivo> <valor_a_conseguir>" << endl;
    exit(1);
  }

  fstream f(argv[1]);
  if (!f) {
    cerr << "No se puede abrir el fichero" << endl;
    exit(1);
  }

  vector<int> v;
  int valor = atoi(argv[2]);

  string linea;

  while (f >> linea) 
    v.push_back(atoi(linea.c_str()));  
  

  vector<string> solucion;
 
  valor = Cifras(valor, v, solucion);

  cout << "Valor mas cercano: " << valor << endl;
  cout << "[Se lee de derecha a izquierda]\n" << endl;

  for (auto it = solucion.begin(); it != solucion.end(); it++)
    cout << *it << endl;
}
