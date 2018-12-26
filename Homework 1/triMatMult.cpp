//
// triMatMult.cpp
//
// This program reads in two triangular matrices from two files and multiplies, outputing the resulting matrix
#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
using namespace std;

/*
This function accepts a double pointer to an array
and initializes it so that all the elements are equal
to 0
*/
void initializeArray(int **arr, int numElements) {
	for(int i = 0; i < numElements; i++) {
		(*arr)[i] = 0;
	}
}

/*
This function opens the corresponding file and reads in
the size of the matrix as well as storing the elements
of the matrix inside the corresponding
*/
void readInput(int** size, int** arr, char*** argv, int numArg) {
	ifstream f;

	f.open((*argv)[numArg]); // opens the file
	*size = (int*)malloc(sizeof(int));
	f >> (**size);

	*arr = (int*)malloc(((**size) * ((**size) + 1)/2) * sizeof(int)); // allocates the memory needed

	int count = 0;
	while(f.good()){ // while content is still being read
		f >> (*arr)[count];
		count++;
	}

	f.close(); // closes the file
}

/*
This function accepts the current row, column and
number of elements in the array and uses a zerocounter
to return the correct index
*/
int getIndex(int row, int col, int numElements) {
	if(col < row) {
		return -1;
	}
	int zeros = 0;
	// for loop counts the number of zeros
	for(int i = 0; i < (row + 1); i++) {
		zeros += i;
	}
	return ((row * numElements) + col - zeros);
}

/*
This function takes in two arrays that represent
triangular matrices and multiplies the two matrices 
while storing the results in array c
*/
void multiplyMatrice(int **a, int **b, int **c, int numElements) {
	for(int row = 0 ; row < numElements; row++) {
		for(int col = 0; col < numElements; col++) {
			for(int ele = 0; ele < numElements; ele++) {
				int Aindex = getIndex(row, ele, numElements);
				int Bindex = getIndex(ele, col, numElements);
				int Cindex = getIndex(row, col, numElements);
				if(Aindex == -1 || Bindex == -1 || Cindex == -1) {
					continue;
				}
				else {
					(*c)[Cindex] += ((*a)[Aindex] * (*b)[Bindex]);
				}
			}
		}
	}
}

int main(int argc, char **argv) {
	int* size;
	int* a;
	readInput(&size, &a, &argv, 1);

	int* b;
	readInput(&size, &b, &argv, 2);

	int* c = (int*)malloc(((*size) * ((*size) + 1)/2) * sizeof(int)); // declares and allocates memory for c
	initializeArray(&c, ((*size) * ((*size) + 1)/2));

	multiplyMatrice(&a, &b, &c, (*size));

	for(int i = 0; i < ((*size) * ((*size) + 1)/2); i++) {
		cout << c[i] << " ";
	}
}