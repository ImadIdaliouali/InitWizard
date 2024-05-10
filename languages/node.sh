#!/bin/bash

project_name="$1"
git="$2"

mkdir $project_name
cd $project_name

npm init -y

touch index.js

# Create README.md
echo "# $project_name" > README.md

# Initialize Git repository if specified
if [ "$git" = "Yes" ]; then
    git init
fi
