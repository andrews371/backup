#include<stdio.h>    
#include<stdlib.h>
#include<stdbool.h>
#include<string.h>

// estrutura do nó da lista
typedef struct no
{
	float valor;
	struct no *prox;

}No;

// inserindo elemento no fim da lista
No* inserir_fim(No *lista, float dado){
	No *novo_no = (No *)malloc(sizeof(No));
	novo_no->valor = dado;

	if (lista == NULL){
		novo_no->prox = NULL;
		lista = novo_no;
	}
	else{
		No *percorre_lista = lista;
		while(percorre_lista->prox != NULL){
			percorre_lista = percorre_lista->prox;
		}

		novo_no->prox = NULL;
		percorre_lista->prox = novo_no;
	}

	return lista;
}

// imprimindo lista
void imprimir_lista(No *lista){
	No *percorre_lista = lista;
	while(percorre_lista != NULL){
		printf("%.2f ", percorre_lista->valor);
		percorre_lista = percorre_lista->prox;
	}
	printf("\n");
}

// ler o arquivo retornando informação a partir de uma string (referência) passada
char* referencia(char separar[], char str[], char ref[], char separador[]){
	char resultado[1000] = "";
	bool flag = false;
	separar = strtok(str, separador);

	while(separar != NULL){

		if (strcmp(separar, ref) == 0){ // igual a 0 significa palavras iguais
			flag = true;
		} 

		if (flag == true){
			strcat(resultado, separar);
			strcat(resultado, " ");
		}
		separar = strtok(NULL, separador);
	}
	separar = resultado;
	return separar;
}

// separa as strings pelo separador passado
char* split(char separar[], char str[], char separador[]){
	char resultado[1000] = "";
	separar = strtok(str, separador);
	while(separar != NULL){
		strcat(resultado, separar);
		strcat(resultado, " ");
		separar = strtok(NULL, separador);
		
	}
	
	separar = resultado;
	return separar;
}

// separa as strings pelo separador passado e aloca posição de memória
void split_aloca(char separar[], char str[], char separador[], No *lista){
	char resultado[1000] = "";
	separar = strtok(str, separador);
	while(separar != NULL){
		printf("split_aloca = %s\n", separar);
		separar = strtok(NULL, separador);		
	}
}

// checa em uma string o caractere passado
char* checa_caractere(char separar[], char str[], char separador[], char caractere[], No *lista){
	char simbolo, resultado[1000] = "";
	int i;
	char *separar2;
	float num;
	separar = strtok(str, separador);
	while(separar != NULL){

		for (i = 0; i < strlen(separar); i++){
			simbolo = separar[i];
			if (simbolo == ','){
				strcpy(resultado,separar);
				//split_aloca(separar2, resultado, ",", lista);
				printf("resultado = %s\n", resultado);
				//num = atof(separar);
				//lista = inserir_fim(lista, num);
			}	
		}

		separar = strtok(NULL, separador);
		
	}
	
	separar = resultado;
	return separar;
}


// função principal
int main() {
	FILE *arq;
	char *ler;
	char linha[100];
	char str[10000] = "";
	int i, num;
	No *lista = NULL;

	// inserindo elementos através do teclado. Condição de parada: "0" digitado.
	/*while(1){
		scanf("%d", &num);
		if (num == 0)
			break;
		lista = inserir_fim(lista, num);
	}*/

	/*lista = inserir_fim(lista, 10);
	lista = inserir_fim(lista, 20);
	lista = inserir_fim(lista, 30);
	lista = inserir_fim(lista, 40);
	imprimir_lista(lista);*/

	// lendo arquivo
	arq = fopen("arquivo.txt", "r");
	while(!feof(arq)){
		ler = fgets(linha, 100, arq);
		if (ler){
			strcat(str, linha);
		}
		i++;
	}
	fclose(arq);
	printf("\n");
	
	char *separar;

	// extrair informação do arquivo a partir da referência (string) desejada
	separar = referencia(separar, str, "vertice1:", " \n");
	printf("separar = %s\n", separar);
	strcpy(str, separar);

	// verifica a ocorrência do último parâmetro passado abaixo, em cada string resultante da operação anterior
	checa_caractere(separar, str, " ", ",", lista);

	return 0;
}