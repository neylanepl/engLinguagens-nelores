mac: lex byacc gcc_mac run_mac

linux: lex yacc gcc_linux run_linux

lex:
	flex lex.l

byacc:
	byacc -d -v parser.y

yacc:
	yacc parser.y -d -v

gcc_mac: lex byacc
	gcc lex.yy.c y.tab.c -o a.out

gcc_linux: lex yacc
	gcc lex.yy.c y.tab.c -o a.out

run_mac: gcc_mac 
	./a.out < teste.txt

run_linux: gcc_linux
	./a.out < teste.txt

clean:
	rm -f lex.yy.c y.tab.c y.tab.h a.out y.output
