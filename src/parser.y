%language "c++"
%skeleton "lalr1.cc"

%define parser_class_name { pn_parser }
%define api.token.constructor
%define api.value.type variant
%define parse.error verbose

%locations

%code requires
{
#include <iostream>
#include <string>
#include <cstdio>
#include <list>
#include <lexical_error.h>
#include <nodes.h>
}

%code
{
extern FILE* yyin;
extern yy::pn_parser::symbol_type yylex();
extern void yypop_buffer_state();

static std::list<line> lines;
}

/* terminal symbols */
%token <int> INT "integer"
%token <notation> IN "in" PRE "pre" POST "post"
%token ARROW "->" LPAREN "(" RPAREN ")" NL "new line" END 0 "end of file"
%token PLUS "+" MINUS "-" TIMES "*" DIV "/"

/* non-terminal symbols */
%type <line> line
%type <notation> notation
%type <node*> expression infix_expression prefix_expression postfix_expression

/* precedence */
%left PLUS MINUS
%left TIMES DIV

%%

program
	: lines
	| %empty
	;

lines
	: lines NL line { lines.push_back($3); }
	| lines NL
	| line { lines.push_back($1); }
	;

line
	: expression ARROW notation { $$ = line($1, $3); }
	;

notation
	: IN { $$ = $1; }
	| PRE { $$ = $1; }
	| POST { $$ = $1; }
	;

expression /* TODO solve reduce/reduce conflict when parsing only an INT */
	: infix_expression { $$ = $1; }
	| prefix_expression { $$ = $1; }
	| postfix_expression { $$ = $1; }
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

void show_error(const yy::location& l, const std::string &m) {
	std::cerr << "[Error at " << l << "] " << m << std::endl;
}

void yy::pn_parser::error(const location_type& l, const std::string &m) {
	show_error(l, m);
}

int main(int argc, char** argv) {
	if (argc > 1)
		yyin = std::fopen(argv[1], "r");

	try {
		yy::pn_parser p;
		if (p.parse() == 0) {
			for (auto l: lines) {
				std::cout << l.out() << std::endl;
				l.destroy();
			}
		}
	} catch (const lexical_error& e) {
		yypop_buffer_state();  // cleans scanner memory
		show_error(e.location(), e.what());
	}

	if (yyin != stdin)
		std::fclose(yyin);
}
