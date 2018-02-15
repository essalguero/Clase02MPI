#include <stdio.h>
#include <stdlib.h>

#include "operaciones.h"

void imprimeMatriz(int* mat, int numFilas, int numColumnas)
{
	for(int i = 0; i < numFilas; ++i)
	{
		for(int j = 0; j < numColumnas; ++j)
		{
			printf("%d,", mat[i * numFilas + j]);
		}
		printf("\n");
	}
}

int multiplicarVectores(int* v1, int* v2, int size)
{
	int resultado = 0;
	
	for (int i = 0; i < size; ++i)
	{
		resultado += v1[i] * v2[i];
	}
	
	return resultado;
}

void multiplicarMatrices(int* m1, int* m2, int* mRes, int numFilas, int numColumnas)
{
	for(int i = 0; i < numFilas; ++i)
		for(int j = 0; j < numColumnas; ++j)
			mRes[i * numFilas + j] = multiplicarVectores(&(m1[i * numFilas]), 
                                                                    &(m2[j * numColumnas]),
			                                            numColumnas);
}
