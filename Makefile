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

.PHONY: all clean dataStructures eventLoop

all: dataStructures eventLoop $(EXEC)

# Build dataStructures library
dataStructures:
	$(MAKE) -C dataStructures -f dataStructures.mk

# Build eventLoop library
eventLoop:
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

# Link everything
$(EXEC): $(MAIN_OBJ) $(OBJECTS)
	$(CC) $^ $(LDFLAGS) -o $@

clean:
	$(MAKE) -C dataStructures -f dataStructures.mk clean
	$(MAKE) -C eventLoop -f eventLoop.mk clean
	rm -rf $(OBJ_DIR) $(EXEC)