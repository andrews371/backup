#include<stdio.h>    
#include<GL/glut.h> // biblioteca para usar o OpenGL
#include<time.h>    // biblioteca para usar funções de tempo


void init(){  
  glClearColor(1.0,1.0,1.0,1.0); // indica a cor que será usada no fundo da janela
  glOrtho(-45, -25, -45, -15, -1, 1); // Posiciona a tela em comparação ao objeto. Os dois primeiros parâmetros são o mínimo
  // e o máximo do x que irá variar que nós vamos ver e os próximos dois são o mínimo e o máximo do y irá variar que nós vamos ver.
  // bom deixar uma margem de sobra para ver todo o objeto. É o referencial para a partir de que ponto até que ponto vamos ver o objetos
  glPointSize(10.0f);
}


void retaOpengl(){
  
  // "glClear(GL_COLOR_BUFFER_BIT);" Este comando pinta os buffers indicados com a cor especificada em glClearColor. 
  // Colocar sempre na função que irá desenhar. Por exemplo aqui colocamos em "retaOpengl" que é nossa função que vai 
  // desenhar
  glClear(GL_COLOR_BUFFER_BIT); 
  glColor3f(0.0,0.0,0.0); // Cor usada para desenhar objetos (para ficar visível tem que ser diferente da usada para limpar a tela)
  glBegin(GL_LINES);
    glVertex2f(-38,-38);
    glVertex2f(-28,-18);
  glEnd();

  int coordenadas[] = {-40,-40,-30,-20};
  float m = 2;
  float x = 0, y = 0;

  y = m*(-40) + ((m*(-(-40)) + (-40)));

  glBegin(GL_POINTS);
    glVertex2i(coordenadas[0],coordenadas[1]);  
    for(x = coordenadas[0] + 1; x <= coordenadas[2]; x++){
      y = m*x + (m*(40) - 40); 
      glVertex2i(x,y); 
    }
  glEnd();

  glFlush(); // imprime o conteúdo do buffer na tela
}   


void eqReta(){
  int coordenadas[] = {-40,-40,-30,-20};
  float m = 2;
  float x = 0, y = 0;

  y = m*(-40) + ((m*(-(-40)) + (-40)));

  glClear(GL_COLOR_BUFFER_BIT);
  glColor3f (0.0, 0.0, 0.0);

  glBegin(GL_POINTS);
    glVertex2i(coordenadas[0],coordenadas[1]);  
    for(x = coordenadas[0] + 1; x <= coordenadas[2]; x++){
      y = m*x + (m*(40) - 40); 
      glVertex2i(x,y); 
    }
  glEnd();

  glFlush();
}

int main(int argc, char** argv){

  clock_t t;
  int cont = 0;
  float tempo = 0;

  glutInit(&argc, argv); // inicia a biblioteca glut
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(256,256); // Tamanho da janela que abrirá
  glutInitWindowPosition(0,0); // Posição em que a janela que abrirá irá aparecer na tela do PC
  glutCreateWindow("Retas usando o OpenGL"); // Título da janela
  init();

  t = clock();
  for (cont = 0; cont <= 100000000; cont++){
    glutDisplayFunc(retaOpengl);
  }
  t = clock() - t;
  tempo = (float)t/CLOCKS_PER_SEC;
  printf("\nTempo: %.2f\n\n", tempo);


  glutMainLoop(); 
  return 0;
}