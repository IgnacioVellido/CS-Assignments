//**************************************************************************
// Práctica 3 usando objetos
//**************************************************************************

#include <GL/glut.h>
#include <ctype.h>
#include <math.h>
#include <vector>
#include "objetos_B5.h"

using namespace std;

// tipos --------------------------------------------------------------------
typedef enum{CUBO, PIRAMIDE, OBJETO_PLY, ROTACION, ATAT} _tipo_objeto;
_tipo_objeto t_objeto=ATAT;
_modo   modo=SOLID_CHESS;

// ventana --------------------------------------------------------------------

// variables que definen la posicion de la camara en coordenadas polares
GLfloat Observer_distance;
GLfloat Observer_angle_x;
GLfloat Observer_angle_y;

// variables que controlan la ventana y la transformacion de perspectiva
GLfloat Window_width,Window_height,Front_plane,Back_plane;
GLfloat left_right,bottom_up,back,near;

// variables que determninan la posicion y tamaño de la ventana X
int UI_window_pos_x=50,UI_window_pos_y=50,UI_window_width=900,UI_window_height=900;

int estadoRaton[3], xc, yc, modo_color[5], cambio=0;
bool tipo_camara = true;
bool modo_camara = true;

int Ancho=900, Alto=900;
float factor=1.0;

void pick_color(int x, int y);

// Array con los colores a destacar
vector<_vertex3f> destacados;

bool modo_seleccion_completa = true;

// objetos --------------------------------------------------------------------
_cubo cubo;
_piramide piramide(0.85,1.3);
_objeto_ply  ply; 
_rotacion rotacion; 
_atat atat;

float rotar = -1;

//**************************************************************************
//
//***************************************************************************

void clear_window() {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
}

//**************************************************************************
// Funcion para definir la transformación de proyeccion
//***************************************************************************

void change_projection_alzado() {
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glViewport(0,Alto/2,Ancho/2,Alto/2);

  if (tipo_camara) { // Proyección en perspectiva con un punto de fuga
    glFrustum(-Window_width, Window_width, -Window_height, Window_height,
              Front_plane, Back_plane);
  }
  else {
    glOrtho(-left_right, left_right, -bottom_up, bottom_up, back, near);
    glScalef(factor,factor,1);
  }
}

void change_projection_planta() {
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glViewport(0,0,Ancho/2,Alto/2);

  glOrtho(-left_right, left_right, -bottom_up, bottom_up, back, near);
  glRotatef(90,1,0,0);  // para verlo desde arriba
  glScalef(factor,1.0,factor);
}

void change_projection_perfil() {
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glViewport(Ancho/2,Alto/2,Ancho/2,Alto/2);

  // Cámara
  glOrtho(-left_right, left_right, -bottom_up, bottom_up, back, near);
  glRotatef(90,0,1,0);
  glScalef(1.0,factor,factor);
}

//**************************************************************************
// Funcion para definir la transformación*ply1 de vista (posicionar la camara)
//***************************************************************************


void change_observer_alzado() {
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glTranslatef(0,0,-Observer_distance); // Hace el zoom
  glRotatef(Observer_angle_x,1,0,0);
  glRotatef(Observer_angle_y,0,1,0);
}

void change_observer_paralelo() {
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glTranslatef(0,-Observer_distance,0); // Hace el zoom
  glRotatef(Observer_angle_x,1,0,0);
  glRotatef(Observer_angle_y,0,1,0);
}

void change_observer_perfil() {
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glTranslatef(-Observer_distance,0,0); // Hace el zoom
  glRotatef(Observer_angle_x,1,0,0);
  glRotatef(Observer_angle_y,0,1,0);
}

//**************************************************************************
// Funcion que dibuja los ejes utilizando la primitiva grafica de lineas
//***************************************************************************

