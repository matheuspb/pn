.PHONY: all clean

CPPFLAGS = -std=c++11 -I include -Wall -Wextra

all: eval

src/scanner.cpp: src/scanner.l include/parser.h
	flex -o src/scanner.cpp src/scanner.l

include/parser.h: src/parser.y
	bison src/parser.y
	mv src/*.hh include/

eval: src/scanner.cpp src/parser.cpp src/nodes.cpp
	$(CXX) $(CPPFLAGS) -o $@ $^

clean:
	rm eval include/*.hh src/scanner.cpp include/parser.h src/parser.cpp
