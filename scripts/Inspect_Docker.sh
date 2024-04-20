#!/bin/bash

# Author: John Firnschild
# Written: 4/20/2024
# Version: 0.0.2

# This script will iterate over each Docker image, run docker inspect 
# for each image, and extract relevant information as before. It will 
# then print out the information for each image separately.

# Get a list of all Docker images along with their digests
image_digests=$(docker images --digests --format "{{.Repository}}:{{.Tag}}@{{.Digest}}")

# Iterate over each image and extract relevant information
echo "$image_digests" | while IFS= read -r image_digest; do
    # Extract image name and tag
    image_name=$(echo "$image_digest" | cut -d ':' -f 1)
    image_tag=$(echo "$image_digest" | cut -d ':' -f 2 | cut -d '@' -f 1)

    # Run docker inspect command and store the output in a variable
    inspect_output=$(docker inspect "$image_name:$image_tag")

    # Extract relevant information from the output using grep and sed
    image_id=$(echo "$inspect_output" | grep -oP '(?<="Id": ")[^"]+' | head -n 1)
    created=$(echo "$inspect_output" | grep -oP '(?<="Created": ")[^"]+' | head -n 1)
    env=$(echo "$inspect_output" | grep -oP '(?<="Env": \[)[^]]+' | sed 's/^[[:space:]]*//;s/"//g' | tr ',' '\n')
    maintainer=$(echo "$inspect_output" | grep -oP '(?<="maintainer": ")[^"]+' | head -n 1)
    architecture=$(echo "$inspect_output" | grep -oP '(?<="Architecture": ")[^"]+' | head -n 1)
    os=$(echo "$inspect_output" | grep -oP '(?<="Os": ")[^"]+' | head -n 1)

    # Print the extracted information
    echo "Container Information for $image_name:$image_tag:"
    echo "Image ID: $image_id"
    echo "Created: $created"
    echo "Environment Variables:"
    echo "$env" | while read -r line; do echo "   $line"; done
    echo "Maintainer: $maintainer"
    echo "Architecture: $architecture"
    echo "Operating System: $os"
    echo "---------------------------------------"
done
