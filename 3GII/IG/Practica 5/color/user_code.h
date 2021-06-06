//**************************************************************************
// Práctica 1
//
//
// GPL
//**************************************************************************

#include <GL/gl.h>
#include "stdlib.h"


//**************************************************************************
// estructuras de datos para los modelos
//**************************************************************************

struct vertices
{
float coord[3];
};


struct caras
{
int ind_c[3];
};

struct solido{
int n_v;
int n_c;
vertices *ver;
caras    *car;
float r;
float g;
float b;
};


void construir_cubo(float tam, solido *cubo);
void construir_piramide(float tam, float al, solido *piramide);
void construir_ply(char *file, solido *ply);

void draw_puntos(vertices *ver, int n_v);
void draw_solido(solido *malla, float r, float g, float b, int modo);
void draw_solido_ajedrez(solido *malla, float r1, float g1, float b1, float r2, float g2, float b2);

// Función para pintar en el buffer y hacer la selección posteriormente
void draw_seleccion_color(solido *malla, int r, int g, int b);
