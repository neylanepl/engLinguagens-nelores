mac1: lex byacc gcc_mac run_mac

mac2: lex byacc gcc_mac run_mac2

mac3: lex byacc gcc_mac run_mac3

macQuickSort: lex byacc gcc_mac run_macQuickSort

macComandos: lex byacc gcc_mac run_macComandos


linux1: lex yacc gcc_linux run_linux

linux2: lex yacc gcc_linux run_linux2

linux3: lex yacc gcc_linux run_linux3

linuxQuickSort: lex yacc gcc_linux run_linuxQuickSort

linuxComandos: lex yacc gcc_linux run_linuxComandos

lex:
	flex lex.l

byacc:
	byacc -d -v parser.y

yacc:
	yacc parser.y -d -v

conflicts:
	yacc parser.y -d -v -Wcounterexamples

gcc_mac: lex byacc
	gcc lex.yy.c y.tab.c -o a.out

gcc_linux: lex yacc
	gcc lex.yy.c y.tab.c -o a.out

run_mac: gcc_mac 
	./a.out < teste1.txt

run_mac2: gcc_mac 
	./a.out < teste2.txt

run_mac3: gcc_mac 
	./a.out < teste3.txt

run_macQuickSort: gcc_mac 
	./a.out < quicksort.txt

run_macComandos: gcc_mac 
	./a.out < comandos.txt

run_linux: gcc_linux
	./a.out < teste1.txt

run_linux2: gcc_linux
	./a.out < teste2.txt

run_linux3: gcc_linux
	./a.out < teste3.txt

run_linuxQuickSort: gcc_linux
	./a.out < quicksort.txt

run_linuxComandos: gcc_linux
	./a.out < comandos.txt

clean:
	rm -f lex.yy.c y.tab.c y.tab.h a.out y.output