void draw_axis() {	
  glDisable(GL_LIGHTING);
  glLineWidth(2);
  glBegin(GL_LINES);
    // eje X, color rojo
    glColor3f(1,0,0);
    glVertex3f(-AXIS_SIZE,0,0);
    glVertex3f(AXIS_SIZE,0,0);
    // eje Y, color verde
    glColor3f(0,1,0);
    glVertex3f(0,-AXIS_SIZE,0);
    glVertex3f(0,AXIS_SIZE,0);
    // eje Z, color azul
    glColor3f(0,0,1);
    glVertex3f(0,0,-AXIS_SIZE);
    glVertex3f(0,0,AXIS_SIZE);
  glEnd();
}


//**************************************************************************
// Funcion que dibuja los objetos
//****************************2***********************************************

void draw_objects() {
  switch (t_objeto){
    case CUBO:        cubo.draw(modo,1.0,0.0,0.0,0.0,1.0,0.0,2);break;
    case PIRAMIDE:    piramide.draw(modo,1.0,0.0,0.0,0.0,1.0,0.0,2);break;
    case OBJETO_PLY:  ply.draw(modo,1.0,0.6,0.0,0.0,1.0,0.3,2);break;
    case ROTACION:    rotacion.draw(modo,1.0,0.0,0.0,0.0,1.0,0.0,2);break;
    case ATAT:        
      if (modo_seleccion_completa)
        atat.draw(modo,0.5,0.5,0.5,0.6,0.6,0.6,2);
      else
        atat.draw(SELECCION_CARA,0.5,0.5,0.5,0.6,0.6,0.6,2);
      break;
	}
}

void draw_objects_seleccion() {
  if (modo_seleccion_completa)
    atat.draw_solido_seleccion_completa(0.1,0.1,0.1);
  else
    atat.draw_solido_seleccion_cara_back(0.1,0.1,0.1);
}

//**************************************************************************
//
//***************************************************************************
void draw_scene(void) {
  glDrawBuffer(GL_FRONT);
  clear_window();

  // Alzado
  change_projection_alzado();
  change_observer_alzado();    
  draw_axis();
  draw_objects();
  
  // Planta
  change_projection_planta();
  change_observer_paralelo();
  draw_axis();
  draw_objects();

  // Perfil
  change_projection_perfil();
  change_observer_perfil();
  draw_axis();
  draw_objects();

  // Se vuelve a pintar en el buffer trasero -------------
  // glDrawBuffer(GL_FRONT_AND_BACK);
  glDrawBuffer(GL_BACK);
  clear_window();  

  // Igual pero para buffer trasero
  // Alzado
  change_projection_alzado();
  change_observer_alzado();    
  draw_axis();
  draw_objects_seleccion();
  
  // Planta
  change_projection_planta();
  change_observer_paralelo();
  draw_axis();
  draw_objects_seleccion();

  // Perfil
  change_projection_perfil();
  change_observer_perfil();
  draw_axis();
  draw_objects_seleccion();

  glFlush();
}

//***************************************************************************
// Funcion llamada cuando se produce un cambio en el tamaño de la ventana
//
// el evento manda a la funcion:
// nuevo ancho
// nuevo alto
//***************************************************************************

void change_window_size(int Ancho1,int Alto1) {
  Ancho=Ancho1;
  Alto=Alto1;
  draw_scene();
}

//***************************************************************************
// Funciones para manejo de eventos del ratón
//***************************************************************************

void clickRaton( int boton, int estado, int x, int y ) {
  if (boton== GLUT_RIGHT_BUTTON) {
    if (estado == GLUT_DOWN) {
      estadoRaton[2] = 1;
      xc=x;
      yc=y;
    } 
   else 
    estadoRaton[2] = 1;
  }

  if (boton== GLUT_LEFT_BUTTON) {
    if (estado == GLUT_DOWN) {
      estadoRaton[2] = 2;
      xc=x;
      yc=y;
      pick_color(xc, yc);
    } 
  }

  if (boton == 3) { // Rueda del ratón hacia arriba
    if (tipo_camara)
      Observer_distance/=1.2;
    else
      factor*=1.1;
    glutPostRedisplay();
  }

  if (boton == 4) { // Rueda del ratón hacia abajo
    if (tipo_camara)
      Observer_distance*=1.2;    
    else
      factor*=0.9;
    glutPostRedisplay();
  }
}

