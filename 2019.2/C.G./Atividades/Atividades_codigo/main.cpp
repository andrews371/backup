#include <GL/glut.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <iostream>
#include <time.h> 

using namespace std;



static void  display(void)
{
	//ENTRADAS
	float x0 = 1;
	float y0 = 1;
	float x1 = 7;
	float y1 = 3;

    glClearColor(0.0, 0.0, 0.0, 0.0);		                        //DEFINE COR DA LIMPEZA DE TELA, NO CASO PRETO
    glClear(GL_COLOR_BUFFER_BIT);                                   //LIMPA A TELA TODA VEZ Q CHAMAR ESSA FUNCAO PELA COR ESCOLHIDA
    glMatrixMode(GL_PROJECTION);                                    //APLICA OPERACAO DE MATRIZ NA PILHA DE MATRIZ DE PROJECAO
    glLoadIdentity();                                               //SUBSTITUI A MATRIX ATAL PELA A IDENTIDADE
    gluOrtho2D(-26.0, 26.0, -26.0, 26.0);                           //ESPECIFICA  SISTEMA DE COORDENADAS ADOTADO PELO OPENGL
    glMatrixMode(GL_MODELVIEW);                                     //APLICA OPERACAO DE MATRIX NA PILHA DE MATRIX
    glLoadIdentity();                                               //SUBSTITUI A MATRIX ATUAL PELA A IDENTIDADE

    glColor3d(1.0,1.0,1.0);                                         //ESCOLHE A COR BRANCA PARA DESENHA PONTOS/OBJETOS

    float y;                                                        //PARAMENTROS PARA EQ DA RETA E DDA
    float y_aux;
    float x;
    float m;
    float dx, dy, p;

    

    clock_t tempo_inicial, tempo_final;                             //VARIAVEL DE CALCULO DO TEMPO
    double tempoEQRETA;
    double tempoDDA;
    double tempoBRESENHAM;
    double tempoBRESENHAMH;

    //EQUACAO DA RETA
    glBegin(GL_POINTS);                                           //DEFINE O OBJETO A SER DESENHADO
    tempo_inicial = clock();
    for(int i = 0; i < 10000; i++){    
    	m =(float)(y1 - y0) / (x1 - x0);                                //CALCULO DO DELTAY/DELTAX
            glVertex2s(x0,y0);
            for( x = x0 + 1; x < x1; x++){
                y = round( m * (x - x0) + y0 );
                glVertex2s(x,y);
            }
            glVertex2s(x1,y1);
        glEnd();
        glFlush();			                                          //DESCARREGA NA TELA
    }
    tempo_final = clock();			

    tempoEQRETA = (tempo_final - tempo_inicial) / (double)CLOCKS_PER_SEC;                              
    //FIM EQUACAO DA RETA

    //DDA
    x0 = x0 + 4; x1 = x1 + 4;
    tempo_inicial = clock();
    for(int i = 0; i < 10000; i++){
    	m =(float)(y1 - y0) / (x1 - x0);                                //CALCULO DO DELTAY/DELTAX
            x = x0;                                                   //SALVA PRIMEIRO VALOR
            y = y0;
            glVertex2s(x0,y0);
            
	    	y_aux = y0;

	    	for (x = x0 + 1; x < x1; x++){
	    		y_aux = y_aux + m;
	    		y = round(y_aux);
	    		glVertex3f(x,y,0.0);
	    	}
	        glVertex2s(x1,y1);
        
    }   
    tempo_final = clock();  
    tempoDDA = (tempo_final - tempo_inicial) / (double)CLOCKS_PER_SEC; 
    //FIM DDA

    //BRESENHAM
    x0 = x0 + 4; x1 = x1 + 4;
    tempo_inicial = clock();
    for(int i = 0; i < 10000; i++){
        
            
        glVertex2s(x0,y0);
        y = y0;

	  	dx = x1 - x0; dy = y1- y0;
	  	p = (2 * dy) - dx;

	  	for (x = x0 + 1; x < x1; x++){
	  		if (p < 0) {
	  			p = p + (2 * dy);
	  		}
	  		else {
	  			y = y + 1; p = p + (2 * dy) - (2 * dx);
	  		}
	        glVertex2s(x1,y1);
    
    	}

    }


    	
    tempo_final = clock();  
    tempoBRESENHAM = (tempo_final - tempo_inicial) / (double)CLOCKS_PER_SEC; 

    //FIM BRESENHAM

    glEnd();
    glFlush();						                                //DESCARREGA NA TELA

    //BRESENHAM(HARDWARE)
    x0 = x0 + 4; x1 = x1 + 4;
    tempo_inicial = clock();
    for(int i = 0; i < 10000; i++){
        glBegin(GL_LINES);
           glVertex2s(x0,y0);
           glVertex2s(x1,y1);
        
    }
    tempo_final = clock();  
    tempoBRESENHAMH = (tempo_final - tempo_inicial) / (double)CLOCKS_PER_SEC;     
    //FIM BRESENHAM(HARDWARE

    glEnd();
    glFlush();						                              //DESCARREGA NA TELA

    cout << "AVALIACAO DE DESEMPENHO" << endl << endl;

    cout << "Algoritmos ( EQ RETA / DDA / BRESENHAM )" << endl;
    cout << "Repeticoes: 10000" << endl;
    cout << "Maquina: i5 2450M - 2.50GHz" << endl << endl;

    cout << "TEMPO DE EXERCUCAO" << endl; 

    cout << "\t" << "EQ DA RETA         " << ": " << tempoEQRETA << " seg" << endl;  
    cout << "\t" << "DDA                " << ": " << tempoDDA << " seg" << endl;
    cout << "\t" << "BRESENHAM          " << ": " << tempoBRESENHAM << " seg" << endl;
    cout << "\t" << "BRESENHAM(HARDWARE)" << ": " << tempoBRESENHAMH << " seg" << endl << endl; 

}

int main(int argc, char *argv[])
{
    glutInit(&argc, argv);                                          //INICIA A GLUT
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);    	            //DEFINE O MODO DE EXIBICAO
    glutInitWindowPosition(0, 0);                                   //POSICAO DA JANELA NA AREA DO MONITOR
    glutInitWindowSize(250,250);                                    //TAMANHO DA JANELA GRAFICA

    glutCreateWindow("Traçar uma reta");                            //NOME DA JANELA
    glutDisplayFunc( display );                                     //PROCESSAMENTO DA CENA

    glutMainLoop();                                                 //ATIVA O LAÇO GRAFICO

}
