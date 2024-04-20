#!/bin/bash

# Docker_Management.sh
# Author: John Firnschild
# Written: 4/20/2024
# Version: 0.3.1

# Explanation:
# Function Inclusion: The extract_container_info function is included and used to process the output 
# of docker inspect when an image is successfully found.

# Error Handling: If docker inspect fails, it outputs the error directly.

# Use of extract_container_info: This function is called to provide 
# detailed info about the image when it exists.

# This script now not only checks whether images are valid but also 
# provides detailed container information for each valid image, enhancing 
# its usefulness in debugging and maintaining Docker images. 

# If you have specific criteria for how often or in what detail this 
# information should be provided, you can adjust the call to extract_container_info accordingly.

#!/bin/bash

# Function to extract relevant container information from docker inspect output
extract_container_info() {
    local inspect_output="$1"
    local image_id
    local created
    local env
    local maintainer
    local architecture
    local os

    image_id=$(echo "$inspect_output" | jq -r '.[0].Id')
    created=$(echo "$inspect_output" | jq -r '.[0].Created')
    env=$(echo "$inspect_output" | jq -r '.[0].Config.Env[]')
    maintainer=$(echo "$inspect_output" | jq -r '.[0].Author')
    architecture=$(echo "$inspect_output" | jq -r '.[0].Architecture')
    os=$(echo "$inspect_output" | jq -r '.[0].Os')

    # Print the extracted information
    echo "Container Information:"
    echo "Image ID: $image_id"
    echo "Created: $created"
    echo "Environment Variables:"
    if [ "$env" != "null" ]; then
        echo "$env" | while read -r line; do echo "   $line"; done
    else
        echo "   None provided"
    fi
    echo "Maintainer: ${maintainer:-None}"
    echo "Architecture: $architecture"
    echo "Operating System: $os"
}

# Get a list of all Docker images along with their digests, skipping entries with '<none>'
image_digests=$(docker images --digests --format "{{.Repository}}:{{.Tag}}@{{.Digest}}" | grep -v "<none>")

# Loop through each image digest retrieved
for image_name in $image_digests; do
    echo "------------------------------------------------------"
    echo "Validating image: $image_name"

    # Check if the image exists and capture the output and exit code
    if docker inspect "$image_name" > /dev/null 2>&1; then
        echo "Image $image_name is valid."
        inspect_output=$(docker inspect "$image_name")
        extract_container_info "$inspect_output"
    else
        echo "Image $image_name is invalid or corrupted."
        echo "Checking if any containers are using the image $image_name:"
        container_ids=$(docker ps -a --filter ancestor="$image_name" --format "{{.ID}}")

        if [ -n "$container_ids" ]; then
            echo "Error: The image is in use by one or more containers."
            echo "Containers using the image $image_name:"
            docker ps -a --filter ancestor="$image_name" --format "ID: {{.ID}}, Image: {{.Image}}, Name: {{.Names}}"

            echo "Please stop and remove the containers using the following commands:"
            for container_id in $container_ids; do
                echo "   docker stop $container_id"
                echo "   docker rm $container_id"
            done

            echo "After removing the containers, try removing the image again:"
            echo "   docker rmi $image_name"
        else
            echo "No containers are using this image."
            echo "This image may be corrupted or partially removed."
            echo "Try removing the image with:"
            echo "   docker rmi $image_name"
        fi
    fi
done
