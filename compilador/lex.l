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
"bool"              {yylval.sValue = strdup("bool"); 
                    return TYPE;}
"true"              {return(TRUE);}
"false"             {return(FALSE);}
"function"          {return(FUNCTION);}
"procedure"         {return(PROCEDURE);}
"while"             {return(WHILE);}
"if"                {return(IF);}
"else"              {return(ELSE);}
"return"            {return(RETURN);}
"print"             {return(PRINT);}
"println"           {return(PRINTLN);}
"input"             {return(SCANF);}
"&&"                {return(AND);}
"||"                {return(OR);}
";"                 {return(PV);}
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
"&"                 {return(yytext[0]);}
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
[\"]                {return(yytext[0]);}
[-]*[0-9]+              {yylval.iValue = atoi(yytext); 
                       return NUMBER;}
[-]*[0-9]+"."[0-9]+     {yylval.fValue = atof(yytext);
                          return NUMBERFLOAT;}
[a-zA-Z][a-zA-Z0-9_]* {yylval.sValue = strdup(yytext);
                       return ID;}
"\""[^'"]*"\""       {yylval.sValue = strdup(yytext);
                                          return WORD;}           
.                     {yyerror("invalid character");}

%%

#ifndef yywrap
   int yywrap (void) {return 1;}
#endif
