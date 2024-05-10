#!/bin/bash

project_name="$1"
git="$2"

mkdir $project_name

cd $project_name

clear
npm create vite@latest .
clear
# Initialize Git repository if specified
if [ "$git" = "yes" ]; then
    git init
fi
