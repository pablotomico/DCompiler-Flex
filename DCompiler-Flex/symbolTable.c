#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "util/binarySearchTree.h"
#include "errorManager.h"

#define DEFINITIONS_PATH "/home/pablo/GitProjects/DCompiler-Flex/DCompiler-Flex/util/definitions.txt"


typedef struct table *symbolTable;
struct table {
    tree t;
    FILE *file;
};

void executeParse(symbolTable *st, char *filePath);

void createSymbolTable(symbolTable *st){
    *st = NULL;
}

void initSymbolTable(symbolTable *st) {
    symbolTable stAux;
    stAux = (symbolTable) malloc(sizeof(struct table));
    stAux->t = NULL;
    stAux->file = NULL;

    create(&(stAux)->t);
    executeParse(&stAux, DEFINITIONS_PATH);

    *st = stAux;
}

void addLexem(symbolTable *st, char *lex, int comp) {
    char *lexem = (char *) malloc(sizeof(char) * (strlen(lex) + 1));
    int i = 0;
    size_t length = strlen(lex) * sizeof(char);
    for (i = 0; i < strlen(lex); i++) {
        lexem[i] = lex[i];
    }
    lexem[length] = '\0';
    insert(&((*st)->t), lexem, comp);
}

int getComponentByLexem(symbolTable st, char *lex) {
    return getComponentByLex(st->t, lex);
}

void deleteSymbolTable(symbolTable *st) {
    delete(&((*st)->t));
}

void printSymbolTable(symbolTable st) {
    printf("\n\n======================== \n");
    printf("===== SYMBOL TABLE ===== \n");
    printf("=== (Comp) --> (Lex) === \n");
    printf("======================== \n");
    printTree(st->t);
}

void executeParse(symbolTable *st, char *filePath) {

    char *line = NULL;
    char *word = NULL;
    char *lex = NULL;
    int component = 0;
    size_t len = 0;
    ssize_t read;
    int res = 0;
    size_t length = 0;
    short i = 0;

    (*st)->file = fopen(filePath, "r");

    if ((*st)->file == NULL) {
        fatalError("Couldn't read definitions file!");
        exit(EXIT_FAILURE);
    }

    while ((read = getline(&line, &len, (*st)->file)) != -1) {
        //printf("%s", line);
        word = strtok(line, " ");

        res = strcmp(word, "#define");
        if (res == 0) {
            word = strtok(NULL, " ");
        }
        res = strcmp(word, "#define");
        if (res != 0 && isalpha(word[0])) {
            length = strlen(word) * sizeof(char);
            lex = (char *) malloc(length + sizeof(char));
            for (i = 0; i < length; i++) {
                lex[i] = word[i];
            }
            lex[length] = '\0';
            word = strtok(NULL, " ");
            if (word != NULL && isdigit(word[0])) {
                component = atoi(word);
                addLexem(st, lex, component);
                word = NULL;
                component = 0;
            }
        }

        //printf("%s\n", word);
    }

    fclose((*st)->file);

    if (line) {
        free(line);
    }

    //printTree((*st)->t);
}