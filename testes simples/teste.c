#include<stdio.h>    
#include<stdlib.h>
#include<stdbool.h>
#include<string.h>

int main(){
	float a;
	char v[10] = "-0.999999";

	a = atof(v);


	printf("%f\n", a);


	return 0;
}