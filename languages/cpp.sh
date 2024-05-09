#!/bin/bash

project_name="$1"
git="$2"

mkdir $project_name

cd $project_name

echo "#include <iostream>

using namespace std;

int main()
{
    cout << \"Hello World!\" << endl;
    return 0;
}" > main.cpp

echo "# $project_name" > README.md

if [ "$git" = "yes" ]; then
    git init
fi
