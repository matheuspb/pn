%{
#include <iostream>
#include <cstdio>
#include <list>
#include <nodes.h>

extern int yylineno;
extern FILE* yyin;
extern int yylex();
extern void yyerror(const char*, ...);

std::list<node*> expressions;
%}

%define parse.error verbose

%defines "include/parser.h"
%output "src/parser.cpp"

%union {
	int value;
	node* opnode;
}

/* terminal symbols */
%token <value> INT
%token LPAREN RPAREN NL

/* non-terminal symbols */
%type <opnode> expression

/* precedence */
%left PLUS MINUS
%left TIMES DIV

%%

program
	: lines
	;

lines
	: lines NL line
	| line
	;

line
	: expression { expressions.push_back($1); }
	| %empty
	;

expression
	: expression PLUS expression { $$ = new plus_node($1, $3); }
	| expression MINUS expression { $$ = new minus_node($1, $3); }
	| expression TIMES expression { $$ = new times_node($1, $3); }
	| expression DIV expression { $$ = new div_node($1, $3); }
	| LPAREN expression RPAREN { $$ = $2; }
	| INT { $$ = new int_node($1); }
	;

%%

int main(int argc, char** argv) {
	if (argc == 2)
		yyin = std::fopen(argv[1], "r");

	if (yyparse() == 0) {
		for (auto expr: expressions) {
			std::cout << expr->prefix() << "= " << expr->eval() << std::endl;
		}
	}
}
