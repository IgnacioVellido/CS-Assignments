#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/freeglut.h>



void Ejes (int width)
{   
    glLineWidth(width);
    glBegin(GL_LINES);
       glColor3f(1.0,0.0,0.0);
       glVertex3f(-1.0,0.0,0.0);
       glVertex3f(1.0,0.0,0.0);
       glColor3f(0.0,1.0,0.0);
       glVertex3f(0.0,-1.0,0.0);
       glColor3f(1.0,1.0,0.0);
       glVertex3f(0.0,1.0,0.0);   
    glEnd();
   
       
}


void Monigote ()
{
  
 
  // cara
  glLineWidth(1);
  glColor3f(1.0,0.8,0.6);
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
  glBegin(GL_POLYGON);
    glVertex3f(-0.2,0.0,0.0);
    glVertex3f(0.2,0.0,0.0);
    glVertex3f(0.2,0.55,0.0);
    glVertex3f(-0.2,0.55,0.0);
  glEnd(); 

  glColor3f(0.0,0.0,0.);
  glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
  glBegin(GL_POLYGON);
    glVertex3f(-0.2,0.0,0.0);
    glVertex3f(0.2,0.0,0.0);
    glVertex3f(0.2,0.55,0.0);
    glVertex3f(-0.2,0.55,0.0);
  glEnd(); 
   
}


static void Init( )
{
   glShadeModel( GL_FLAT);
}


static void Reshape( int width, int height )
{
    glViewport(0, 0, (GLint)width, (GLint)height);
    glOrtho (-1.0, 1.0,-1.0, 1.0, -10, 10.0);
}

static void Display( )
{

  glClearColor(0.5,0.5,0.5,0.0);
  glClear( GL_COLOR_BUFFER_BIT );
   
  
   
  Ejes(6);
  Monigote();
   
  glFlush();
}


static void Keyboard(unsigned char key, int x, int y )
{
 
  if (key==27)  // ESC
      exit(0);
  if (key=='a') {
    glShadeModel(GL_SMOOTH);
    Display();  // Se repite en cada bloque para no que se llame al pulsar otra tecla
  }
  if (key=='b') {
    glShadeModel(GL_FLAT);
    Display();
  }
}


int main( int argc, char **argv )
{
   glutInit(&argc,argv);
   glutInitDisplayMode( GLUT_RGB );

   glutInitWindowPosition( 20, 100 );
   glutInitWindowSize(500, 500 );
   glutCreateWindow("Practica 0 IG");


   Init();

   glutReshapeFunc(Reshape);
   glutDisplayFunc(Display);
   glutKeyboardFunc(Keyboard);
  
   glutMainLoop( );

   return 0;
}

