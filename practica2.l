%{
#include <stdlib.h>
#include "practica2.tab.h"

void showError();
%}

%option yylineno
head "<?xml" 
version "version=\"1.0\"" 
encoding1 "encoding=\"UTF-8\"?>" 
encoding2 "encoding=\"UTF-16\"?>"
leftopen "<"
rigthopen ">"
rigthclose "</"
adm "<!--"
comm "-->"
string [^ <> \n\r]+

%%
{head}           { printf("TOKEN: HEAD -> %s\n", yytext); return HEAD; }
{version}        { printf("TOKEN: VERSION -> %s\n", yytext); return VERSION; }
{encoding1}      { printf("TOKEN: ENCODING -> %s\n", yytext); return ENCODING1; }
{encoding2}      { printf("TOKEN: ENCODING -> %s\n", yytext); return ENCODING2; }
{leftopen}       { printf("TOKEN: LOPEN -> %s\n", yytext); return LOPEN; }
{rigthopen}      { printf("TOKEN: ROPEN -> %s\n", yytext); return ROPEN; }
{rigthclose}     { printf("TOKEN: CLOSED -> %s\n", yytext); return CLOSED; }
{adm}            { printf("TOKEN: ADM -> %s\n", yytext); return ADM; }
{comm}           { printf("TOKEN: COMM -> %s\n", yytext); return COMM; }
{string}         { printf("TOKEN: STRING -> %s\n", yytext); yylval.valString = strdup(yytext); return STRING; }
[ \t\n\r]+        { }  // Ignorar espacios, tabulaciones y saltos de línea

%%

void showError(char* arg){ printf("LEXICAL ERROR %s %d\n  ",  arg, yylineno);}