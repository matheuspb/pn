.PHONY: all clean

TARGET = pn
INCLUDE_DIR = include
SOURCE_DIR = src

CPPFLAGS = -std=c++11 -I$(INCLUDE_DIR) -Wall -Wextra
LDFLAGS = -lstdc++

SCANNER_L = $(SOURCE_DIR)/scanner.l
SCANNER_SRC = $(SOURCE_DIR)/scanner.cpp

PARSER_Y = $(SOURCE_DIR)/parser.y
PARSER_H = $(INCLUDE_DIR)/parser.h
PARSER_SRC = $(SOURCE_DIR)/parser.cpp

SRC_FILES = $(SCANNER_SRC) $(PARSER_SRC) $(SOURCE_DIR)/nodes.cpp
OBJ_FILES = $(SRC_FILES:.cpp=.o)

I_TARGET = $(PARSER_SRC:.cpp=)

all: $(TARGET)

$(SCANNER_SRC): $(SCANNER_L)
	flex -o $(SCANNER_SRC) $(SCANNER_L)

$(PARSER_SRC) $(PARSER_H): $(PARSER_Y)
	bison -o $(PARSER_SRC) --defines=$(PARSER_H) $(PARSER_Y)
	mv $(SOURCE_DIR)/*.hh $(INCLUDE_DIR)

$(I_TARGET): $(OBJ_FILES)
$(TARGET): $(I_TARGET)
	cp $(I_TARGET) $(TARGET)

clean:
	rm -f $(TARGET) $(I_TARGET) $(OBJ_FILES)
	rm -f $(INCLUDE_DIR)/*.hh $(SCANNER_SRC) $(PARSER_H) $(PARSER_SRC)
