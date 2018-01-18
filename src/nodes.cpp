#include <iostream>
#include <nodes.h>

/* check if node is one of the lower precedence operators */
#define __needs_parentheses(node)                                              \
	(dynamic_cast<const plus_node*>(node) ||                                   \
	 dynamic_cast<const minus_node*>(node))

static std::string parenthesized_infix(const node*, const node*, std::string);

node::~node() {
	delete left;
	delete right;
}

int plus_node::eval() const {
	return left->eval() + right->eval();
}

int minus_node::eval() const {
	return left->eval() - right->eval();
}

int times_node::eval() const {
	return left->eval() * right->eval();
}

int div_node::eval() const {
	return left->eval() / right->eval();
}

int int_node::eval() const {
	return value;
}

/* infix notation output */

std::string plus_node::infix() const {
	return left->infix() + " + " + right->infix();
}

std::string minus_node::infix() const {
	return left->infix() + " - " + right->infix();
}

std::string times_node::infix() const {
	return parenthesized_infix(left, right, "*");
}

std::string div_node::infix() const {
	return parenthesized_infix(left, right, "/");
}

std::string
parenthesized_infix(const node* left, const node* right, std::string op) {
	std::string out;

	if (__needs_parentheses(left))
		out += "(" + left->infix() + ")";
	else
		out += left->infix();

	out += " " + op + " ";

	if (__needs_parentheses(right))
		out += "(" + right->infix() + ")";
	else
		out += right->infix();

	return out;
}

std::string int_node::infix() const {
	return std::to_string(value);
}

/* prefix notation output */

std::string node::prefix() const {
	std::string out;
	if (dynamic_cast<const plus_node*>(this)) {
		out += "+ ";
	} else if (dynamic_cast<const minus_node*>(this)) {
		out += "- ";
	} else if (dynamic_cast<const times_node*>(this)) {
		out += "* ";
	} else if (dynamic_cast<const div_node*>(this)) {
		out += "/ ";
	}
	out += left->prefix() + right->prefix();
	return out;
}

std::string int_node::prefix() const {
	return std::to_string(value) + " ";
}

/* postfix notation output */

std::string node::postfix() const {
	std::string out = left->postfix() + right->postfix();
	if (dynamic_cast<const plus_node*>(this)) {
		out += " +";
	} else if (dynamic_cast<const minus_node*>(this)) {
		out += " -";
	} else if (dynamic_cast<const times_node*>(this)) {
		out += " *";
	} else if (dynamic_cast<const div_node*>(this)) {
		out += " /";
	}
	return out;
}

std::string int_node::postfix() const {
	return " " + std::to_string(value);
}

/* line destructor */
void line::destroy() {
	delete root;
}

/* returns a string representing the expression using the desired notation */
std::string line::out() const {
	std::string out;

	switch (output_notation) {
	case INFIX:
		out += root->infix() + " ";
		break;
	case PREFIX:
		out += root->prefix();
		break;
	case POSTFIX:
		out += root->postfix() + " ";
		break;
	}

	out += "= " + std::to_string(root->eval());
	return out;
}
