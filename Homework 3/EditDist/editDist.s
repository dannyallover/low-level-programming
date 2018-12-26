# an assembly program called editDist.s that
# calculates the edit distance between 2 strings.
.global _start
.equ ws, 4

.data
  string1:
    .space 100
  string2:
    .space 100
  word_length:
    .long 10
  string1_length:
    .long 5
  string2_length:
    .long 6
  oldDist:
    .space 400
  curDist:
    .space 400
  leastValue:
    .long 10
  string1_len_plus_one:
    .long 5
  string2_len_plus_one:
    .long 11
  temp:
    .space 400
  dist:
    .long 0

.text
swap:
  # ebx and ecx are free to use
  # esi = oldDist
  # edi = curDist

  #int* temp = *a;
  movl $0, %ebx # i = 0
  for_copy_to_temp:
  cmpl string2_len_plus_one, %ebx
  jge for_copy_to_temp_end

  movl (%esi, %ebx, ws), %ecx
  movl %ecx, temp(, %ebx, ws)

  incl %ebx
  jmp for_copy_to_temp
  for_copy_to_temp_end:

  #*a = *b;
  movl $0, %ebx # i = 0
  for_copy_cur_to_old:
  cmpl string2_len_plus_one, %ebx
  jge for_copy_cur_to_old_end

  movl curDist(, %ebx, ws), %ecx
  movl %ecx, oldDist(, %ebx, ws)

  incl %ebx
  jmp for_copy_cur_to_old
  for_copy_cur_to_old_end:

  #*b = temp
  movl $0, %ebx # i = 0
  for_copy_temp_to_cur:
  cmpl string2_len_plus_one, %ebx
  jge for_copy_temp_to_cur_end

  movl temp(, %ebx, ws), %ecx
  movl %ecx, curDist(, %ebx, ws)

  incl %ebx
  jmp for_copy_temp_to_cur
  for_copy_temp_to_cur_end:

  ret

strlen:
  # word is in eax
  # ebx = i

  movl $1, %ebx
  while:
  #conidition
  cmpb $0, (%eax) # string1[i] != '\0'
  jz end_while

  #body
  incl %ebx #++i
  addl $1, %eax
  jmp while

  end_while:
  dec %ebx
  movl %ebx, word_length
  ret

min:
  # val1 is in ebx
  # val2 is in ecx

  # if(val1 > val2)
  if:
    cmpl %ecx, %ebx
    jge else

    movl %ebx, leastValue
    ret

  else:
    movl %ecx, leastValue
    ret

editDist:

  #int string1_len = strlen(string1);
  movl $string1, %eax
  call strlen
  movl word_length, %ecx
  movl %ecx, string1_length

  #int string2_len = strlen(string2);
  movl $string2, %eax
  call strlen
  movl word_length, %ecx
  movl %ecx, string2_length

  # int* oldDist = (int*)malloc((string2_len + 1) * sizeof(int));
  # variable declared and space allocated above in the data section
  # int* curDist = (int*)malloc((string2_len + 1) * sizeof(int));
  # variable declared and space allocated above in the data section

  movl $0, %eax # i = 0
  movl string2_length, %ebx #ebx = string2_len
  addl $1, %ebx #ebx = string2_len + 1

  for_start:
    # i < string2_len + 1
    # i - string2_len + 1 < 0
    # i - string2_len + 1 >= 0
    cmpl %ebx, %eax
    jge for_end

    #oldDist[i] = i;
    movl %eax, oldDist(, %eax, ws)
    #curDist[i] = i;
    movl %eax, curDist(, %eax, ws)

    incl %eax
    jmp for_start

  for_end:
    movl $1, %eax # i = 1
    movl string1_length, %ecx #ecx = string1_len
    addl $1, %ecx #ecx = string1_len + 1
    movl $1, %edx # j = 1

  for_start1:
    # i < string1_len + 1
    # i - string1_len + 1 < 0
    # i - string1_len + 1 >= 0
    cmpl %ecx, %eax
    jge for_end1

    # curDist[0] = i;
    movl %eax, curDist

    for_start2:
      # j < string2_len + 1
      # j - string2_len + 1 < 0
      # j - string2_len + 1 >= 0
      cmpl %ebx, %edx
      jge for_end2

      # free up registers
      movl %ebx, string2_len_plus_one
      movl %ecx, string1_len_plus_one

      if1:
        #if(string1[i-1] == string2[j-1])
        movb string1 - 1(, %eax, ), %bl
        movb string2 - 1(, %edx, ), %cl
        cmpb %cl, %bl
        jne else1

        # curDist[j] = oldDist[j - 1];
        movl oldDist - 4(, %edx, ws), %ecx
        movl %ecx, curDist(, %edx, ws)
        jmp restore

      else1:
        # curDist[j] = min(min(oldDist[j], curDist[j-1]), oldDist[j-1]) + 1;
        movl oldDist(, %edx, ws), %ebx # oldDist[j]
        movl curDist - 4(, %edx, ws), %ecx # curDist[j-1]
        call min

        movl leastValue, %ebx # min(oldDist[j], curDist[j-1])
        movl oldDist - 4(, %edx, ws), %ecx # oldDist[j-1]
        call min

        movl leastValue, %ebx # min(min(oldDist[j], curDist[j-1]), oldDist[j-1])
        addl $1, %ebx # min(min(oldDist[j], curDist[j-1]), oldDist[j-1]) + 1
        movl %ebx, curDist(, %edx, ws) # curDist[j] = above


      restore:
        movl string2_len_plus_one, %ebx
        movl string1_len_plus_one, %ecx

        incl %edx
        jmp for_start2

    for_end2:
      # set j = 1 again
      movl $1, %edx
      # free up registers
      movl %ebx, string2_len_plus_one
      movl %ecx, string1_len_plus_one
      #swap(&oldDist, &curDist);
      movl $oldDist, %esi
      movl $curDist, %edi
      call swap
      # restore
      movl string2_len_plus_one, %ebx
      movl string1_len_plus_one, %ecx

      incl %eax
      jmp for_start1

  for_end1:
    movl string2_length, %eax
    movl oldDist(, %eax, ws), %ebx
    movl %ebx, %eax
    movl %eax, dist
    ret


_start:
  call editDist

done:
  nop
