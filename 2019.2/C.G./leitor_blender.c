#include<stdio.h>    
#include<stdlib.h>
#include<stdbool.h>
#include<string.h>

// estrutura do nó de faces da lista
typedef struct lados
{
	int valor;
	struct lados *prox;

}Lados;

// estrutura do nó de vértices da lista
typedef struct vertices
{
	float x, y, z;
	struct vertices *prox;

}Vertices;

// inserindo as faces no fim da lista
Lados* inserir_fim_face(Lados *lista, int dado){
	Lados *novo_no = (Lados *)malloc(sizeof(Lados));
	novo_no->valor = dado;

	if (lista == NULL){
		novo_no->prox = NULL;
		lista = novo_no;
	}
	else{
		Lados *percorre_lista = lista;
		while(percorre_lista->prox != NULL){
			percorre_lista = percorre_lista->prox;
		}

		novo_no->prox = NULL;
		percorre_lista->prox = novo_no;
	}

	return lista;
}

// EDITAR

// inserindo os vértices no fim da lista
Vertices* inserir_fim_vertice(Vertices *lista, float x, float y, float z){
	Vertices *novo_no = (Vertices *)malloc(sizeof(Vertices));

	novo_no->x = x;
	novo_no->y = y;
	novo_no->z = z;

	if (lista == NULL){
		novo_no->prox = NULL;
		lista = novo_no;
	}
	else{
		Vertices *percorre_lista = lista;
		while(percorre_lista->prox != NULL){
			percorre_lista = percorre_lista->prox;
		}

		novo_no->prox = NULL;
		percorre_lista->prox = novo_no;
	}

	return lista;
}

// imprimindo lista
void imprimir_faces(int f, Lados *lista, int *tam_faces){
	Lados *percorre_lista = lista;

	if (f >= *tam_faces){
		printf("Índice de face inválido.\n");
		exit(0);
	}

	for (int i = 0; i < f; i++){
		if (percorre_lista != NULL){
			percorre_lista = percorre_lista->prox;
		}
	}
	
	printf("%d\n", percorre_lista->valor);
	printf("\n");
}

void imprimir_vertices(int v, Vertices *lista, int *tam_vertices){
	Vertices *percorre_lista = lista;

	if (v >= *tam_vertices){
		printf("Índice de vértice inválido.\n");
		exit(0);
	}

	for (int i = 0; i < v; i++){
		if (percorre_lista != NULL){
			percorre_lista = percorre_lista->prox;
		}
	}

	printf("%f\n", percorre_lista->x);
	printf("%f\n", percorre_lista->y);
	printf("%f\n", percorre_lista->z);
	// while(percorre_lista != NULL){
	// 	printf("x = %f\n", percorre_lista->x);
	// 	printf("y = %f\n", percorre_lista->y);
	// 	printf("z = %f\n", percorre_lista->z);
	// 	percorre_lista = percorre_lista->prox;
	// }
	printf("\n");
}

// função para ler o arquivo
void leitor(int *tam_faces, int *tam_vertices, int *tam_vert_por_face, Lados *lista_faces, Vertices *lista_vertices) {
	FILE *arq;
	char *ler;
	char linha[100];
	char str[10000] = "";
	int i, num;

	// inserindo elementos através do teclado. Condição de parada: "0" digitado.
	/*while(1){
		scanf("%d", &num);
		if (num == 0)
			break;
		lista = inserir_fim_face(lista, num);
	}*/

	/*lista = inserir_fim_face(lista, 10);
	lista = inserir_fim_face(lista, 20);
	lista = inserir_fim_face(lista, 30);
	lista = inserir_fim_face(lista, 40);
	imprimir_faces(lista);*/

	// lendo arquivo todo
	arq = fopen("cubo.x3d", "r");
	while(!feof(arq)){
		ler = fgets(linha, 100, arq);
		if (ler){
			strcat(str, linha);
		}
		i++;
	}
	fclose(arq);
	printf("\n");
	
	// Variáveis usadas para ler os vértices e faces desejadas
	char *separar;
	char separador[] = " \n";
	int flag = 0;
	int flag_coord = 1;
	char face[4];
	char vert[10];
	float dado;
	float coord[3];
	bool flag_vert_face = false;

	// Lendo só os vértices e faces desejadas
	separar = strtok(str, separador);
	while(separar != NULL){

		if (separar[0] == 'c' && separar[1] == 'o' && separar[2] == 'o' && separar[3] == 'r' && separar[4] == 'd' &&\
			separar[5] == 'I' && separar[6] == 'n' && separar[7] == 'd' && separar[8] == 'e' && separar[9] == 'x') {

				flag = 1;
				for (int i = 0; i < strlen(separar) - 1; i++){
					if (separar[i] == '"'){
						strcat(face, &separar[i + 1]);						
						dado = atoi(face);				
						lista_faces = inserir_fim_face(lista_faces, dado);
						(*tam_vert_por_face)++;
					}
				}
		}

		else if (separar[0] == 'p' && separar[1] == 'o' && separar[2] == 'i' && separar[3] == 'n' && separar[4] == 't' &&\
			separar[5] == '=' && separar[6] == '"') {

				flag = 2;
				for (int i = 0; i < strlen(separar) - 1; i++){
					if (separar[i] == '"'){
						strcat(vert, &separar[i + 1]);						
						dado = atof(vert);

						// setando o x do vértice
						coord[0] = dado;
						flag_coord++;
					}
				}
		}

		else if (strcmp(separar, "\"") == 0){
			flag = 0;
		}

		else if (flag == 1){
			dado = atoi(separar);		
			lista_faces = inserir_fim_face(lista_faces, dado);
			if (dado == -1){
				(*tam_faces)++;
				flag_vert_face = true;
			}
			if (flag_vert_face == false){
				(*tam_vert_por_face)++;
			}
		}

		else if (flag == 2){
			dado = atof(separar);	

			if (flag_coord == 1){
				// setando o x do vértice
				coord[0] = dado;
				flag_coord++;
			}

			else if (flag_coord == 2){
				// setando o y do vértice
				coord[1] = dado;
				flag_coord++;
			}

			else {
				// setando o z do vértice
				coord[2] = dado;
				flag_coord = 1;
				lista_vertices = inserir_fim_vertice(lista_vertices, coord[0], coord[1], coord[2]);
				(*tam_vertices)++;
			}

			
		}

		separar = strtok(NULL, separador);
	}	

	// imprimir_faces(5, lista_faces, &tam_faces);
	// imprimir_vertices(v, lista_vertices, &tam_vertices);
}