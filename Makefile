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

all: $(TARGET)

$(SCANNER_SRC): $(SCANNER_L)
	flex -o $(SCANNER_SRC) $(SCANNER_L)

$(PARSER_SRC) $(PARSER_H): $(PARSER_Y)
	bison $(PARSER_Y)
	mv $(SOURCE_DIR)/*.hh $(INCLUDE_DIR)

$(SOURCE_DIR)/parser: $(OBJ_FILES)
$(TARGET): $(SOURCE_DIR)/parser
	cp $(SOURCE_DIR)/parser $(TARGET)

clean:
	rm -f $(TARGET) $(SOURCE_DIR)/parser $(OBJ_FILES)
	rm -f $(INCLUDE_DIR)/*.hh $(SCANNER_SRC) $(PARSER_H) $(PARSER_SRC)
