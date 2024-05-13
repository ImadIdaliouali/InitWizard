#!/bin/bash

project_name="$1"
git="$2"

mkdir $project_name
cd $project_name

npm init -y

touch index.js
