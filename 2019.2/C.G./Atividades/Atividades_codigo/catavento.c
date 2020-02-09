#include<stdio.h>    
#include<GL/glut.h> // biblioteca para usar o OpenGL
#include<stdlib.h>

void desenhoHelices() {
    GLfloat ang = 5; // Definindo um ângulo.
    float interv = 90; // Valor para incrementar o ângulo.
    int hel = 4; // Definindo a quantidade de hélices do cata-vento.

    glColor3f(0, 0, 1.5); // Cor laranja, para as hélices do cata-vento.
    for(int i = 0; i < hel; i++, ang += interv) {
        
        glRotatef(ang, 0.0f, 0.0f, 1.0f); // Gira o objeto ao redor do 
        // vetor (x,y,z). O giro é em graus, no sentido anti-horário.

        // Desenhando a hélice.
        glBegin(GL_TRIANGLES); // Desenhando triângulo (que será a hélice).
            glVertex2f(0.3f, 0.3f); // Vértice da esquerda.
            glVertex2f(0.3f, 0.0f); // Vértice da direita.
            glVertex2f(0.0f, 0.0f); // Vértice do Topo.
        glEnd();
        glFlush(); // Determina que se completem os comandos enviados, esvaziando 
        // buffers com comandos. Efetua a exibição de imagem na
     // tela. OBS : Este comando deve ser usado, quando se estiver utilizando apenas 
        // um buffer de cor. Para 2 buffers, usa-se glutSwapBuffers.
    } 
}

void desenhoPonto() {
    glLineWidth(5); // Tamanho de um ponto
    glColor3f(0, 0, 0); // Cor do ponto
    glBegin(GL_LINES); // Definindo um ponto, que será
    // desenhado.
        glVertex2d(0, 0); // Definindo o ponto, na origem.
        glVertex2d(0,-0.8);
    glEnd();
}

void display(){
    glClearColor(1,1,1,1); // Cor de fundo da janela. Cor Branca.
    glClear(GL_COLOR_BUFFER_BIT); // Limpa toda a janela para a cor do comando glClearColor.
    glLoadIdentity(); // Reiniciar a Localização e orientação do sistema de 
    // coordenadas.

    desenhoPonto();
    desenhoHelices();

    glFlush();
}

void init(){
  glClearColor(0, 0, 0, 0.0); // Limpa o fundo de janela inserindo a cor especificada
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0.0, 1.0, 0.0, 1.0, -1.0, 1.0);
}

int main(int argc, char** argv){

  glutInit(&argc, argv); // inicia a biblioteca glut
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
  glutInitWindowSize(512,512); // Tamanho da janela que abrirá
  glutInitWindowPosition(100,100); // Posição em que a janela que abrirá irá aparecer na tela do PC
  glutCreateWindow("Pontos"); // Título da janela
  init();
  glutDisplayFunc(display); // chamada da função que realmente desenha. Necessário usar glutDisplayFunc 
                            // para poder usar comandos de redimentsionamento de janela, etc.

  glutMainLoop(); 
  return 0;
}
