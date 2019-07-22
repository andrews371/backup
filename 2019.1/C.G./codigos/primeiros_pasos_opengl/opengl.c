#include<stdio.h>
#include<GL/glut.h>
#include<time.h>


void init(){  
  glClearColor(1.0,1.0,1.0,1.0); // limpa a janela para a cor especificada
  glOrtho (-45, -25, -45, -15, -1, 1); // Posiciona a tela em comparação ao objeto. Os dois primeiros parâmetros são o mínimo
  // e o máximo do x que irá variar que nós vamos ver e os próximos dois são o mínimo e o máximo do y irá variar que nós vamos ver.
  // bom deixar uma margem de sobra para ver todo o objeto. É o referencial para a partir de que ponto até que ponto vamos ver o objeto
}


void retaOpengl(){
  glClear(GL_COLOR_BUFFER_BIT); // a janela é clareada (limpa) para a cor especificada em glClearColor a partir daqui
  glColor3f(0.0,0.0,0.0); // Cor usada para desenhar objetos (para ficar visível tem que ser diferente da usada para limpar a tela)
  glBegin(GL_LINES);
    glVertex2f(-40,-40);
    glVertex2f(-30,-20);
  glEnd();
  glFlush();
}


void eqReta(){
  int coordenadas[] = {-40.00,-40.00,-30.00,-20.00};
  float m = 2.0;
  float x,y;
  x = coordenadas[0] + 0.1;

  y = m*(-40.00) + ((m*(-(-40.00)) + (-40.00)));

  glClear(GL_COLOR_BUFFER_BIT);
  glColor3f (0.0, 0.0, 0.0);

  glBegin(GL_POINTS);
    glVertex2i(coordenadas[0],coordenadas[1]);  
    while(x <= coordenadas[2]){
      y = m*x + (m*(-x) + y); 
      glVertex2i(x,y); 
      printf("Pontos: %.2f %.2f\n",x,y);
      x = x + 0.1;
    }
  glEnd();

  glFlush();
}

int main(int argc, char** argv){

  clock_t t;
  int cont = 0;
  float tempo = 0;

  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(256,256); // Tamanho da janela que abrirá
  glutInitWindowPosition(0,0); // Posição em que a janela que abrirá irá aparecer na tela do PC
  glutCreateWindow("Retas usando o OpenGL"); // Título da janela
  init();

  t = clock();
  for (cont = 0; cont <= 100000000; cont++){
    glutDisplayFunc(eqReta);
  }
  t = clock() - t;
  tempo = (float)t/CLOCKS_PER_SEC;
  printf("\nTempo: %.2f\n\n", tempo);


  glutMainLoop(); 
  return 0;
}