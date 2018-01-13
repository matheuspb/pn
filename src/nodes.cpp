#include <iostream>
#include <nodes.h>

int plus_node::eval() const { return left->eval() + right->eval(); }

int minus_node::eval() const { return left->eval() - right->eval(); }

int times_node::eval() const { return left->eval() * right->eval(); }

int div_node::eval() const { return left->eval() / right->eval(); }

int int_node::eval() const { return value; }

std::string plus_node::prefix() const {
	return "+ " + left->prefix() + right->prefix();
}

std::string minus_node::prefix() const {
	return "- " + left->prefix() + right->prefix();
}

std::string times_node::prefix() const {
	return "* " + left->prefix() + right->prefix();
}

std::string div_node::prefix() const {
	return "/ " + left->prefix() + right->prefix();
}

std::string int_node::prefix() const {
	 return std::to_string(value) + " ";
}
