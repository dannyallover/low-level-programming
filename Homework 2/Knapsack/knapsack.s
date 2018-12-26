.global knapsack # we want the function to be callable

.equ ws, 4
.text

knapsack:

  prologue:
    push %ebp
    movl %esp, %ebp
    subl $2 * ws, %esp # subtract space for your locals
    push %edi
    push %esi
    push %ebx

  # unsigned int knapsack(int* weights, unsigned int* values, unsigned int num_items,
  #               int capacity, unsigned int cur_value)


  #unsigned int i;
  #unsigned int best_value = cur_value;

  movl $0, i(%ebp)
  movl cur_value(%ebp), %eax
  movl %eax, best_value(%ebp)

  .equ i, (-2*ws)
  .equ best_value, (-1*ws)
  .equ weights, (2*ws)
  .equ values, (3*ws)
  .equ num_items, (4*ws)
  .equ capacity, (5*ws)
  .equ cur_value, (6*ws)

  movl i(%ebp), %eax # i = 0

  for_start:
    # i < num_items
    # i - num_items < 0
    # neg: i - num_items >= 0
    cmpl num_items(%ebp), %eax
    jge for_end

    # if(capacity - weights[i] >= 0 )

    if:
      # capacity - weights[i] >= 0
      # neg: capacity - weights[i] < 0
      movl capacity(%ebp), %ecx
      movl weights(%ebp), %edi
      movl (%edi, %eax, ws), %edi
      cmpl %edi, %ecx
      jl update

    # best_value = max(best_value, knapsack(weights + i + 1, values + i + 1, num_items - i - 1,
    #                capacity - weights[i], cur_value + values[i]));

    # cur_value + values[i]
    movl values(%ebp), %edx
    movl (%edx, %eax, ws), %edx
    addl cur_value(%ebp), %edx
    push %edx

    # capacity - weights[i]
    movl weights(%ebp), %edi
    movl (%edi, %eax, ws), %edi
    movl capacity(%ebp), %edx
    subl %edi, %edx
    push %edx

    # num_items - i - 1
    movl num_items(%ebp), %edx
    subl %eax, %edx
    subl $1, %edx
    push %edx

    # values + i + 1
    movl values(%ebp), %edx
    leal 4(%edx, %eax, 4), %edx
    push %edx

    # weights + i + 1
    movl weights(%ebp), %edx
    leal 4(%edx, %eax, 4), %edx
    push %edx

    movl %eax, i(%ebp) #save i

    call knapsack

    addl $5*ws, %esp # clear args
    push %eax # this is pushing the result of knapsack being called

    movl best_value(%ebp), %edx
    push %edx # pushing best_value for max

    call max
    add $2*ws, %esp

    movl %eax, best_value(%ebp)
    movl i(%ebp), %eax #restore i

    update:
      #i++
      incl %eax
      jmp for_start

  for_end:
    movl best_value(%ebp), %eax

  epilogue:
    pop %edi
    pop %esi
    pop %ebx
    movl %ebp, %esp
    pop %ebp
    ret

max:
  # unsigned int max(unsigned int a, unsigned int b){
  .equ b, 3*ws
  .equ a, 2*ws

  prologue1:
    push %ebp
    movl %esp, %ebp

  # return a > b ? a : b;
  if1:
    movl a(%ebp), %eax
    movl b(%ebp), %ecx
    # a > b
    # a - b > 0
    # a - b <= 0
    cmpl %ecx, %eax
    jle b_is_max

    a_is_max:
      jmp epilogue

    b_is_max:
      movl %ecx, %eax

  epilogue1:
    movl %ebp, %esp
    pop %ebp
    ret
