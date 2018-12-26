//
// scientificFloating.cpp
//
// This program accepts a number and represents it in base 2 scientific notation
#include <iostream>
using namespace std;

/*
This function extracts the 31st bit from float_int
to determine if the number is positive or negative
*/
void outputSign(unsigned int float_int) {
	if(((float_int >> 31) & (0x1)) != 0) {
		cout << "-1.";
	}
	else {
		cout << "1.";
	}
}

/*
This function prints out the mantissa from float_int
by extracting all the significant bits from the first
23 bits in the number.
*/
void outputMantissa(unsigned int float_int) {
	int numBits;

	// for loop to see how many significant bits there are
	for(int i = 0; i < 23; i++) {
		if(((float_int >> i) & (0x1)) == 0) {
			continue;
		}
		else { // if bit is not a 0
			numBits = i; 
			i = 23; // this will make you break out of the forloop
		}		
	}

	// prints out all the sig bits
	for(int i = 22; i > (numBits - 1); i--) {
		cout << ((float_int >> i) & (0x1));
	}

}

/*
This function prints out the exponent from float_int
by extracting the 8 bits representing the exponent and 
subtracting the 127 constant required.
*/
void outputExponent(unsigned int float_int) {
	int exp = ((float_int >> 23) & (0xFF));
	exp = exp - 127;

	cout << "E" << exp;
}

int main(void) {

	cout << "Please enter a float: ";
	float input;

	cin >> input;
	unsigned int float_int = (*(unsigned int*)&input);

	if(input == 0) { // special case when the input is 0
		cout << "0E0";
	}
	else {
		outputSign(float_int);
		outputMantissa(float_int);
		outputExponent(float_int);
	}
}