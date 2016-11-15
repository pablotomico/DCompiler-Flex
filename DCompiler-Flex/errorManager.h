#ifndef DCOMPILER_ERRORMANAGER_H
#define DCOMPILER_ERRORMANAGER_H

#endif //DCOMPILER_ERRORMANAGER_H

void illegalEscapeSequence(int lineNumber);

void unexpectedEndOfLine(int lineNumber);

void unexpectedEOF(int lineNumber);

void malformedBinary(int lineNumber, char* number);

void malformedScientific(int lineNumber, char* number);

void unknownComponent(int lineNumber);

void fatalError(char* msg);