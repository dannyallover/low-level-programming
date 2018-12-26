#include "MyFloat.h"

MyFloat::MyFloat(){
  sign = 0;
  exponent = 0;
  mantissa = 0;
}

MyFloat::MyFloat(float f){
  unpackFloat(f);
}

MyFloat::MyFloat(const MyFloat & rhs){
	sign = rhs.sign;
	exponent = rhs.exponent;
	mantissa = rhs.mantissa;
}


ostream& operator<<(std::ostream &strm, const MyFloat &f){
	//this function is complete. No need to modify it.
	strm << f.packFloat();
	return strm;
}

MyFloat MyFloat::operator+(const MyFloat& rhs) const{
  MyFloat mf;
  unsigned int mant1 = 0;
  unsigned int mant2 = 0;
  int difference = 0;
  if(this->exponent == rhs.exponent && this->mantissa == rhs.mantissa) {
    if(this->sign != rhs.sign) {
      mf.sign = 0;
      mf.exponent = 0;
      mf.mantissa = 0;
      return mf;
    }
    else {
      mf.sign = 0;
      mf.exponent = this->exponent + 1;
      // .101 * 2^1 = 1.25 + 1.25 = 2.50
      // .101 * 2^2 = 2.50
      mf.mantissa = rhs.mantissa;
      return mf;
    }
  }
  if(this->sign == 0 && rhs.sign == 0) {
    if(this->exponent > rhs.exponent) {
      difference = this->exponent - rhs.exponent;
      mf.sign = this->sign;
      mf.exponent = this->exponent;
      mant1 = rhs.mantissa;
      mant1 = mant1 >> 1;
      difference--;
      mant1 |= 0x400000;
      mant1 = mant1 >> difference;
      mant2 = this->mantissa + mant1;
      if((mant2 & 0x800000) > 1) {
        mant2 = mant2 & 0x7FFFFF;
        mant2 = mant2 >> 1;
        mf.exponent = this->exponent + 1;
      }
      mf.mantissa = mant2;
      // .10110 * 2^4 + .001 * 2^2
      // .00001 * 2^4
      // .10111 * 2^4
      // 11 + .5 = 11.5
      // .11110 * 2^4 + .011 * 2^2
      // .00011 * 2^4
      // 1.00001 * 2^4
      // 1000.01
      // 15 + 1.5 = 16.5
      // 10000.1
    }
    else if(rhs.exponent > this->exponent){
      difference = rhs.exponent - this->exponent;
      mf.sign = rhs.sign;
      mf.exponent = rhs.exponent;
      mant1 = this->mantissa;
      mant1 = mant1 >> 1;
      difference--;
      mant1 |= 0x400000;
      mant1 = mant1 >> difference;
      mant2 = rhs.mantissa + mant1;
      if((mant2 & 0x800000) > 1) {
        mant2 = mant2 & 0x7FFFFF;
        mant2 = mant2 >> 1;
        mf.exponent = rhs.exponent + 1;
      }
      mf.mantissa = mant2;
    }
    else {
      ///////
      mf.sign = this->sign;
      mant1 = this->mantissa >> 1;
      mant1 |= 0x400000;
      mant2 = rhs.mantissa >> 1;
      mant2 |= 0x400000;
      mant1 = mant1 + mant2;
      mf.exponent = this->exponent + 1;
      mf.mantissa = mant1;
    }
  }
  else if(this->sign == 1 && rhs.sign == 1) {
    if(this->exponent > rhs.exponent) {
      difference = this->exponent - rhs.exponent;
      mf.sign = this->sign;
      mf.exponent = this->exponent;
      mant1 = rhs.mantissa >> 1;
      difference--;
      mant1 |= 0x400000;
      mant1 = mant1 >> difference;
      mant2 = this->mantissa + mant1;
      if((mant2 & 0x800000) > 1) {
        mant2 = mant2 & 0x7FFFFF;
        mant2 = mant2 >> (this->exponent - rhs.exponent);
        mf.exponent = this->exponent + 1;
      }
      else {
        mf.exponent = this->exponent;
      }
      mf.mantissa = mant2;
    }
    else if(rhs.exponent > this->exponent){
      difference = rhs.exponent - this->exponent;
      mf.sign = rhs.sign;
      mf.exponent = rhs.exponent;
      mant1 = this->mantissa >> 1;
      difference--;
      mant1 |= 0x400000;
      mant1 = mant1 >> difference;
      mant2 = rhs.mantissa + mant1;
      if((mant2 & 0x800000) > 1) {
        mant2 = mant2 & 0x7FFFFF;
        mant2 = mant2 >> (rhs.exponent - this->exponent);
        mf.exponent = rhs.exponent + 1;
      }
      else {
        mf.exponent = rhs.exponent;
      }
      mf.mantissa = mant2;
    }
    else {
      mf.sign = this->sign;
      mant1 = this->mantissa >> 1;
      mant1 |= 0x400000;
      mant2 = rhs.mantissa >> 1;
      mant2 |= 0x400000;
      mant1 = mant1 + mant2;
      mf.exponent = this->exponent + 1;
      mf.mantissa = mant1;
    }
  }
  else if(this->sign == 0 && rhs.sign == 1) {
    // .1011 * 2^2 - .101 * 2^1
    // = 10.11 - 1.01
    // = 4.75 - 1.25
    // = 3.50
    // .111 & 2^2
    if(this->exponent > rhs.exponent){
      cout << "goes in here 1" << endl;
      mf.sign = 0;
      difference = this->exponent - rhs.exponent;
      mant1 = this->mantissa >> 1;
      mant1 |= 0x400000;
      mant2 = rhs.mantissa >> 1;
      mant2 |= 0x400000;
      // deal with loss of precision (1's falling off)
      bool x = true;
      for(int i = 0; i < difference; i++) {
        if((((mant2 >> 1) & 0x1) == 1) && x) {
          mant1 = mant1 - 0x1;
          x = false;
        }
        mant2 = mant2 >> 1; // adjust mant with smaller exp
      }
      mant1 = mant1 - mant2;
      // observing mantissa after subtraction
      cout << endl;
      for(int i = 0; i < 23; i++) {
        if(((mant1 >> i) & 0x1) == 1)
          cout << "1" << endl;
        else
          cout << "0" << endl;
      }
      // deal with normalization?
      int shift = 0;
      for(int i = 0; i < 32; i++) {
        if(((mant1 << i) & 0x800000) > 1) {
          shift = i;
          break;
        }
      }
      int preserveBits = 0;
      for(int i = 0; i < shift; i++) {
        if(((mant1 >> i) & 0x1) == 1)
          preserveBits++;
      }
      mant1 = mant1 << shift;
      mant1 = mant1 & 0x7FFFFF;
      mant1 += preserveBits;
      mf.exponent = this->exponent - shift + 1;
      mf.mantissa = mant1;
    }
    else if(rhs.exponent > this->exponent) {
      cout << "goes in here 2" << endl;
      mf.sign = 1;
      difference = rhs.exponent - this->exponent;
      mant1 = rhs.mantissa >> 1;
      mant1 |= 0x400000;
      mant2 = this->mantissa;
      mant2 |= 0x400000;
      // deal with loss of precision (1's falling off)
      bool x = true;
      for(int i = 0; i < difference; i++) {
        if((((mant2 >> 1) & 0x1) == 1) && x) {
          cout << "yes" << endl;
          mant1 = mant1 - 0x1;
          x = false;
        }
        cout << "yes2" << endl;
        mant2 = mant2 >> 1; // adjust mant with smaller exp
      }
      mant1 = mant1 - mant2;
      // observing mantissa after subtraction
      cout << endl;
      for(int i = 0; i < 23; i++) {
        if(((mant1 >> i) & 0x1) == 1)
          cout << "1" << endl;
        else
          cout << "0" << endl;
      }
      // deal with normalization?
      int shift = 0;
      for(int i = 0; i < 32; i++) {
        if(((mant1 << i) & 0x800000) > 1) {
          shift = i;
          break;
        }
      }
      int preserveBits = 0;
      for(int i = 0; i < shift; i++) {
        if(((mant1 >> i) & 0x1) == 1)
          preserveBits++;
      }
      mant1 = mant1 << shift;
      mant1 = mant1 & 0x7FFFFF;
      mant1 += preserveBits;
      mf.exponent = rhs.exponent - shift + 1;
      mf.mantissa = mant1;
    }
    else {
      if(this->mantissa > rhs.mantissa) {
        mf.sign = 0;
        mant1 = this->mantissa >> 1;
        mant1 |= 0x400000;
        mant2 = rhs.mantissa >> 1;
        mant2 |= 0x400000;
        mant1 = mant1 - mant2;
        int shift = 0;
        for(int i = 0; i < 32; i++) {
          if(((mant1 << i) & 0x800000) > 1) {
            shift = i;
            break;
          }
        }
        mant1 = mant1 << shift;
        mant1 = mant1 & 0x7FFFFF;
        mf.exponent = this->exponent - shift + 1;
        mf.mantissa = mant1;
      }
      else {
        mf.sign = 1;
        mant1 = rhs.mantissa >> 1;
        mant1 |= 0x400000;
        mant2 = this->mantissa >> 1;
        mant2 |= 0x400000;
        mant1 = mant1 - mant2;
        int shift = 0;
        for(int i = 0; i < 32; i++) {
          if(((mant1 << i) & 0x800000) > 1) {
            shift = i;
            break;
          }
        }
        mant1 = mant1 << shift;
        mant1 = mant1 & 0x7FFFFF;
        mf.exponent = rhs.exponent - shift + 1;
        mf.mantissa = mant1;
      }
    }
  }
  else if(this->sign == 1 && rhs.sign == 0) {
    MyFloat mf2;
    mf2.sign = 0;
    mf2.exponent = this->exponent;
    mf2.mantissa = this->mantissa;
    mf = rhs.operator-(mf2);
  }
	return mf;
}

