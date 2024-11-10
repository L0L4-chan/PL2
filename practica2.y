%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct er {
    char* type; 
    int line;
};

struct er errores[100];
int error_count = 0;

extern int yylex();
extern int yylineno;

void yyerror(const char *s);
void print_errors();
void same_tag(char * s1, char * s2);
%}

%union {
    char * valString;
    int valInt;
    float valFloat;
}


%token <valString>  LOPEN ROPEN CLOSED ADM COMM HEAD VERSION ENCODING1 ENCODING2 
%token <valString> STRING
%type <valString> tag1 tag2 


%start S
%%

S:  cabecera cuerpo {
            if (error_count == 0) {
                printf("XML correcto\n");
            } else {
                print_errors();
            }
        }
    | error { yyerror("error en entrada"); print_errors();}    
;

cuerpo:  
    | comentario cuerpo
    | term cuerpo
    | tag1 cuerpo tag2
    | error { yyerror("error en body");}   
;


term: 
    tag1 string tag2 {same_tag($1,$3);}
    | error { yyerror("error en term");}   
;
tag1:
    LOPEN STRING ROPEN
    {$$ = $2;}
;
tag2:
  CLOSED STRING ROPEN
    {$$ = $3;}
;

string:
| string STRING 
| STRING 

comentario:
     ADM  string COMM 
;
cabecera: 
    HEAD VERSION  enc
    | error { yyerror("error en cabecera");}
;

enc:
    ENCODING1
    | ENCODING2
;
%%
int main(int argc, char *argv[]) {
    extern FILE *yyin;

    switch (argc) {
        case 1:
            yyin = stdin;
            yyparse();
            break;
        case 2:
            yyin = fopen(argv[1], "r");
            if (yyin == NULL) {
                printf("ERROR: No se ha podido abrir el fichero.\n");
            } else {
                yyparse();
                fclose(yyin);
            }
            break;
        default:
            printf("ERROR: Demasiados argumentos.\nSintaxis: %s [fichero_entrada]\n\n", argv[0]);
    }
}

void yyerror(const char *s) {
    if (error_count < 100) {  // Limitar a 100 errores
        errores[error_count].type = strdup(s);
        errores[error_count].line = yylineno;
        error_count++;
    }
}

void print_errors() {
    printf("Errores de sintaxis encontrados:\n");
    for (int i = 0; i < error_count; i++) {
        printf("Error: %s en la línea %d\n", errores[i].type, errores[i].line);
    }
}

void same_tag (char *s1,  char *s2) {
    if (strcmp(s1, s2) != 0){
        char error_msg[100];
        snprintf(error_msg, sizeof(error_msg), "Las etiquetas '%s' y '%s' no coinciden", s1, s2);
        yyerror(error_msg);
    }
}    
