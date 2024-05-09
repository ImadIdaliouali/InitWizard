#!/bin/bash

project_name="$1"
git="$2"

mkdir $project_name
cd $project_name

# Create directories
mkdir src public

# Create files
touch src/index.js public/index.html

# Create README.md
echo "# $project_name" > README.md

# Create package.json
echo '{
  "name": "'$project_name'",
  "version": "1.0.0",
  "description": "",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {}
}' > package.json

# Initialize Git repository if specified
if [ "$git" = "yes" ]; then
    git init
fi
