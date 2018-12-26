.global matMult # we want the function to be callable outside the file
.equ ws, 4

.text
matMult:
  prologue:
    push %ebp
    movl %esp, %ebp
    subl $4 * ws, %esp
    push %edi
    push %esi
    push %ebx

    .equ num_cols_b, 7*ws
    .equ num_rows_b, 6*ws
    .equ b, 5*ws
    .equ num_cols_a, 4*ws
    .equ num_rows_a, 3*ws
    .equ a, 2*ws
    #ret address
    #ebp: old ebp
    .equ i, -1*ws
    .equ j, -2*ws
    .equ k, -3*ws
    .equ c, -4*ws
    .equ sum, -5*ws

    #eax will be i
    #ecx will be j
    #esi will be k
    #edi will be C
    #ebx will be A
    #edx will be B

    #int **c = (int**)malloc(num_rows_a * sizeof(int*));

    movl num_rows_a(%ebp), %eax # eax = num_rows_a
		shll $2, %eax # eax = num_rows_a * sizeof(int*)
		push %eax
		call malloc
		addl $1*ws, %esp #clear args
		movl %eax, c(%ebp) #c = (int**)malloc(num_rows_a * sizeof(int*));

    #for(i = 0; i < num_rows_a; i++){
    movl $0, %eax # i = 0

    row_for_start:
      cmpl num_rows_a(%ebp), %eax # i - num_rows_a >= 0
      jge row_for_end


      movl num_cols_b(%ebp), %edx #edx = num_cols_b
      shll $2, %edx #edx = num_cols_b * sizeof(int)
      push %edx
      movl %eax, i(%ebp) #save i, which is in eax
      call malloc
      addl $1*ws, %esp # clear args

      movl %eax, %edx
      movl i(%ebp), %eax # eax = i
      movl c(%ebp), %ecx # ecx = c
      movl %edx, (%ecx, %eax, ws) #c[i]=(int*)malloc(num_cols_b*sizeof(int));

      movl $0, %ecx # j = 0



      column_for_start:
        movl $0, sum(%ebp)
        cmpl num_cols_b(%ebp), %ecx
        jge column_for_end

        movl c(%ebp), %edi #edi = c
        movl (%edi, %eax, ws), %edi #edi = c[i]
        movl (%edi, %ecx, ws), %edi #edi = c[i][j]
        movl $0, %edi

        movl $0, %esi

        #for(int k = 0; k < num_cols_a; k++)
        movl $0, %esi # k = 0




        multiplication_for_start:
          cmpl num_cols_a(%ebp), %esi # k - num_cols_a >= 0
          jge multiplication_for_end

          #c[i][j] += a[i][k] * b[k][j];
          #*(*(c + i) + j) = *(*(a + i) + k) * *(*(b + k) + j)

          #*(*(a + i) + k)
          movl a(%ebp), %ebx #ebx = a
          movl (%ebx, %eax, ws), %ebx #ebx = a[i]
          movl (%ebx, %esi, ws), %ebx #ebx = a[i][k]

          #*(*(b + k) + j)
          movl b(%ebp), %edi #edi = b
          movl (%edi, %esi, ws), %edi #edi = b[k]
          movl (%edi, %ecx, ws), %edi #edi = b[k][j]


          #*(*(a + i) + k) * *(*(b + k) + j)
          movl %eax, i(%ebp) # save i
          movl %ecx, j(%ebp) # save j
          movl %esi, k(%ebp) # save k
          movl %edi, %eax # move b[k][j] into eax

          mull %ebx #edx:eax = %ebx * %eax
          movl %eax, %ebx

          movl i(%ebp), %eax # restore i
          movl c(%ebp), %edi # restore c

          movl (%edi, %eax, ws), %edi # edi = c[i][j]
          addl %ebx, sum(%ebp) # saving sum = a[i][k] + b[k][j]
          movl sum(%ebp), %ebx # sum = a[i][k] + b[k][j]
          leal (%edi, %ecx, ws), %edi
          movl %ebx, (%edi) # c[i][j] = a[i][k] + b[k][j]
          incl %esi #k++


          jmp multiplication_for_start
          multiplication_for_end:

        incl %ecx #j++
        jmp column_for_start
        column_for_end:

      incl %eax #i++
      jmp row_for_start

    row_for_end:
      movl c(%ebp), %eax

    epilogue:
      pop %edi
      pop %esi
      pop %ebx
      movl %ebp, %esp
      pop %ebp
      ret
