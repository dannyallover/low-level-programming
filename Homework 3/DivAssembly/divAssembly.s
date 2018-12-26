# Translate the C program you wrote to do division in constant time into an assembly program called
# divAssembly.s.

.global _start
.data # start of data
dividend:
      .long 123423
divisor:
      .long 234

.text # start of code
_start:

ifCornerCase:
  movl dividend, %eax
  movl divisor, %ebx
  cmpl %eax, %ebx
  ja result
  jmp continue

# body
result:
  movl $0, %eax
  movl dividend, %edx
  jmp done

# if it doesn't go in
continue:
  movl $0, %ebx # this is pos1
  movl $0, %ecx # this is pos2
  movl $0, %esi # this is i
  movl $0x1, %eax
  movl $0x1, %edi

for_start:
  # check for condition
  # i < 32
  # i - 32 < 0
  # i - 32 >= 0
  cmpl $32, %esi
  jge for_end

# body
if1:
  # condition
  # if((dividend >> i & 0x1) != 0)
  movl dividend, %edx
  andl %eax, %edx
  cmpl $1, %edx
  jl if2

  # body
  movl %esi, %ebx

if2:
  #condition
  # if((divisor >> i & 0x1) != 0)
  movl divisor, %edx
  andl %edi, %edx
  cmpl $1, %edx
  jl update

  #body
  movl %esi, %ecx

update:
  shll $1, %eax
  shll $1, %edi
  incl %esi
  jmp for_start

for_end:
  addl $1, %ebx # so they equal true amount
  addl $1, %ecx # so they equal true amount
  movl $0, %eax # quotient
  subl %ecx, %ebx # i = pos1 - pos2
  movl $0, %edx # remainder
  movl $0, %ecx # cl is used
  movl dividend, %esi # dividend2
  movl $0, %edi # divisor

for_start2:
  # check for condition
  cmpl $0, %ebx
  jl done

if:
  # condition
  # if((divisor << i) <= dividend2) {
  movl divisor, %edi # divisor
  movb %bl, %cl
  shll %cl, %edi # divisor << i
  cmpl %edi, %esi # divisor <= dividend2
  jb update2

  # body
  # dividend2 -= (divisor << i);
  subl %edi, %esi
  # quotient += (1 << i);
  movl $1, %edi
  shll %cl, %edi
  addl %edi, %eax

  update2:
  # --i
  decl %ebx
  movl %esi, %edx
  jmp for_start2

done:
  movl %eax, %eax