/*************************************************************************/

void getCamara (GLfloat *x, GLfloat *y) {
  *x=Observer_angle_x;
  *y=Observer_angle_y;
}

/*************************************************************************/

void setCamara(GLfloat x, GLfloat y) {
  Observer_angle_x=x;
  Observer_angle_y=y;
}

/*************************************************************************/

void RatonMovido(int x, int y) {
  float x0, y0, xn, yn; 

  if (estadoRaton[2]==1) {
      getCamara(&x0,&y0); // Valores de giro actuales de la cámara
      yn=y0+(y-yc);
      xn=x0-(x-xc);
      setCamara(xn,yn); // Se mueve en base a la diferencia del punto final y el 
                        // inicial mientras está pulsado
      xc=x;
      yc=y;
      glutPostRedisplay();
  }
}

//***************************************************************************
// Funciones para la seleccion
//************************************************************************

void pick_color(int x, int y) { // Da en coordenadas del dispositivo
  GLint viewport[4];
  unsigned char pixel[3];

  // Lee el último viewport creado (en pantalla partida es reducido)
  glGetIntegerv(GL_VIEWPORT, viewport); // Ver dimensiones del viewport                                        
  glReadBuffer(GL_BACK);
  glReadPixels(x,viewport[3]-y,1,1,GL_RGB,GL_UNSIGNED_BYTE,(GLubyte *) &pixel[0]);  
  // Para pantalla partida, ignorando glGetIntegerv
  glReadPixels(x,Alto-y,1,1,GL_RGB,GL_UNSIGNED_BYTE,(GLubyte *) &pixel[0]);  
  printf(" valor x %d, valor y %d, color %d, %d, %d \n",x,y,pixel[0],pixel[1],pixel[2]);

  if (modo_seleccion_completa)
    atat.emphasize_color(0,0,0, pixel[0], pixel[1], pixel[2]);
  else
    atat.emphasize_cara(0,0,0, pixel[0], pixel[1], pixel[2]);

  glutPostRedisplay();
}

//***************************************************************************
// Funcion llamada cuando se aprieta una tecla normal
//
// el evento manda a la funcion:
// codigo de la tecla
// posicion x del raton
// posicion y del raton
//***************************************************************************

void normal_key(unsigned char Tecla1,int x,int y) {
  switch (toupper(Tecla1)){
    case 'Q':exit(0);
    case '1':modo=POINTS;break;
    case '2':modo=EDGES;break;
    case '3':modo=SOLID;break;
    case '4':modo=SOLID_CHESS;break;
      case 'P':t_objeto=PIRAMIDE;break;
      case 'A':t_objeto=CUBO;break;
      case 'O':t_objeto=OBJETO_PLY;break;	
      case 'R':t_objeto=ROTACION;break;
      case 'T':t_objeto=ATAT;break;

        // Para hacer zoom con cámara en paralelo
        case '+': factor*=0.9; break; 
        case '-': factor*=1.1; break;
        case 'C': tipo_camara = !tipo_camara;break;

        // Cambiar modo de seleccion
        case 'S': modo_seleccion_completa = !modo_seleccion_completa ;break;
	}
  glutPostRedisplay();
}


//***************************************************************************
// Funcion llamada cuando se aprieta una tecla especial
//
// el evento manda a la funcion:
// codigo de la tecla
// posicion x del raton
// posicion y del raton

//***************************************************************************

