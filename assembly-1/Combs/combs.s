.global get_combs # we want the function to be callable

.equ ws, 4
.text

helper:
  prologue1:
    push %ebp
    movl %esp, %ebp
    push %edi
    push %esi
    push %ebx

  # int* helper(int* items, int* one_comb, int k, int len, int actual_k, int* curRow, int** combs) {
  .equ items, (2*ws)
  .equ one_comb, (3*ws)
  .equ k, (4*ws)
  .equ len, (5*ws)
  .equ actual_k, (6*ws)
  .equ curRow, (7*ws)
  .equ combs, (8*ws)

  # if k == 0
  if_1:
    cmpl $0, k(%ebp)
    jnz else_if_1

    movl $0, %ecx # ecx is i
    for_1:
      # i < actual_k
      # i - actual_k < 0
      # i - actual_k >= 0
      cmpl actual_k(%ebp), %ecx
      jge end_for_1

      movl curRow(%ebp), %eax
      movl (%eax), %eax
      movl combs(%ebp), %ebx
      movl (%ebx, %eax, ws), %eax

      movl one_comb(%ebp), %edx # one_comb[i];
      movl (%edx, %ecx, 4), %edx
      movl %edx, (%eax, %ecx, ws) # combs[*curRow][i] = one_comb[i];


    update_for_1:
      incl %ecx # i++
      jmp for_1

  end_for_1:
    movl curRow(%ebp), %eax
    incl (%eax) # (*curRow)++;
    jmp epilogue

  # else if(k > len) {
  # return one_comb;
  # }

  else_if_1:
    movl k(%ebp), %eax
    # k > len
    # k - len > 0
    # k - len <= 0
    cmpl len(%ebp), %eax
    jle if_3
    jmp epilogue

  if_3:
    # k > 0
    # k - 0 > 0
    # k - 0 <= 0
    movl $0, %eax
    cmpl %eax, k(%ebp)
    jle epilogue

    continue:
    movl $0, %ecx # ecx is i
    for_2:
      # i < len
      # i - len < 0
      # i - len >= 0
      cmpl len(%ebp), %ecx
      jge epilogue

      # actual_k - k
      movl actual_k(%ebp), %eax
      subl k(%ebp), %eax
      movl one_comb(%ebp), %edx
      # items[i]
      movl items(%ebp), %edi
      movl (%edi, %ecx, ws), %edi
      movl %edi, (%edx, %eax, ws) # one_comb[actual_k - k] = items[i];

      # helper(items + i + 1, one_comb, k - 1, len - i - 1, actual_k, curRow, combs)

      # combs
      movl combs(%ebp), %edx
      push %edx

      # curRow
      movl curRow(%ebp), %edx
      push %edx

      # actual_k
      movl actual_k(%ebp), %edx
      push %edx

      # len - i - 1
      movl len(%ebp), %edx
      subl %ecx, %edx
      subl $1, %edx
      push %edx

      # k - 1
      movl k(%ebp), %edx
      subl $1, %edx
      push %edx

      # one_comb
      movl one_comb(%ebp), %edx
      push %edx

      # items + i + 1
      movl items(%ebp), %edx
      leal 1*ws(%edx, %ecx, ws), %edx
      push %edx

      movl %ecx, %edi

      call helper

      movl %edi, %ecx

      addl $7*ws, %esp # clear args

    update_for_2:
      incl %ecx # i++
      jmp for_2

    epilogue:
      pop %ebx
      pop %esi
      pop %edi
      movl %ebp, %esp
      pop %ebp
      ret

      get_combs:

        prologue2:
          push %ebp
          movl %esp, %ebp
          subl $4*ws, %esp
          push %edi
          push %esi
          push %ebx

        # int** get_combs(int* items, int k, int len) {
        .equ curRow, (-4*ws)
        .equ one_comb, (-3*ws)
        .equ combs, (-2*ws)
        .equ num_of_combs, (-1*ws)
        .equ items, (2*ws)
        .equ k, (3*ws)
        .equ len, (4*ws)

        # int num_of_combs = num_combs(len, k);
        movl k(%ebp), %ecx
        push %ecx

        movl len(%ebp), %ecx
        push %ecx

        call num_combs
        movl %eax, num_of_combs(%ebp)
        addl $2*ws, %esp # clear args

        # int **combs = (int**)malloc(sizeof(int*) * num_of_combs);
        movl num_of_combs(%ebp), %ecx
        shll $2, %ecx
        push %ecx
        call malloc
        movl %eax, combs(%ebp)

        # i = 0
        movl $0, %ebx
        for_3:
        # i < num_of_combs
        # i - num_of_combs < 0
        # i - num_of_combs >= 0
        cmpl num_of_combs(%ebp), %ebx
        jge end_for_3

        # combs[i] = (int*)malloc(sizeof(int) * k);
        movl k(%ebp), %edx
        shll $2, %edx
        push %edx
        call malloc # (int*)malloc(sizeof(int) * k);
        addl $1*ws, %esp # clear args

        movl combs(%ebp), %edx
        movl %eax, (%edx, %ebx, ws) # combs[i] = (int*)malloc(sizeof(int) * k);

        update:
          incl %ebx
          jmp for_3

        end_for_3:

        # int *one_comb = one_comb = (int*)malloc(sizeof(int) * k);
        movl k(%ebp), %edx
        shll $2, %edx
        push %edx
        call malloc # (int*)malloc(sizeof(int) * k);
        addl $1*ws, %esp # clear args
        movl %eax, one_comb(%ebp)

        # int *curRow = (int*)malloc(sizeof(int));
        movl $4, %edx
        push %edx
        call malloc # (int*)malloc(sizeof(int) * k);
        addl $1*ws, %esp # clear args
        movl %eax, curRow(%ebp)
        movl curRow(%ebp), %eax
        movl $0, (%eax)

        # helper(items, one_comb, k, len, k, curRow, combs);
        movl combs(%ebp), %edx
        push %edx

        movl curRow(%ebp), %edx
        push %edx

        movl k(%ebp), %edx
        push %edx

        movl len(%ebp), %edx
        push %edx

        movl k(%ebp), %edx
        push %edx

        movl one_comb(%ebp), %edx
        push %edx

        movl items(%ebp), %edx
        push %edx

        call helper

        addl $7*ws, %esp

        movl combs(%ebp), %eax

        epilogue2:
        pop %ebx
        pop %esi
        pop %edi
        movl %ebp, %esp
        pop %ebp
        ret
