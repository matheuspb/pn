.PHONY: all clean

CPPFLAGS = -std=c++11 -I include -Wall -Wextra

all: eval

src/scanner.cpp: src/scanner.l include/parser.h
	flex -o src/scanner.cpp src/scanner.l

include/parser.h: src/parser.y
	bison src/parser.y

eval: src/scanner.cpp src/parser.cpp src/nodes.cpp
	$(CXX) $(CPPFLAGS) -o $@ $^

clean:
	rm eval src/scanner.cpp include/parser.h src/parser.cpp
