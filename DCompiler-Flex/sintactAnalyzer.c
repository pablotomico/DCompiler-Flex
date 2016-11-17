#include <stdio.h>
#include <stdlib.h>
#include "symbolTable.h"
#include "scanner.h"
#include "lexAnalyzer.h"


int main(int argc, char **argv) {
    lexAnalyzer la;
    initLexAnalyzer(&la);
    lex l;

    printf("\n===========================\n");
    printf("===== LEXIC  ANALYSIS ===== \n");
    printf("==== (Comp) --> (Lex)  ==== \n");
    printf("=========================== \n");


    do{
        l = getNextComponent(&la);
        printf("       %3d  -->  %s\n", l.component, l.lexem);
    }while(l.component != EOF);

    printSymbols(&la);
    deleteLexAnalyzer(&la);

    return EXIT_SUCCESS;
}
