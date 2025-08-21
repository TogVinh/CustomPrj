# eventLoop Makefile

CC = g++
CFLAGS = -Wall -fPIC -Iinclude
LDFLAGS = -shared -pthread

SRC_DIR = src
OBJ_DIR = obj
LIB_DIR = ../lib
LIB_NAME = libeventLoop.so

SOURCES = $(wildcard $(SRC_DIR)/*.cpp)
OBJECTS = $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SOURCES))

.PHONY: all clean

all: $(LIB_DIR)/$(LIB_NAME)

# Create object directory if it doesn't exist
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Create lib directory if it doesn't exist
$(LIB_DIR):
	mkdir -p $(LIB_DIR)

# Compile source files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Create shared library
$(LIB_DIR)/$(LIB_NAME): $(OBJECTS) | $(LIB_DIR)
	$(CC) $(LDFLAGS) $^ -o $@

clean:
	rm -rf $(OBJ_DIR) $(LIB_DIR)/$(LIB_NAME)