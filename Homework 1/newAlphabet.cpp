//
//	newAlphabet.cpp
//
//  This program accepts integers representing characters and converts them to the letters of the alphabet
#include <iostream>
using namespace std;

/* 
This function accepts a number representing a character and returns 
true if the number represents a capital character and returns false if the
number represents a lower case character.
*/
bool isCapital(int num) {
	if(num >> 26 == 1) { // shifts the binary sequence to the right by 26
		return true;
	}
	else {
		return false;
	}
}

/*
This function accepts a number representing a character and 
returns the amount of shifts it takes for the binary to completely 
become a string of 0's.
*/
int amountShifted(int num) {
	int shifts = 0;
	while((num & (0x1)) == 0) {
		num = num >> 1; // shifts the bit 1 over
		shifts++;
	}
	return shifts;
}

int main(int argc, char **argv) {

	cout << "You entered the word: ";

	int num;
	
	for(int i = 1; i < argc; i++) {
		num = atoi(argv[i]); // converts string input to int
		int shift = amountShifted(num);

		if(!isCapital(num)) {
			cout << (char)('a' + shift); // casts the binary to a char
		}
		if(isCapital(num)) {
			cout << (char)('A' + shift); // casts the binary to a char
		}
	}
}