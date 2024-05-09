#!/bin/bash

project_name="$1"
git="$2"

mkdir "$project_name"

cd "$project_name"

echo "#include <stdio.h>

int main()
{
    printf(\"Hello World!\n\");
    return 0;
}" > main.c

echo "# $project_name" > README.md

if [ "$git" = "yes" ]; then
    git init
fi
