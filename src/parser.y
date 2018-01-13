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
%token LPAREN RPAREN NL IN PRE POST COLON

/* non-terminal symbols */
%type <opnode> infix_expression prefix_expression postfix_expression

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
	: IN COLON infix_expression { expressions.push_back($3); }
	| PRE COLON prefix_expression { expressions.push_back($3); }
	| POST COLON postfix_expression { expressions.push_back($3); }
	| %empty
	;

infix_expression
	: infix_expression PLUS infix_expression { $$ = new plus_node($1, $3); }
	| infix_expression MINUS infix_expression { $$ = new minus_node($1, $3); }
	| infix_expression TIMES infix_expression { $$ = new times_node($1, $3); }
	| infix_expression DIV infix_expression { $$ = new div_node($1, $3); }
	| LPAREN infix_expression RPAREN { $$ = $2; }
	| INT { $$ = new int_node($1); }
	;

prefix_expression
	: PLUS prefix_expression prefix_expression { $$ = new plus_node($2, $3); }
	| MINUS prefix_expression prefix_expression { $$ = new minus_node($2, $3); }
	| TIMES prefix_expression prefix_expression { $$ = new times_node($2, $3); }
	| DIV prefix_expression prefix_expression { $$ = new div_node($2, $3); }
	| INT { $$ = new int_node($1); }
	;

postfix_expression
	: postfix_expression postfix_expression PLUS {
		$$ = new plus_node($1, $2);
	}
	| postfix_expression postfix_expression MINUS {
		$$ = new minus_node($1, $2);
	}
	| postfix_expression postfix_expression TIMES {
		$$ = new times_node($1, $2);
	}
	| postfix_expression postfix_expression DIV {
		$$ = new div_node($1, $2);
	}
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
