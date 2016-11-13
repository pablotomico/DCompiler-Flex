#ifndef DCOMPILER_ERRORMANAGER_H
#define DCOMPILER_ERRORMANAGER_H

#endif //DCOMPILER_ERRORMANAGER_H

void illegalEscapeSequence(int lineNumber);

void unexpectedNewLine(int lineNumber);

void unexpectedEOF(int lineNumber);

void malformedBinary(int lineNumber, char* number);

void malformedScientific(int lineNumber, char* number);

void fatalError(char* msg);