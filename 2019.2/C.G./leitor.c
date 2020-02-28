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
Vertices* inserir_fim_vertice(Vertices *lista, float dado, int *flag_coord){
	Vertices *novo_no = (Vertices *)malloc(sizeof(Vertices));

	if (*flag_coord == 1){
		novo_no->x = dado;
		*flag_coord = 2;
	}
	else if (*flag_coord == 2){
		novo_no->y = dado;
		*flag_coord = 3;
	}
	else {
		novo_no->z = dado;
		*flag_coord = 1;
	}

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
void imprimir_faces(Lados *lista){
	Lados *percorre_lista = lista;
	// printf("%f\n", (percorre_lista+4)->valor);
	while(percorre_lista != NULL){
		printf("%d\n", percorre_lista->valor);
		percorre_lista = percorre_lista->prox;
	}
	printf("\n");
}

void imprimir_vertices(Vertices *lista){
	Vertices *percorre_lista = lista;
	// printf("%f\n", (percorre_lista+4)->valor);
	while(percorre_lista != NULL){
		printf("x = %f\n", percorre_lista->x);
		printf("y = %f\n", percorre_lista->y);
		printf("z = %f\n", percorre_lista->z);
		percorre_lista = percorre_lista->prox;
	}
	printf("\n");
}


// função principal
int main() {
	FILE *arq;
	char *ler;
	char linha[100];
	char str[10000] = "";
	int i, num;
	Lados *lista = NULL;
	Vertices *lista_vertices = NULL;

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
	int dado;

	// Lendo só os vértices e faces desejadas
	separar = strtok(str, separador);
	while(separar != NULL){

		if (separar[0] == 'c' && separar[1] == 'o' && separar[2] == 'o' && separar[3] == 'r' && separar[4] == 'd' &&\
			separar[5] == 'I' && separar[6] == 'n' && separar[7] == 'd' && separar[8] == 'e' && separar[9] == 'x') {

				flag = 1;
				for (int i = 0; i < strlen(separar); i++){
					if (separar[i] == '"'){
						strcat(face, &separar[i + 1]);
						dado = atoi(face);
						lista = inserir_fim_face(lista, dado);
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
						lista_vertices = inserir_fim_vertice(lista_vertices, dado, &flag_coord);
					}
				}
		}

		else if (strcmp(separar, "\"") == 0){
			flag = 0;
		}

		else if (flag == 1){
			dado = atoi(separar);
			lista = inserir_fim_face(lista, dado);
		}

		else if (flag == 2){
			dado = atof(separar);
			lista_vertices = inserir_fim_vertice(lista_vertices, dado, &flag_coord);
		}

		separar = strtok(NULL, separador);
	}	

	imprimir_faces(lista);
	imprimir_vertices(lista_vertices);
	return 0;
}