%language "c++"
%skeleton "lalr1.cc"

%defines "include/parser.h"
%output "src/parser.cpp"

%define parser_class_name { pn_parser }
%define api.token.constructor
%define api.value.type variant
%define parse.error verbose

%locations

%code requires
{
#include <iostream>
#include <cstdio>
#include <list>
#include <nodes.h>
}

%code
{
extern FILE* yyin;
extern yy::pn_parser::symbol_type yylex();

void generic_error(const yy::location&, const std::string&);

std::list<line> lines;
}

/* terminal symbols */
%token <int> INT
%token <notation> IN PRE POST
%token ARROW COLON LPAREN RPAREN NL END 0

/* non-terminal symbols */
%type <line> line
%type <notation> notation
%type <node*> infix_expression prefix_expression postfix_expression

/* precedence */
%left PLUS MINUS
%left TIMES DIV

%%

program
	: lines
	;

lines
	: lines NL line { lines.push_back($3); }
	| lines NL
	| line { lines.push_back($1); }
	| %empty
	;

line
	: IN ARROW notation COLON infix_expression { $$ = line($5, $3); }
	| PRE ARROW notation COLON prefix_expression { $$ = line($5, $3); }
	| POST ARROW notation COLON postfix_expression { $$ = line($5, $3); }
	;

notation
	: IN { $$ = $1; }
	| PRE { $$ = $1; }
	| POST { $$ = $1; }
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

void generic_error(const yy::location& l, const std::string &m) {
	std::cerr << "[Error at " << l << "] " << m << std::endl;
}

void yy::pn_parser::error(const location_type& l, const std::string &m) {
	generic_error(l, m);
}

int main(int argc, char** argv) {
	yy::pn_parser p;

	if (argc == 2)
		yyin = std::fopen(argv[1], "r");

	if (p.parse() == 0) {
		for (auto l: lines) {
			std::cout << l.out() << std::endl;
		}
	}

	if (yyin != stdin)
		std::fclose(yyin);
}
