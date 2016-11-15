
%option noyywrap

%{
#include "util/lexDefinitions.h"
#include "errorManager.h"

int n_line = 1;
int nested_count=0;

%}
    /*===== DEFINITIONS =====*/

IdentifierChar              [_[:alpha:][:digit:]]
IdentifierInitialChar       [_[:alpha:]]
TrashChar                   [ \t\v\f]
NumberChar                  [[:digit:]_]
NumberInitialChar           [[:digit:]]
BinaryChar                  [01_]
StringLiteralInitialChar    \"

    /*START CONDITIONS*/
%x S_MULTILINE_COMMENT
%x S_DOCUMENTATION_COMMENT
%x S_NESTED_COMMENT
%x S_STRING_LITERAL

%%
    /*======== RULES ========*/

{NumberInitialChar}{NumberChar}*                                        return(INTEGER);
{NumberInitialChar}{NumberChar}*[\.]{NumberChar}*                        return(FLOAT);
{NumberInitialChar}{NumberChar}*([\.]{NumberChar}*)?[eE][+-]?{NumberChar}+  return(SCIENTIFIC);
0[bB]{BinaryChar}+                                                      return(BINARY);
{IdentifierInitialChar}{IdentifierChar}*                                return(IDENTIFIER);

    /*STRING LITERALS*/
{StringLiteralInitialChar}                                              BEGIN(S_STRING_LITERAL);yymore();
<S_STRING_LITERAL>\n                                                    BEGIN(INITIAL);unexpectedEndOfLine(n_line);
<S_STRING_LITERAL>{StringLiteralInitialChar}                            BEGIN(INITIAL);return(STRING);
<S_STRING_LITERAL><<EOF>>                                               BEGIN(INITIAL);unexpectedEOF(n_line);yyrestart(yyin);
<S_STRING_LITERAL>\\\'                                                  |
<S_STRING_LITERAL>\\\?                                                  |
<S_STRING_LITERAL>\\\\                                                  |
<S_STRING_LITERAL>\\0                                                   |
<S_STRING_LITERAL>\\a                                                   |
<S_STRING_LITERAL>\\b                                                   |
<S_STRING_LITERAL>\\f                                                   |
<S_STRING_LITERAL>\\n                                                   |
<S_STRING_LITERAL>\\r                                                   |
<S_STRING_LITERAL>\\t                                                   |
<S_STRING_LITERAL>\\v                                                   |
<S_STRING_LITERAL>\\\"                                                  yymore();
<S_STRING_LITERAL>\\.                                                   BEGIN(INITIAL);illegalEscapeSequence(n_line);
<S_STRING_LITERAL>.                                                     yymore();



    /*LINE COMMENT*/
"//".*\n                                                                n_line++;

    /*MULTILINE COMMENTS*/
"/*"                                                                    BEGIN(S_MULTILINE_COMMENT);
<S_MULTILINE_COMMENT>\n                                                 n_line++;
<S_MULTILINE_COMMENT>"*/"                                               BEGIN(INITIAL);
<S_MULTILINE_COMMENT><<EOF>>                                            BEGIN(INITIAL);unexpectedEOF(n_line);
<S_MULTILINE_COMMENT>.


    /*DOCUMENTATION COMMENTS*/
"/**"\n                                                                 BEGIN(S_DOCUMENTATION_COMMENT);yymore();n_line++;
"/**"[^/]                                                               BEGIN(S_DOCUMENTATION_COMMENT);yymore();
<S_DOCUMENTATION_COMMENT>\n                                             yymore();n_line++;
<S_DOCUMENTATION_COMMENT>"*/"                                           BEGIN(INITIAL);return(DOCCOMMENT);
<S_DOCUMENTATION_COMMENT><<EOF>>                                        BEGIN(INITIAL);unexpectedEOF(n_line);yyrestart(yyin);
<S_DOCUMENTATION_COMMENT>.                                              yymore();

    /*NESTED COMMENTS*/
"/+"                                                                    BEGIN(S_NESTED_COMMENT);nested_count++;
<S_NESTED_COMMENT>\n                                                    n_line++;
<S_NESTED_COMMENT>"/+"                                                  nested_count++;
<S_NESTED_COMMENT>"+/"                                                  {
                                                                            nested_count--;
                                                                            if(nested_count == 0){
                                                                                BEGIN(INITIAL);
                                                                            }
                                                                        }
<S_NESTED_COMMENT><<EOF>>                                               BEGIN(INITIAL);unexpectedEOF(n_line);
<S_NESTED_COMMENT>.


    /*OPERATORS*/
"+"     return('+');
"-"     return('-');
"*"     return('*');
"/"     return('/');
"^"     return('^');
">"     return('>');
"<"     return('<');
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
.   unknownComponent(n_line);
%%