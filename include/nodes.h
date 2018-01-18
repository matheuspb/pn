#ifndef NODES_H
#define NODES_H

#include <string>

enum notation { INFIX, PREFIX, POSTFIX };

class node {
public:
	node() = default;
	node(node* _left, node* _right) : left{_left}, right{_right} {}
	virtual ~node();

	virtual int eval() const = 0;
	virtual std::string infix() const = 0;
	virtual std::string prefix() const;
	virtual std::string postfix() const;

protected:
	node* left;
	node* right;
};

class plus_node : public node {
public:
	using node::node;
	int eval() const override;
	std::string infix() const override;
};

class minus_node : public node {
public:
	using node::node;
	int eval() const override;
	std::string infix() const override;
};

class times_node : public node {
public:
	using node::node;
	int eval() const override;
	std::string infix() const override;
};

class div_node : public node {
public:
	using node::node;
	int eval() const override;
	std::string infix() const override;
};

class int_node : public node {
public:
	int_node(int _value) : value{_value} {}
	int eval() const override;
	std::string infix() const override;
	std::string prefix() const override;
	std::string postfix() const override;

private:
	int value;
};

class line {
public:
	line() = default;
	line(node* _root, notation _output_notation)
		: root{_root}, output_notation{_output_notation} {}

	std::string out() const;

	// TODO write a proper destructor
	void destroy();

private:
	node* root;
	notation output_notation;
};

#endif
