#!/bin/bash

project_name="$1"
git="$2"

mkdir $project_name
cd $project_name

# Create include, src, docs, and bin directories
mkdir include src docs bin

# Create .hpp file inside include directory
echo "#ifndef ${project_name^^}_HPP
#define ${project_name^^}_HPP

#include <iostream>

#endif" > include/$project_name.hpp

# Create .cpp files inside src directory
echo "#include \"../include/$project_name.hpp\"
#include<iostream>
using namespace std;
int main() {
    cout << \"Hello World!\" << std;
    return 0;
}" > src/main.cpp

# Create Makefile
echo "CC = g++
CFLAGS = -std=c++11 -Iinclude
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
SRC = \$(wildcard \$(SRC_DIR)/*.cpp)
OBJ = \$(SRC:\$(SRC_DIR)/%.cpp=\$(OBJ_DIR)/%.o)
EXECUTABLE = \$(BIN_DIR)/$project_name

all: \$(EXECUTABLE)

\$(EXECUTABLE): \$(OBJ)
\t\$(CC) \$(CFLAGS) \$^ -o \$@

\$(OBJ_DIR)/%.o: \$(SRC_DIR)/%.cpp
\t\$(CC) \$(CFLAGS) -c \$< -o \$@

clean:
\trm -rf \$(OBJ_DIR)/* \$(BIN_DIR)/*" > Makefile

# Create README.md
echo "# $project_name" > README.md

if [ "$git" = "yes" ]; then
    git init
fi
