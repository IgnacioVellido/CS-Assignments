//**************************************************************************
// Práctica 5 usando objetos
//**************************************************************************

#include <vector>
#include <GL/gl.h>
#include "vertex.h"
#include <stdlib.h>
#include "file_ply_stl.hpp"

using namespace std;

const float AXIS_SIZE=5000;
typedef enum{POINTS,EDGES,SOLID_CHESS,SOLID,EMPHASIZED,SELECCION_CARA} _modo;

//*************************************************************************
// clase punto
//*************************************************************************

class _puntos3D {
  public:
  	      _puntos3D();
    void 	draw_puntos(float r, float g, float b, int grosor);

    vector<_vertex3f> vertices;
};

//*************************************************************************
// clase triángulo
//*************************************************************************

class _triangulos3D: public _puntos3D {
  public:
          _triangulos3D();
    void 	draw_aristas(float r, float g, float b, int grosor);
    void  draw_solido(float r, float g, float b);
    void 	draw_solido_ajedrez(float r1, float g1, float b1, float r2, float g2, float b2);
    void 	draw(_modo modo, float r1, float g1, float b1, float r2, float g2, float b2, float grosor);

    void  draw_solido_seleccion_completa(float r, float g, float b);
    void  draw_solido_seleccion_cara_back(float r, float g, float b);
    void  draw_solido_seleccion_cara_front(float r, float g, float b);
    void  draw_solido_emphasized();

    float r1, g1, b1, r2, g2, b2;

    vector<int> caras_emphasized;
    vector<_vertex3i> caras;
};


//*************************************************************************
// clase cubo
//*************************************************************************

class _cubo: public _triangulos3D {
  public:
	  _cubo(float tam=0.5);
};


//*************************************************************************
// clase piramide
//*************************************************************************

class _piramide: public _triangulos3D {
  public:
    _piramide(float tam=0.5, float al=0.75);
};

//*************************************************************************
// clase objeto ply
//*************************************************************************

class _objeto_ply: public _triangulos3D {
  public:
    _objeto_ply();

  int   parametros(char *archivo);
};

//************************************************************************
// objeto por revolución
//************************************************************************

class _rotacion: public _triangulos3D
{
public:
       _rotacion();
void  parametros(vector<_vertex3f> perfil1, int num1, int tapas);

vector<_vertex3f> perfil; 
int num;
};


//************************************************************************
// objeto articulado: AT-AT
//************************************************************************

class _cabeza: public _triangulos3D {
  public:
    _cabeza();
    void 	draw(_modo modo, float r1, float g1, float b1, float r2, float g2, float b2, float grosor);

    // Pinta cada cara de un color
    void  draw_solido_seleccion_completa(float r, float g, float b);
    // Destaca la cara con ese color
    void  emphasize_color(float r1, float g1, float b1, float r2, float g2, float b2);

    void  draw_solido_seleccion_cara_back(float r, float g, float b);
    void  draw_solido_seleccion_cara_front(float r, float g, float b);
    void  emphasize_cara(float r1, float g1, float b1, float r2, float g2, float b2);

    float anchura;
    float longitud;
    float giro_torretas;

  protected:
    _cubo cabeza;
    _piramide lateral_cabeza; // Uno a cada lado
    _rotacion torreta;  // Dos torretas 

    bool emphasized_cabeza, 
         emphasized_lateral_cabeza1, 
         emphasized_lateral_cabeza2, 
         emphasized_torreta1, 
         emphasized_torreta2;
};

class _chasis2: public _triangulos3D {
  public:
    _chasis2();
    void 	draw(_modo modo, float r1, float g1, float b1, float r2, float g2, float b2, float grosor);

    void  draw_solido_seleccion_completa(float r, float g, float b);
    void  emphasize_color(float r1, float g1, float b1, float r2, float g2, float b2);

    void  draw_solido_seleccion_cara_back(float r, float g, float b);
    void  draw_solido_seleccion_cara_front(float r, float g, float b);
    void  emphasize_cara(float r1, float g1, float b1, float r2, float g2, float b2);

    float longitud;
    float altura;
    float anchura;

  protected:
    _cubo cuerpo;

    bool emphasized_cuerpo1, 
         emphasized_cuerpo2, 
         emphasized_cuerpo3;
};

class _pierna: public _triangulos3D {
  public:
    _pierna();
    void 	draw(_modo modo, float r1, float g1, float b1, float r2, float g2, float b2, float grosor);

    void  draw_solido_seleccion_completa(float r, float g, float b);
    void  emphasize_color(float r1, float g1, float b1, float r2, float g2, float b2);

    void  draw_solido_seleccion_cara_back(float r, float g, float b);
    void  draw_solido_seleccion_cara_front(float r, float g, float b);
    void  emphasize_cara(float r1, float g1, float b1, float r2, float g2, float b2);

    float altura;
    float anchura;
    float longitud;
    float giro_pierna;

  protected:
    _cubo parte_superior;
    _cubo parte_inferior;
    _piramide pie;

    bool emphasized_parte_superior, 
         emphasized_parte_inferior, 
         emphasized_pie;
};

class _atat: public _triangulos3D {
  public:
    _atat();
    void 	draw(_modo modo, float r1, float g1, float b1, float r2, float g2, float b2, float grosor);

    void  draw_solido_seleccion_completa(float r, float g, float b);
    void  emphasize_color(float r1, float g1, float b1, float r2, float g2, float b2);

    void  draw_solido_seleccion_cara_back(float r, float g, float b);
    void  draw_solido_seleccion_cara_front(float r, float g, float b);
    void  emphasize_cara(float r1, float g1, float b1, float r2, float g2, float b2);

    float giro_cabeza;
    float giro_cabeza_min;
    float giro_cabeza_max;

    float giro_torretas;
    float giro_torreta_min;
    float giro_torreta_max;

    float giro_pierna;
    float giro_pierna_max;
    float giro_pierna_min;

  protected:
    _cabeza cabeza;
    _pierna pierna;
    _chasis2 chasis2;
};

//************************************************************************

/* Diagrama jerárquico

pie(triángulo)       -> scale -> translate -> translate(en base a giro_pierna)
parte_inferior(cubo) -> scale -> translate -> translate(en base a giro_pierna)
parte_superior(cubo) -> scale -> rotate(giro_pierna)

  ||
  \/
pierna

-------------------------------

cuerpo1(cubo) -> scale -> translate(parte derecha)
cuerpo2(cubo) -> scale -> translate(parte central)
cuerpo3(cubo) -> scale -> translate(parte izquierda)

  ||
  \/
chasis

-------------------------------

torreta(cilindro)        -> rotate -> rotate(giro_torretas) -> translate(torreta derecha)
torreta(cilindro)        -> rotate -> rotate(giro_torretas) -> translate(torreta izquierda)
lateral_cabeza(pirámide) -> scale -> rotate -> translate(lateral derecho)
lateral_cabeza(pirámide) -> scale -> rotate -> translate(lateral izquierdo)
cabeza(cubo)             -> scale

  ||
  \/
cabeza

-------------------------------

pierna_sup_izq(pierna) -> translate(en base a giro_pierna)
pierna_sup_dch(pierna) -> translate(en base a giro_pierna)
pierna_inf_izq(pierna) -> translate(en base a giro_pierna)
pierna_inf_dch(pierna) -> translate(en base a giro_pierna)
cuerpo(chasis)         -> translate(en base a giro_pierna)
cabeza(cabeza)         -> rotate(giro_cabeza) -> translate -> translate(en base a giro_pierna)

  ||
  \/
atat

*/