void special_key(int Tecla1,int x,int y) {
  switch (Tecla1){
    case GLUT_KEY_LEFT:Observer_angle_y--;break;
    case GLUT_KEY_RIGHT:Observer_angle_y++;break;
    case GLUT_KEY_UP:Observer_angle_x--;break;
    case GLUT_KEY_DOWN:Observer_angle_x++;break;
    case GLUT_KEY_PAGE_UP:Observer_distance*=1.2;break;
    case GLUT_KEY_PAGE_DOWN:Observer_distance/=1.2;break;

    // Cabeza hacia arriba
    case GLUT_KEY_F1:atat.giro_cabeza+=1;
                      if (atat.giro_cabeza>atat.giro_cabeza_max) 
                        atat.giro_cabeza=atat.giro_cabeza_max;
                      break;
    // Cabeza hacia abajo
    case GLUT_KEY_F2:atat.giro_cabeza-=1;
                      if (atat.giro_cabeza<atat.giro_cabeza_min) 
                        atat.giro_cabeza=atat.giro_cabeza_min;
                      break;

    // Torretas hacia arriba
    case GLUT_KEY_F3:atat.giro_torretas+=1;
                      if (atat.giro_torretas>atat.giro_torreta_max) 
                        atat.giro_torretas=atat.giro_torreta_max;
                      break;
    // Torretas hacia abajo
    case GLUT_KEY_F4:atat.giro_torretas-=1;
                      if (atat.giro_torretas<atat.giro_torreta_min) 
                        atat.giro_torretas=atat.giro_torreta_min;
                      break;

    // Andar hacia adelante
    case GLUT_KEY_F5:atat.giro_pierna+=1;
                      if (atat.giro_pierna>atat.giro_pierna_max) 
                        atat.giro_pierna=atat.giro_pierna_max;
                      break;                
    // Andar hacia atrás
    case GLUT_KEY_F6:atat.giro_pierna-=1;
                      if (atat.giro_pierna<atat.giro_pierna_min) 
                        atat.giro_pierna=atat.giro_pierna_min;
                      break;

    // Activar animación
    case GLUT_KEY_F7:
      rotar = 1;
      break;

    // Desactivar animación
    case GLUT_KEY_F8:
      rotar = -1;
      break;
	}

  glutPostRedisplay();
}

//***************************************************************************
// Funcion de animación
//***************************************************************************

void animacion() {
  if (rotar > 0) {
    if (rotar < 40) {
      // Cabeza hacia arriba
      atat.giro_cabeza+=1;
      if (atat.giro_cabeza>atat.giro_cabeza_max) 
        atat.giro_cabeza=atat.giro_cabeza_max;

      // Torretas hacia arriba
      atat.giro_torretas+=1;
      if (atat.giro_torretas>atat.giro_torreta_max) 
        atat.giro_torretas=atat.giro_torreta_max;

      // Andar hacia adelante
      atat.giro_pierna+=1;
      if (atat.giro_pierna>atat.giro_pierna_max) 
        atat.giro_pierna=atat.giro_pierna_max;
    }
    else {      
      // Cabeza hacia abajo
      atat.giro_cabeza-=1;
      if (atat.giro_cabeza<atat.giro_cabeza_min) 
        atat.giro_cabeza=atat.giro_cabeza_min;


      // Torretas hacia abajo
      atat.giro_torretas-=1;
      if (atat.giro_torretas<atat.giro_torreta_min) 
        atat.giro_torretas=atat.giro_torreta_min;    


      // Andar hacia atrás
      atat.giro_pierna-=1;
      if (atat.giro_pierna<atat.giro_pierna_min) 
        atat.giro_pierna=atat.giro_pierna_min;
    }
    draw_scene();
    rotar = (rotar < 80)? rotar+0.01 : 1;    
  }
}

//***************************************************************************
// Funcion de incializacion
//***************************************************************************

void initialize(void) {
  // se inicalizan la ventana y los planos de corte
  Window_width=.5;
  Window_height=.5;
  Front_plane=1;
  Back_plane=1000;

  left_right = 3;
  bottom_up = 3;
  back = -100;
  near = 100;

  // se inicia la posicion del observador, en el eje z
  Observer_distance=5*Front_plane;
  Observer_angle_x=0;
  Observer_angle_y=0;

  // se indica cual sera el color para limpiar la ventana	(r,v,a,al)
  // blanco=(1,1,1,1) rojo=(1,0,0,1), ...
  glClearColor(1,1,1,1);

  // se habilita el z-bufer
  glEnable(GL_DEPTH_TEST);

  for (int i=0;i<5;i++) 
    modo_color[i]=0;
}

