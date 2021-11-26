# An assembly program called 64bitAdd.s that adds two 64 bit numbers together.

.global _start

.data
num1:
  .long -1
  .long -1
num2:
  .long -1
  .long -1

  .text
  _start:
    movl $num1, %ebx
    movl $num2, %ecx
    addl (%ebx), %edx
    addl (%ecx), %edx
    addl $4, %ebx
    addl $4, %ecx
    addl (%ebx), %eax
    addl (%ecx), %eax
    jc carry
    jmp done

  carry:
  addl $1, %edx

 done:
    movl %eax, %eax
