#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#include "operaciones.h"


#define TAG_DATO 0
#define TAG_OPERACION 1

#define OP_ADD 0
#define OP_MUL 1

void master(int argc, char** argv, int rank, int nproc)
{
	int numFilas = 100;
	int numColumnas = 100;
	int mat1[numFilas][numColumnas];
	int mat2[numFilas][numColumnas];
	int matRes[numFilas][numColumnas];

	int operacion = OP_MUL;

	MPI_Status status;
	
	//Inicializa las matrices
	for(int i = 0; i < 100; ++i)
	{
		for(int j = 0; j < 100; ++j)
		{
			mat1[i][j] = 1;
			mat2[i][j] = 1;
		}
	}

	// Mensajes pidiendo operaciones
	for(int slave = 1; slave < nproc; ++slave)
	{
		MPI_Send(&numFilas, 1, MPI_INT, slave, TAG_DATO, MPI_COMM_WORLD);
		MPI_Send(&numColumnas, 1, MPI_INT, slave, TAG_DATO, MPI_COMM_WORLD);
		MPI_Send(&(mat1[0][0]), numFilas * numColumnas, MPI_INT, slave, TAG_DATO, MPI_COMM_WORLD);
		MPI_Send(&(mat2[0][0]), numFilas * numColumnas, MPI_INT, slave, TAG_DATO, MPI_COMM_WORLD);
		
		// Solicitar operacion
		MPI_Send(&operacion, 1, MPI_INT, slave, TAG_OPERACION, MPI_COMM_WORLD);
	}

	// Mensajes Recibiendo Resultados
	for(int slave = 1; slave < nproc; ++slave)
	{
		MPI_Recv(&(matRes[0][0]), numFilas * numColumnas, MPI_INT, slave, TAG_DATO, MPI_COMM_WORLD, &status);
	}
	
}

void esclavo(int argc, char** argv, int rank, int nproc)
{

	int master = 0;

	int numFilas;
	int numColumnas;

	int* mat1;
	int* mat2;

	int* matRes;
	
	int operacion;
	
	MPI_Status status;

	// Recibir mensajes mandados por master
	MPI_Recv(&numFilas, 1, MPI_INT, master, TAG_DATO, MPI_COMM_WORLD, &status);
	MPI_Recv(&numColumnas, 1, MPI_INT, master, TAG_DATO, MPI_COMM_WORLD, &status);
	MPI_Recv(mat1, numFilas * numColumnas, MPI_INT, master, TAG_DATO, MPI_COMM_WORLD, &status);
	MPI_Recv(mat2, numFilas * numColumnas, MPI_INT, master, TAG_DATO, MPI_COMM_WORLD, &status);
	MPI_Recv(&operacion, 1, MPI_INT, master, TAG_OPERACION, MPI_COMM_WORLD, &status);
	
	
	mat1 = (int*)malloc(numFilas * numColumnas * sizeof(int));
	mat2 = (int*)malloc(numFilas * numColumnas * sizeof(int));

	// Declarar variable para guardar el resultado
	matRes = (int*)malloc(numFilas * numColumnas * sizeof(int));

	switch(operacion)
	{
		case OP_ADD:
			printf("No implementada suma\n");
			break;
		case OP_MUL:
			multiplicarMatrices(mat1, mat2, matRes, numFilas, numColumnas);
			break;
		default:
			printf("No implementada suma\n");
	}

	MPI_Send(matRes, numFilas * numColumnas, MPI_INT, master, TAG_DATO, MPI_COMM_WORLD);

}

int main(int argc, char** argv)
{
	// en funcion del rank se pasa a ser maestro o esclavo
	int rank;
	int nproc;

	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &nproc);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	
	switch(rank)
	{
		case 0: master(argc, argv, rank, nproc);
			break;
		
		default: esclavo(argc, argv, rank, nproc);
			break;
		
	}


	MPI_Finalize();

	return 0;
}
