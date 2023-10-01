#!/bin/bash

# Find all YAML or YML files in the current directory and its subdirectories
yaml_files=$(find . -type f -name "*.yml" -o -name "*.yaml")

# Check if any YAML files were found
if [ -n "$yaml_files" ]; then
    for file in $yaml_files; do
        echo "Enabling $file"
        docker-compose -f "$file" up -d
    done
else
    echo "No YAML files found in the current directory."
fi
