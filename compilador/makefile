all: compilador

compilador: lex.yy.c y.tab.c 
	gcc lex.yy.c y.tab.c ./lib/record.c -o compiler

lex.yy.c: lex.l
	lex lex.l

y.tab.c: parser.y  
	yacc parser.y -d -v -Wcounterexamples

clean:
	rm -rf lex.yy.c y.tab.* compiler output.txt y.output teste.c

compile:
	./compiler declvar.txt teste.c

generatec:
	gcc -o test teste.c
	./test

recompile: clean all compile
	