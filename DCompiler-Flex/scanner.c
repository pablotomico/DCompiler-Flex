#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include "errorManager.h"
#include "scanner.h"



void createScanner(Scanner *s) {
    *s = NULL;
}

void initScanner(Scanner *s, char *filePath) {
    Scanner sAux;
    sAux = (Scanner) malloc(sizeof(struct scan));

    sAux->file = fopen(filePath, "r");
    if (sAux->file == NULL) {
        fatalError("Couldn't read code file!");
        exit(EXIT_FAILURE);
    }

    *s = sAux;
}

void deleteScanner(Scanner *s) {
    fclose((*s)->file);
}