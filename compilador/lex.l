%{
  #include "y.tab.h"
  #include <stdio.h>
  
  extern int yyerror(char *msg);
%}

%%

[ \t\r\n]                 ;
"main"              {return(MAIN);}
"void"              {return(VOID);}
"int"               {yylval.sValue = strdup("int"); 
                    return TYPE;}
"float"             {yylval.sValue = strdup("float"); 
                    return TYPE;}
"const"             {return(CONST);}
"final"             {return(FINAL);}
"bool"              {yylval.sValue = strdup("bool"); 
                    return TYPE;}
"string"            {yylval.sValue = strdup("string"); 
                    return TYPE;}
"exception"         {return(EXCEPTION);}
"throws"            {return(THROWS);}
"true"              {return(TRUE);}
"false"             {return(FALSE);}
"try"               {return(TRY);}
"catch"             {return(CATCH);}
"finally"           {return(FINALLY);}
"function"          {return(FUNCTION);}
"while"             {return(WHILE);}
"for"               {return(FOR);}
"switch"            {return(SWITCH);}
"case"              {return(CASE);}
"break"             {return(BREAK);}
"continue"          {return(CONTINUE);}
"if"                {return(IF);}
"else"              {return(ELSE);}
"return"            {return(RETURN);}
"print"             {return(PRINT);}
"println"           {return(PRINTLN);}
"scanf"             {return(SCANF);}
"enum"              {return(ENUM);}
"struct"            {return(STRUCT);}
"malloc"            {return(MALLOC);}
"openFile"          {return(OPENFILE);}
"readLine"          {return(READLINE);}
"writeFile"         {return(WRITEFILE);}
"closeFile"         {return(CLOSEFILE);}
"free"              {return(FREE);}
"sizeof"            {return(SIZEOF);}
"concat"            {return(CONCAT);}
"lenght"            {return(LENGHT);}
"split"             {return(SPLIT);}
"includes"          {return(INCLUDES);}
"replace"           {return(REPLACE);}
"push"              {return(PUSH);}
"pop"               {return(POP);}
"indexOf"           {return(INDEXOF);}
"reverse"           {return(REVERSE);}
"slice"             {return(SLICE);}
"&&"                {return(AND);}
"||"                {return(OR);}
"!"                 {return(yytext[0]);}
"//"                {return(SINGLELINECOMMENT);}
";"                 {printf("Encontrei PV\n"); return(PV);}
"<="                {return(LESSTHENEQ);}
">="                {return(MORETHENEQ);}
"<"                 {return(yytext[0]);}
">"                 {return(yytext[0]);}
"+="                {return(MOREISEQUAL);}
"-="                {return(LESSISEQUAL);}
"=="                {return(ISEQUAL);}
"!="                {return(ISDIFFERENT);}
"++"                {return(INCREMENT);}
"--"                {return(DECREMENT);}
"="                 {return(yytext[0]);}
","                 {return(yytext[0]);}
"&&c"               {return(ANDCIRCUIT);}
"||c"               {return(ORCIRCUIT);}
"&"                 {return(yytext[0]);}
"?"                 {return(yytext[0]);}
":"                 {return(yytext[0]);}
"("                 {return(yytext[0]);}
")"                 {return(yytext[0]);}
"["                 {return(yytext[0]);}
"]"                 {return(yytext[0]);}
"{"                 {return(yytext[0]);}
"}"                 {return(yytext[0]);}
"."                 {return(yytext[0]);}
"^"                 {return(yytext[0]);}
"*"                 {return(yytext[0]);}
"/"                 {return(yytext[0]);}
"+"                 {return(yytext[0]);}
"-"                 {return(yytext[0]);}
"%"                 {return(yytext[0]);}
[0-9]+              {yylval.iValue = atoi(yytext); 
                       return NUMBER;}
[0-9]+"."[0-9]+      {
                         
                          return NUMBERFLOAT;
                      }
[a-zA-Z][a-zA-Z0-9]*  {yylval.sValue = strdup(yytext);
		       printf("Encontrei ID %s\n", yytext); 
                       return ID;}
.                     {yyerror("invalid character");}

%%

#ifndef yywrap
   int yywrap (void) {return 1;}
#endif


