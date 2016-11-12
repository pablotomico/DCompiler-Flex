/* DEFINITIONS */

DIGIT		[0-9]
ID		[_a-zA-Z][_a-zA-Z0-9]*
OPERATOR 	[\+\-\/\*\.\-\,\;\:\{\}\[\]]
STRING_LITERAL	["].*["]
CHAR_LITERAL	['].[']
LINE_COMMENT	[\/][\/].*


%%

{DIGIT}+		printf("INTEGER 		= [%s]\n", yytext);
{DIGIT}+"."{DIGIT}+	printf("FLOAT 	 		= [%s]\n", yytext);
{ID}			printf("IDENTIFIER	 	= [%s]\n", yytext);
{OPERATOR}		printf("OPERATOR 		= [%s]\n", yytext);
{STRING_LITERAL}	printf("STRING LITERAL		= [%s]\n", yytext);
{CHAR_LITERAL}		printf("CHAR LITERAL		= [%s]\n", yytext);
{LINE_COMMENT}		printf("LINE COMMENT		= [%s]\n", yytext);
.
