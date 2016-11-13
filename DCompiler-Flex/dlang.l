
%option noyywrap

%{
#include "util/lexDefinitions.h"
#include "errorManager.h"

int n_line = 1;
char buffer[512];
char buffer_pos = 0;

void add_to_buffer(char c);
void return_buffer();


%}
    /*===== DEFINITIONS =====*/

IdentifierChar          [_[:alpha:][:digit:]]
IdentifierInitialChar   [_[:alpha:]]
TrashChar               [ \t\v\f]
NumberChar              [[:digit:]_]
NumberInitialChar       [[:digit:]]
BinaryChar              [01_]
StringLiteralInitialChar    \"



%%
    /*===== RULES =====*/

{NumberInitialChar}{NumberChar}*                                        return(INTEGER);
{NumberInitialChar}{NumberChar}*[\.]{NumberChar}                        return(FLOAT);
{NumberInitialChar}{NumberChar}*([\.]{NumberChar}*)?[eE][+-]?{NumberChar}+  return(SCIENTIFIC);
0[bB]{BinaryChar}+                                                      return(BINARY);

{IdentifierInitialChar}{IdentifierChar}*                                return(IDENTIFIER);

    /*STRING LITERALS*/
{StringLiteralInitialChar}                                              {
                                                                            add_to_buffer('"');
                                                                            char c = input();
                                                                            add_to_buffer(c);
                                                                            while(c != '"'){
                                                                                if(c == '\n') n_line++;
                                                                                if(c == '\\')c = input();
                                                                                c = input();
                                                                                add_to_buffer(c);
                                                                            }
                                                                            return_buffer();
                                                                            return(STRING);
                                                                        }

    /*LINE COMMENT*/
"//".*\n                                                                n_line++;

    /*MULTILINE COMMENTS*/
"/*"                                                                    {
                                                                            char c;
                                                                            int check = 1;
                                                                            while(check > 0){
                                                                                while((c = input()) != '*' && c != EOF){
                                                                                    if(c == '\n') n_line++;
                                                                                }

                                                                                if(c == '*'){
                                                                                     while((c = input()) == '*');
                                                                                     if(c == '/') check = 0;
                                                                                }

                                                                                if(c == EOF) unexpectedEOF(n_line);
                                                                            }

                                                                        }
    /*DOCUMENTATION COMMENTS*/
"/**"[^/]                                                               {
                                                                            add_to_buffer('/');
                                                                            add_to_buffer('*');
                                                                            add_to_buffer('*');
                                                                            add_to_buffer(' ');
                                                                            char c;
                                                                            while(1){
                                                                                while((c = input()) != '*' && c != EOF){
                                                                                    add_to_buffer(c);
                                                                                    if(c == '\n') {
                                                                                        n_line++;
                                                                                    }
                                                                                }

                                                                                if(c == '*'){
                                                                                     add_to_buffer(c);
                                                                                     while((c = input()) == '*') add_to_buffer(c);;
                                                                                     if(c == '/') {
                                                                                        add_to_buffer(c);
                                                                                        return_buffer();
                                                                                        return(DOCCOMMENT);
                                                                                     }
                                                                                }

                                                                                if(c == EOF) unexpectedEOF(n_line);
                                                                            }
                                                                        }

    /*NESTED COMMENTS*/
"/+"                                                                    {
                                                                            int nested_count = 1;
                                                                            char c;
                                                                            while(nested_count > 0){
                                                                                while((c = input()) != '+' && c != EOF){
                                                                                    if(c == '\n') n_line++;
                                                                                    if(c == '/'){
                                                                                        while((c = input()) == '/');
                                                                                        if(c == '+') {
                                                                                            nested_count++;
                                                                                        }
                                                                                    }
                                                                                }

                                                                                if(c == '+'){
                                                                                     while((c = input()) == '+');
                                                                                     if(c == '/'){
                                                                                        nested_count--;
                                                                                     }
                                                                                }

                                                                                if(c == EOF) unexpectedEOF(n_line);
                                                                            }

                                                                        }

    /*OPERATORS*/
"+"     return('+');
"-"     return('-');
"*"     return('*');
"/"     return('/');
"^"     return('^');
"."     return('.');
","     return(',');
";"     return(';');
":"     return(':');
"#"     return('#');
"|"     return('|');
"&"     return('&');
"("     return('(');
")"     return(')');
"["     return('[');
"]"     return(']');
"{"     return('{');
"}"     return('}');
"?"     return('?');
"="     return('=');
"!"     return('!');
"$"     return('$');
"%"     return('%');

"++"    return(PLUSPLUS);
"--"    return(MINUSMINUS);
"=="    return(EQUALEQUAL);
">="    return(GREATEREQUAL);
"<="    return(LESSEQUAL);
"!="    return(NOTEQUAL);
"+="    return(PLUSEQUAL);
"-="    return(MINUSEQUAL);
"*="    return(MULTEQUAL);
">>"    return(GREATERGREATER);
"<<"    return(LESSLESS);
"%%"    return(PERCENTPERCENT);
"&&"    return(ANDAND);
"&="    return(ANDEQUAL);
"||"    return(OROR);
"|="    return(OREQUAL);

\n     n_line++;
{TrashChar}
<<EOF>> return(EOF);
.

%%

void add_to_buffer(char c){
    buffer[buffer_pos] = c;
    buffer_pos++;
}

void return_buffer(){
    buffer[buffer_pos] = '\0';
    buffer_pos = 0;
}
