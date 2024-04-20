#!/bin/bash

# Manage_Docker.sh
# Author: John Firnschild
# Written: 4/20/2024
# Version: 0.0.2

# Get Docker Container Information: Write a function to extract relevant 
# information about Docker containers using the docker inspect command.

# Validate Docker Images: Iterate through all Docker images, check their 
# validity, and provide instructions for resolution.

# Display Results: Present the information about Docker containers 
# and image validation results clearly for the user.

# Provide Actionable Instructions: Ensure that any identified issues 
# come with clear explanations and actionable steps for resolution.

# This script combines the functionalities of inspecting Docker 
# containers and validating Docker images into a single script. 
# It iterates through all Docker images, validates their integrity, 
# and provides instructions for resolution. Additionally, it inspects 
# the specific "security_upgrade" container and displays relevant information about it.

# Function to extract relevant container information from docker inspect output
extract_container_info() {
    local inspect_output="$1"
    local image_id
    local created
    local env
    local maintainer
    local architecture
    local os

    image_id=$(echo "$inspect_output" | grep -oP '(?<="Id": ")[^"]+' | head -n 1)
    created=$(echo "$inspect_output" | grep -oP '(?<="Created": ")[^"]+' | head -n 1)
    env=$(echo "$inspect_output" | grep -oP '(?<="Env": \[)[^]]+' | sed 's/^[[:space:]]*//;s/"//g' | tr ',' '\n')
    maintainer=$(echo "$inspect_output" | grep -oP '(?<="maintainer": ")[^"]+' | head -n 1)
    architecture=$(echo "$inspect_output" | grep -oP '(?<="Architecture": ")[^"]+' | head -n 1)
    os=$(echo "$inspect_output" | grep -oP '(?<="Os": ")[^"]+' | head -n 1)

    # Print the extracted information
    echo "Container Information:"
    echo "Image ID: $image_id"
    echo "Created: $created"
    echo "Environment Variables:"
    echo "$env" | while read -r line; do echo "   $line"; done
    echo "Maintainer: $maintainer"
    echo "Architecture: $architecture"
    echo "Operating System: $os"
}

# Get a list of all Docker images along with their digests
image_digests=$(docker images --digests --format "{{.Repository}}:{{.Tag}}@{{.Digest}}")

# Iterate through each image digest
while IFS= read -r image_digest; do
    # Extract image name and digest
    image_name=$(echo "$image_digest" | awk -F "@" '{print $1}')
    image_digest_value=$(echo "$image_digest" | awk -F "@" '{print $2}')

    echo "------------------------------------------------------"
    echo "Validating image: $image_name"

    # Inspect the image metadata and capture stdout and stderr separately
    image_info=$(docker inspect "$image_digest_value" 2>&1 > /dev/tty)
    exit_code=$?

    # Check if the image information is obtained successfully
    if [ $exit_code -eq 0 ]; then
        echo "Image $image_name is valid"
        # Uncomment the line below to display detailed information about the image
        # echo "$image_info"
    else
        error_message=$(echo "$image_info" | tail -n 1)
        echo "Error: $error_message"
        echo "Image $image_name is invalid"

        # Provide explanations and resolutions for common error scenarios
        case "$error_message" in
            *"No such object"*)
                echo "Explanation: This error often occurs when the Docker image or its associated layers are missing or corrupted."
                echo "Resolution: To remove the invalid image, use the following command:"
                echo "   docker rmi $image_name"
                echo "To pull the image again from a reliable source, use the following command:"
                echo "   docker pull $image_name"
                ;;
            *)
                echo "Explanation: This error may indicate a general failure to retrieve metadata, possibly due to Docker daemon issues or network problems."
                echo "Resolution: Check Docker daemon logs for any errors and ensure network connectivity to Docker repositories."
                ;;
        esac
    fi
done <<< "$image_digests"

# Iterate through all containers and display relevant information for each one
echo "------------------------------------------------------"
echo "Inspecting all containers:"

# Get a list of all container IDs
container_ids=$(docker ps -a -q)

# Check if there are any containers
if [ -z "$container_ids" ]; then
    echo "No containers found."
else
    # Loop through each container ID
    for container_id in $container_ids; do
        container_name=$(docker inspect --format='{{.Name}}' "$container_id" | sed 's/^\///')
        echo "Container: $container_name"
        container_info=$(docker inspect "$container_id")
        if [ $? -eq 0 ]; then
            extract_container_info "$container_info"
        else
            echo "Error: Failed to inspect container $container_name. Please ensure it exists and try again."
        fi
        echo "------------------------------------------------------"
    done
fi
