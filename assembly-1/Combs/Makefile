combs.out: main.o
	gcc -g -Wall -m32 -o combs.out main.o

main.o: main.c combs.h
	gcc -g -Wall -m32 -c -o main.o main.c

clean:
	rm *.o *.out
