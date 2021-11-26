//
//  changeOfBase.cpp
//
//  Converts an integer number from one base to another

#include <stdio.h>
#include <iostream>
#include <string>
#include <iterator> //for reverse iterator
#include <math.h> //for pow()
#include <ctype.h> //for isalpha()
using namespace std;

//converts letters in number input to corresponding digit
//example char 'G' to 16 (integer representation)
int convertHex(char val) {
    
    int digit;
    digit = (val - 'A') + 10;
    
    return digit;
}

//converts numbers in string input to an int
//example: char '3' to int 3
int convertStringNumber(char val) {
    
    int digit;
    digit = val - '0'; //converts digit from char to int
    
    if(digit > 9) { //if(digit<9) digit is a number
        digit = convertHex(val); //turns numbers greater than 9 into hex digits
    }
    
    return digit;
    
}

//converts number to base10 representation
int findBase10Rep(string str, int base) {
    
    int sum = 0;
    int digit;
    char val; // character holding letter/number of number inputted
    double exp = 0;
    
    //reverse iteration goes through input number character by character starting at the end
    for(string::reverse_iterator rit=str.rbegin(); rit != str.rend(); rit++) {
        val = *rit;

        if(isalpha(val)) //checks if char is a letter
            digit = convertHex(val);
        
        else //char must be a number
            digit = convertStringNumber(val);
        
        sum = sum + (digit*pow((double)base,exp)); //computes the decimal representation
        exp++;
    
    }
    
    return sum; //returns number as base10 representation
}

//converts number to NewBase
string convertNewBase(int num, int newBase) {
    
    string newNum = ""; //this will be the converted number
    int quotient = num; //stores the orignal
    char c_rem; //remainder stored as a char
    
    while(((double)num/newBase) != 0) { //checks if calculation results in 0 which would means
                                        //conversion is complete
        
        int remainder = quotient % newBase;
        
        if(remainder > 9){
            c_rem = (char)('A'+ (remainder-10)); //converts remainder to corresponding char
                                                //example remainder 16 converted to G
            
            newNum += c_rem;                    //adds remainder to new number
        }
        else {
            string sRem = ::to_string(remainder); //converts remainder to string
            newNum += sRem; //adds remainder to new number
        }
        
        quotient = (double)num / newBase;
        num = quotient;
        
    } //end of while loop
    
    return newNum;
}



//outputs necessary information
void print(string str, int base, string newNum, int newBase){
    
    int i;
    
    cout<<str<<" base "<<base<<" is ";
    
    for(i = (int)newNum.length()-1; i >= 0; i--){ //outputs string in reverse to correctly print new num
        cout << newNum.at(i);
    }
    
    cout<<" base "<<newBase<<endl;
    
}

//gets user input and calls corresponding functions
int main(int argc, const char * argv[]) {
    
    int base, newBase;
    string num;
    
    cout<<"Please enter the number's base: ";
    cin>>base;
    
    cout<<"Please enter the number: ";
    cin>>num;
    
    cout<<"Please enter the new base: ";
    cin>>newBase;
    
    if((base == 10) && (newBase ==10)) {
        cout<<num<<" base "<<base<<" is "<<num<<" base "<<newBase<<endl;
    }
    
    else if(base==10) {
        int convertedBase10 = findBase10Rep(num,base);
        string convertedNum = convertNewBase(convertedBase10, newBase);
        print(num, base, convertedNum, newBase);
    }
    
    else {
        string convertedNum = convertNewBase(findBase10Rep(num,base), newBase);
        print(num, base, convertedNum, newBase);
    }
    
    return 0;
}


