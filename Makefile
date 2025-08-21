# Top-level Makefile

CC = g++
CFLAGS = -Wall -Iinclude -IdataStructures/include -IeventLoop/include
LDFLAGS = -Llib -ldataStructures -leventLoop -Wl,-rpath,lib

SRC_DIR = src
OBJ_DIR = obj
LIB_DIR = lib

# Source files in src directory
SOURCES = $(wildcard $(SRC_DIR)/*.cpp)
OBJECTS = $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SOURCES))

# Main program
MAIN_SRC = main.cpp
MAIN_OBJ = $(OBJ_DIR)/main.o
EXEC = shop

# Shared library dependencies
DATASTRUCTURES_LIB = $(LIB_DIR)/libdataStructures.so
EVENTLOOP_LIB = $(LIB_DIR)/libeventLoop.so

.PHONY: all clean dataStructures eventLoop

all: $(EXEC)

# Build dataStructures library
dataStructures: $(DATASTRUCTURES_LIB)
$(DATASTRUCTURES_LIB):
	$(MAKE) -C dataStructures -f dataStructures.mk

# Build eventLoop library
eventLoop: $(EVENTLOOP_LIB)
$(EVENTLOOP_LIB):
	$(MAKE) -C eventLoop -f eventLoop.mk

# Create object directory if it doesn't exist
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Compile main program
$(MAIN_OBJ): $(MAIN_SRC) | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Compile source files in src
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Link everything, ensure libraries are built first
$(EXEC): $(MAIN_OBJ) $(OBJECTS) $(DATASTRUCTURES_LIB) $(EVENTLOOP_LIB)
	$(CC) $(MAIN_OBJ) $(OBJECTS) $(LDFLAGS) -o $@

clean:
	$(MAKE) -C dataStructures -f dataStructures.mk clean
	$(MAKE) -C eventLoop -f eventLoop.mk clean
	rm -rf $(OBJ_DIR) $(EXEC)