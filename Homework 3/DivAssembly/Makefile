sfile = divAssembly.s
exe = divAssembly.out

divAssembly.out: divAssembly.o
	ld -melf_i386 -o $(exe) divAssembly.o
divAssembly.o: $(sfile)
	as --32 --gstabs -o divAssembly.o $(sfile)

clean:
	rm -fr $(exe) divAssembly.o
