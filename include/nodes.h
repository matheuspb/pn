#ifndef NODES_H
#define NODES_H

#include <string>

class node {
public:
	node() = default;
	node(node* _left, node* _right): left{_left}, right{_right} {}
	virtual int eval() const = 0;
	virtual std::string prefix() const = 0;

protected:
	node* left;
	node* right;
};

class plus_node : public node {
public:
	using node::node;
	int eval() const override;
	std::string prefix() const override;
};

class minus_node : public node {
public:
	using node::node;
	int eval() const override;
	std::string prefix() const override;
};

class times_node : public node {
public:
	using node::node;
	int eval() const override;
	std::string prefix() const override;
};

class div_node : public node {
public:
	using node::node;
	int eval() const override;
	std::string prefix() const override;
};

class int_node : public node {
public:
	int_node(int _value): value{_value} {}
	int eval() const override;
	std::string prefix() const override;

private:
	int value;
};

#endif
