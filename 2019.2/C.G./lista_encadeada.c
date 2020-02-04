#include<stdio.h>    
#include<stdlib.h>

typedef struct posicao
{
	int x;
	struct posicao *prox;

}pos;

int main() {
	FILE *arq;
	char *ler;
	char linha[100];
	int a, i;
	pos *inicio, *fim, *anterior;

	// criando o 1o elemento da estrutura
	inicio = (pos *)malloc(sizeof(pos));
	if (inicio == NULL)
		return 0;
	fim = inicio;

	// alocando memória para cada elemento recebido diferente de "0"
	while(1){
		scanf("%d", &fim->x);
		if (fim->x == 0)
			break;
		fim->prox = (pos *)malloc(sizeof(pos));
		if (fim->prox == NULL)
			return 0;
		fim = fim->prox;
	}
	fim->prox = NULL;

	// percorrendo a lista
	fim = inicio;
	while(1){
		if (fim->prox != NULL){
			printf("%d ", fim->x);
			fim = fim->prox;
		}
		else
			break;
	}

	// Excluindo valor na lista
	printf("\nQual valor deseja excluir? ");
	scanf("%d", &a);
	// Excluindo do início
	if (inicio->x == a){
		anterior = inicio;
		inicio = inicio->prox;
		free(anterior);
	}

	// Excluindo de qlqr parte da lista sem ser do início
	else{
		fim = inicio;
		while(fim->x != a && fim->prox != NULL){
			anterior = fim;
			fim = fim->prox;
		}

		// elemento encontrado e excluído
		if (fim->x == a){
			anterior->prox = fim->prox;
			free(fim);
		}

		// elemento informado não existe na lista
		else
			printf("\nNumero nao existe na lista\n");;
	}

	// percorrendo a lista
	fim = inicio;
	while(1){
		if (fim->prox != NULL){
			printf("%d ", fim->x);
			fim = fim->prox;
		}
		else
			break;
	}
	printf("\n");

	// manipulando arquivo
	arq = fopen("arquivo.txt", "r");
	while(!feof(arq)){
		ler = fgets(linha, 100, arq);
		if (ler){
			printf("%s", linha);
		}
		i++;
	}
	fclose(arq);
	printf("\n");
	return 0;
}