//***************************************************************************
// Programa principal
//
// Se encarga de iniciar la ventana, asignar las funciones e comenzar el
// bucle de eventos
//***************************************************************************


int main(int argc, char **argv) {
  // creación del objeto ply
  ply.parametros(argv[1]);

  // perfil 
  vector<_vertex3f> perfil2;
  _vertex3f aux;
  aux.x=1.0;aux.y=-1.4;aux.z=0.0;
  perfil2.push_back(aux);
  aux.x=1.0;aux.y=-1.1;aux.z=0.0;
  perfil2.push_back(aux);
  aux.x=0.5;aux.y=-0.7;aux.z=0.0;
  perfil2.push_back(aux);
  aux.x=0.4;aux.y=-0.4;aux.z=0.0;
  perfil2.push_back(aux);
  aux.x=0.4;aux.y=0.5;aux.z=0.0;
  perfil2.push_back(aux);
  aux.x=0.5;aux.y=0.6;aux.z=0.0;
  perfil2.push_back(aux);
  aux.x=0.3;aux.y=0.6;aux.z=0.0;
  perfil2.push_back(aux);
  aux.x=0.5;aux.y=0.8;aux.z=0.0;
  perfil2.push_back(aux);
  aux.x=0.55;aux.y=1.0;aux.z=0.0;
  perfil2.push_back(aux);
  aux.x=0.5;aux.y=1.2;aux.z=0.0;
  perfil2.push_back(aux);
  aux.x=0.3;aux.y=1.4;aux.z=0.0;
  perfil2.push_back(aux);
  rotacion.parametros(perfil2,6,1);

  // se llama a la inicialización de glut
  glutInit(&argc, argv);

  // se indica las caracteristicas que se desean para la visualización con OpenGL
  // Las posibilidades son:
  // GLUT_SIMPLE -> memoria de imagen simple
  // GLUT_DOUBLE -> memoria de imagen doble
  // GLUT_INDEX -> memoria de imagen con color indizado
  // GLUT_RGB -> memoria de imagen con componentes rojo, verde y azul para cada pixel
  // GLUT_RGBA -> memoria de imagen con componentes rojo, verde, azul y alfa para cada pixel
  // GLUT_DEPTH -> memoria de profundidad o z-bufer
  // GLUT_STENCIL -> memoria de estarcido_rotation Rotation;
  glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH);

  // posicion de la esquina inferior izquierdad de la ventana
  glutInitWindowPosition(UI_window_pos_x,UI_window_pos_y);

  // tamaño de la ventana (ancho y alto)
  glutInitWindowSize(UI_window_width,UI_window_height);

  // llamada para crear la ventana, indicando el titulo (no se visualiza hasta que se llama
  // al bucle de eventos)
  glutCreateWindow("PRACTICA - 5");

  // asignación de la funcion llamada "dibujar" al evento de dibujo
  glutDisplayFunc(draw_scene);
  // asignación de la funcion llamada "change_window_size" al evento correspondiente
  glutReshapeFunc(change_window_size);
  // asignación de la funcion llamada "normal_key" al evento correspondiente
  glutKeyboardFunc(normal_key);
  // asignación de la funcion llamada "tecla_Especial" al evento correspondiente
  glutSpecialFunc(special_key);

  // Animación continua  
  glutIdleFunc(animacion);

  // eventos ratón
  glutMouseFunc(clickRaton);  // **
  glutMotionFunc(RatonMovido);  // **

  // funcion de inicialización
  initialize();

  // inicio del bucle de eventos
  glutMainLoop();
  return 0;
}
