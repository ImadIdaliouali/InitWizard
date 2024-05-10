#!/bin/bash

project_name="$1"
git="$2"

mkdir $project_name

cd $project_name

npm create vite@latest $project_name

# Initialize Git repository if specified
if [ "$git" = "yes" ]; then
    git init
fi
