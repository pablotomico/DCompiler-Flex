#include "symbolTable.h"
#include "scanner.h"
#include "util/lexDefinitions.h"
#include "lexicAnalysisFunctions.h"
#include "errorManager.h"
#include "lex.yy.c"
#define FILE_PATH "/home/pablo/GitProjects/DCompiler-Flex/DCompiler-Flex/regression.d"


typedef struct analyzer *lexAnalyzer;
struct analyzer {
    symbolTable st;
    Scanner s;
};
typedef struct {
    char *lexem;
    int component;
} lex;



void initLexAnalyzer(lexAnalyzer *la) {

    lexAnalyzer laAux;
    laAux = (lexAnalyzer) malloc(sizeof(struct analyzer));
    laAux->s = NULL;
    laAux->st = NULL;

    createScanner(&(laAux->s));
    createSymbolTable(&(laAux->st));

    initScanner(&(laAux->s), FILE_PATH);
    initSymbolTable(&(laAux->st));
    yyin = (laAux->s)->file;
    *la = laAux;
}

lex getNextComponent(lexAnalyzer *la) {
    lex l;
    l.component = yylex();
    int i = 0;


    //TODO identifiers

    if(l.component == STRING || l.component == DOCCOMMENT){
        while (buffer[i] != '\0'){
            i++;
        }
        l.lexem = (char *) malloc ((i + 1) * sizeof(char));
        strcpy(l.lexem, buffer);
        l.lexem[i] = '\0';
    }else{
        while (*(yytext + i) != '\0'){
            i++;
        }
        l.lexem = (char *) malloc ((i + 1) * sizeof(char));
        strcpy(l.lexem, yytext);
        l.lexem[i] = '\0';

        if(l.component == IDENTIFIER){
            if ((l.component = getComponentByLexem((*la)->st, l.lexem)) == 0) {
                l.component = IDENTIFIER;
                addLexem(&((*la)->st), l.lexem, l.component);
            }
        }
    }




    return l;
}

void deleteLexAnalyzer(lexAnalyzer *la) {
    deleteScanner(&((*la)->s));
    deleteSymbolTable(&((*la)->st));
}

void printSymbols(lexAnalyzer *la) {
    printSymbolTable((*la)->st);
}