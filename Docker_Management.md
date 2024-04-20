---
created: 2024-04-20T15:24
updated: 2024-04-20T15:59
---


[[script_list]]
[[Active_Containers]]
[[Inspect_Docker]]
[[Manage_Docker]]


Here is the [[Docker_Management_result]]
# Docker_Management

## Function: extract_container_info
This function extracts relevant information about a Docker container from the output of `docker inspect`. It extracts:
- Image ID
- Created timestamp
- Environment variables
- Maintainer
- Architecture
- Operating System

## Main Script Execution
1. Retrieve a list of all Docker images along with their digests, excluding entries with `<none>`.
2. Loop through each image digest retrieved.
   - Validate the image.
     - If valid, display its information using `extract_container_info`.
     - If invalid or corrupted:
       - Check if any containers are using the image.
       - If containers are using the image:
         - Display container information.
         - Provide commands to stop and remove the containers.
         - Prompt to remove the image after removing the containers.
       - If no containers are using the image:
         - Prompt to remove the image.
