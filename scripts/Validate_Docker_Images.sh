#!/bin/bash

################################################################################
# Script Name: validate_docker_images.sh
# Description: Validates Docker images and provides error handling for common issues.
# Author: John Firnschild
# Written: 4/20/2024
# Version: 0.1.2
################################################################################


# Get a list of all Docker images along with their digests
image_digests=$(docker images --digests --format "{{.Repository}}:{{.Tag}}@{{.Digest}}")

# Iterate through each image digest
while IFS= read -r image_digest; do
    # Extract image name and digest
    image_name=$(echo "$image_digest" | awk -F "@" '{print $1}')
    image_digest_value=$(echo "$image_digest" | awk -F "@" '{print $2}')

    # Validate each image
    echo ""
    echo "-------------------------------------------------------"
    echo "Validating image: $image_name"

    # Inspect the image metadata and capture stdout and stderr separately
    image_info=$(docker inspect "$image_digest_value" 2>&1 > /dev/tty)
    exit_code=$?

    # Check if image information is obtained successfully
    if [ $exit_code -eq 0 ]; then
        # Image is valid if no error occurred
        echo "Image $image_name is valid"
        # Uncomment the line below to display detailed information about the image
        echo "$image_info"
    else
        # Handle errors if image information retrieval failed
        error_message=$(echo "$image_info" | tail -n 1)
        echo "Error: $error_message"
        echo "Image $image_name is invalid"

        # Provide explanations and resolutions for common error scenarios
        case "$error_message" in
            *"No such object"*)
                # Error indicates missing or corrupted image or layers
                echo "Explanation: This error often occurs when the Docker image or its associated layers are missing or corrupted."
                # Suggest removing or pulling the image
                echo "Resolution: To remove the invalid image, use the following command:"
                echo "   docker rmi $image_name"
                echo "To pull the image again from a reliable source, use the following command:"
                echo "   docker pull $image_name"
                ;;
            *)
                # General failure to retrieve metadata
                echo "Explanation: This error may indicate a general failure to retrieve metadata, possibly due to Docker daemon issues or network problems."
                # Suggest checking Docker daemon logs and network connectivity
                echo "Resolution: Check Docker daemon logs for any errors and ensure network connectivity to Docker repositories."
                ;;
        esac
    fi
done <<< "$image_digests"
