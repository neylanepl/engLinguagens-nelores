# engLinguagens-nelores
Nelores é uma linguagem desenvolvida pensando em valorizar a legibilidade, o desenvolvimento web e o tratamento eficiente de erros, combinando aspectos das linguagens Java, JavaScript, C e Python para atender às necessidades específicas do desenvolvimento web moderno.

## Como executar
Abaixo está as instruções para executar o analisador léxico e o analisador sintático:

1. Tenha o [Flex](https://github.com/westes/flex), o YACC e o [GCC](https://gcc.gnu.org/) instalados em seu sistema.

2. Faça o download dos arquivos `lexer.l` e `parser.y`, que contém as regras para o analisador léxico e analisador sintático, respectivamente.

3. No terminal, navegue até o diretório onde os arquivos `lexer.l` e `parser.y` estão localizados.

4. Execute os seguintes comandos:

Abaixo estão os comandos que devem ser executados:

```
#Gera o arquivo “lex.yy.c” a partir das regras definidas no arquivo “lexer.l”
flex lexer.l
yacc parser.y -d -v
#Compila o arquivo `lex.yy.c` e gera o executável “a.out”.
gcc lex.yy.c y.tab.c -o a.out
#Executa o analisador léxico, fornecendo como entrada o arquivo de teste “arquivoTeste.nel” que disponibilizamos para a análise.
./a.out < arquivoTeste.nel
```

Após a execução, caso tenha erros o analisador sintático irá imprimir no terminal.
Caso o analisador sintático não encontre erros, o programa é encerrado.

## Executando utilizando o makefile

Para facilitar a execução deixaremos aqui uma opção alternativa para utilizar o makefile.

O seguinte comando a baixo compila o compilador a partir dos arquivos Lex e Yacc, executar o compilador com um arquivo de entrada especificado gerando o teste.c e executar o código C gerado:

````
make prob=<arquivoProblema.nel> all
````

Caso não prefira rodar o código C gerado, utilize o seguinte comenado:

````
make prob=<arquivoProblema.nel> run
````

Para limpar todos os arquivos gerados:

````
make clean
````


