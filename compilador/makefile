prob ?=

compiler: lex.yy.c y.tab.c 
	gcc lex.yy.c y.tab.c ./lib/record.c ./lib/semantics.c ./lib/hashTable.c ./lib/stack.c -o compiler

lex.yy.c: lex.l
	flex lex.l

y.tab.c: parser.y  
	yacc parser.y -d -v

clean:
	rm -rf lex.yy.c y.tab.* compiler output.txt y.output teste.c

run_example: compiler
	./compiler prob teste.c -t

generatec: run_example
	gcc -o test teste.c -lm
	./test

recompile: clean compiler run_example generatec