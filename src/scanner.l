%{
#include <iostream>
#include <nodes.h>
#include <parser.h>

extern int yylineno;
void yyerror(const char*, ...);
%}

%option yylineno noyywrap noinput nounput

digs [0-9]+

%%

[ \t]     ; /* ignore whitespace */
{digs}    { yylval.value = std::atoi(yytext); return INT; }
"in"      { yylval.notation = INFIX; return IN; }
"pre"     { yylval.notation = PREFIX; return PRE; }
"post"    { yylval.notation = POSTFIX; return POST; }
"->"      { return ARROW; }
":"       { return COLON; }
"+"       { return PLUS; }
"-"       { return MINUS; }
"*"       { return TIMES; }
"/"       { return DIV; }
"("       { return LPAREN; }
")"       { return RPAREN; }
\n        { return NL; }
.         { yyerror("lexical error, unknown symbol %s", yytext); }

%%

void yyerror(const char* s, ...) {
	va_list ap;
	va_start(ap, s);
	std::fprintf(stderr, "[Line %d] ", yylineno);
	std::vfprintf(stderr, s, ap);
	std::fprintf(stderr, "\n");
}
