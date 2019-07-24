// Fundamentos de Programación - 2016 - 2017
// Grupo F - David Pelta
// Ejercicios con vectores 

// En este mismo fichero, agregue el código necesario para resolver los problemas planteados.
#include <iostream>
#include <ctime>
#include <cstdlib>

using namespace std;

int main(){
const int TAM = 20;	
const int MIN = -10, MAX=10, NUM_VALORES = MAX-MIN+1;

int A[TAM], B[TAM];
int i, util_a, util_b;

time_t t;
srand ((int) time(&t));

// relleno el vector A con nros aleatorios entre MIN y MAX
for(i = 0; i < TAM; i++)
   A[i] = (rand() % NUM_VALORES) + MIN;

util_a = TAM;

// mostrar vector A. 


// Ej 1) Mostrar la posición de los elementos positivos de A


// Ej 2) Crear Vector B con los valores de las posiciones impares de A en orden inverso

// mostrar B

//Ej 3) Insertar -20 en la posición 3 de B, desplazando los elementos siguientes hacia la derecha

//Ej 4) Borrar el elemento en la posición 2 de B, desplazando los elementos siguientes hacia la izquierda

//Ej 5) Rotar A dos posiciones a la izquierda

//Ej 6) Ordenar A


// Ej 7) Mostrar la longitud de cada "palabra" contenida en el vector C. Las palabras están separadas por un espacio
// La salida debería ser 2, 4, 3, 5, 2, 2, 6
char C[] = {'l','a',' ','c','a','s','a',' ','d','e','l',' ','p','e','r','r','o',' ','e','s',' ','d','e',' ', 'm','a','d','e','r','a'};
int util_c = 30;


}
 
