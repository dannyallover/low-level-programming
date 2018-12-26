// C program called div.c that implements division on two unsigned integers.
// You cannot use division in your solution
// Arguments should be accepted from the command line: the first argument is the dividend and the second argument is divisor.
// Your program should display the quotient and remainder after doing the division
// Your program must complete in O(1) (constant) time

// note: to name your executable do gcc div.c -o file_name.out

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
  unsigned int dividend = atoi(argv[argc - 2]);
  unsigned int divisor = atoi(argv[argc - 1]);

  if(divisor > dividend) {
    printf("%u / %u = 0 R %u\n", dividend, divisor, dividend);
    return 0;
  }

  int pos1 = 0;
  int pos2 = 0;
  // finds position of most significant bit in the dividend
  for(int i = 0; i < 32; i++) {
    if((dividend >> i & 0x1) != 0) {
      pos1 = i;
    }
    if((divisor >> i & 0x1) != 0) {
      pos2 = i;
    }
  }

  unsigned int dividend2 = dividend;
  unsigned int quotient = 0;
  unsigned int rem = 0;
  for(int i = pos1 - pos2; i >= 0; i--) {
    if((divisor << i) <= dividend2) {
      quotient += (1 << i);
      dividend2 -= (divisor << i);
    }

    rem = dividend2;
  }

  printf("%u / %u = %u R %u\n", dividend, divisor, quotient, rem);

}
