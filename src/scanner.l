%{
#include <iostream>
#include <parser.h>
#include <nodes.h>

#define yyterminate() return yy::pn_parser::make_END(yyloc)
#define YY_DECL yy::pn_parser::symbol_type yylex()
#define YY_USER_ACTION yyloc.step(); yyloc.columns(yyleng);

static yy::location yyloc;
extern void generic_error(const yy::location&, const std::string&);
%}

%option noyywrap noinput nounput nodefault

digs [0-9]+

%%

[ \t]	yyloc.step(); /* ignore whitespace */
{digs}	return yy::pn_parser::make_INT(std::atoi(yytext), yyloc);
"in"	return yy::pn_parser::make_IN(INFIX, yyloc);
"pre"	return yy::pn_parser::make_PRE(PREFIX, yyloc);
"post"	return yy::pn_parser::make_POST(POSTFIX, yyloc);
"->"	return yy::pn_parser::make_ARROW(yyloc);
":"	return yy::pn_parser::make_COLON(yyloc);
"+"	return yy::pn_parser::make_PLUS(yyloc);
"-"	return yy::pn_parser::make_MINUS(yyloc);
"*"	return yy::pn_parser::make_TIMES(yyloc);
"/"	return yy::pn_parser::make_DIV(yyloc);
"("	return yy::pn_parser::make_LPAREN(yyloc);
")"	return yy::pn_parser::make_RPAREN(yyloc);
\n	yyloc.lines(yyleng); yyloc.step(); return yy::pn_parser::make_NL(yyloc);
.	{
	std::string err_msg("lexical error, unknown symbol ");
	err_msg += yytext;
	generic_error(yyloc, err_msg);
	yyterminate();
}
<<EOF>>	yyterminate();

%%

