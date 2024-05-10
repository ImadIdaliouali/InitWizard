#!/bin/bash

project_name="$1"
git="$2"

mkdir $project_name
cd $project_name

# Create include, src, docs, and bin directories
mkdir include src docs bin

# Create .h file inside include directory
echo "#ifndef ${project_name^^}_H
#define ${project_name^^}_H

#include <stdio.h>

#endif" > include/$project_name.h

# Create .c files inside src directory
echo "#include \"../include/$project_name.h\"
#include <stdio.h>

int main() {
    printf(\"Hello, world!\\n\");
    return 0;
}" > src/main.c

# Create Makefile
echo "CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -Iinclude
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
SRC = \$(wildcard \$(SRC_DIR)/*.c)
OBJ = \$(SRC:\$(SRC_DIR)/%.c=\$(OBJ_DIR)/%.o)
EXECUTABLE = \$(BIN_DIR)/$project_name

all: \$(EXECUTABLE)

\$(EXECUTABLE): \$(OBJ)
\t\$(CC) \$(CFLAGS) \$^ -o \$@

\$(OBJ_DIR)/%.o: \$(SRC_DIR)/%.c
\t\$(CC) \$(CFLAGS) -c \$< -o \$@

clean:
\trm -rf \$(OBJ_DIR)/* \$(BIN_DIR)/*" > Makefile

# Create README.md
echo "# $project_name" > README.md

if [ "$git" = "Yes" ]; then
    git init
fi