MyFloat MyFloat::operator-(const MyFloat& rhs) const{
  MyFloat mf;
  if(this->sign == 1 && rhs.sign == 1) {
    MyFloat mf2;
    mf2.sign = 0;
    mf2.exponent = rhs.exponent;
    mf2.mantissa = rhs.mantissa;
    mf = this->operator+(mf2);
    return mf;
  }
  else if(this->sign == 1 && rhs.sign == 0) {
    MyFloat mf2;
    mf2.sign = 1;
    mf2.exponent = rhs.exponent;
    mf2.mantissa = rhs.mantissa;
    mf = this->operator+(mf2);
    return mf;
  }
  else if(this->sign == 0 && rhs.sign == 1) {
    MyFloat mf2;
    mf2.sign = 0;
    mf2.exponent = rhs.exponent;
    mf2.mantissa = rhs.mantissa;
    mf = this->operator+(mf2);
    return mf;
  }
  else if(this->sign == 0 && rhs.sign == 0) {
    MyFloat mf2;
    mf2.sign = 1;
    mf2.mantissa = rhs.mantissa;
    mf2.exponent = rhs.exponent;
    mf = this->operator+(mf2);
    return mf;
  }
	return mf; //you don't have to return *this. it's just here right now so it will compile
}

bool MyFloat::operator==(const float rhs) const{
  MyFloat mf(rhs);
  if(this->sign == mf.sign && this->exponent == mf.exponent && this->mantissa == mf.mantissa) {
    return true;
  }
	return false; //this is just a stub so your code will compile
}


void MyFloat::unpackFloat(float f) {
	//this function must be written in inline assembly
	//extracts the fields of f into sign, exponent, and mantissa
  __asm__(
    "movl %%ebx, %%edx;"
    "shrl $31, %%edx;"
    "movl %%edx, %%eax;"
    "movl %%ebx, %%edx;"
    "shrl $23, %%edx;"
    "andl $0xFF, %%edx;"
    "movl %%edx, %%ecx;"
    "movl %%ebx, %%edx;"
    "andl $0x7FFFFF, %%edx":
    "=a" (this->sign), "=c" (this->exponent), "=d" (this->mantissa):
    "b" (f):
    "cc"
  );
}//unpackFloat

float MyFloat::packFloat() const{
	//this function must be written in inline assembly
  //returns the floating point number represented by this
  float f = 0;
  __asm__(
    "shll $31, %%eax;"
    "shll $23, %%ecx;"
    "orl %%eax, %%ebx;"
    "orl %%ecx, %%ebx;"
    "orl %%edx, %%ebx":
    "+b" (f):
    "a" (this->sign), "c" (this->exponent), "d" (this->mantissa):
    "cc"
  );
  return f;
}//packFloat
//
