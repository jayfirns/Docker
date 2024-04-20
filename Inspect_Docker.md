---
created: 2024-04-20T15:17
updated: 2024-04-20T15:58
tags:
  - docker
  - image
---
[[script_list]]
[[Active_Containers]]
[[Manage_Docker]]
[[Docker_Management]]

Here is the [[Inspect_Docker_result]]

## Docker Image Digest Summary Script

This script retrieves a list of all Docker images along with their digests, then iterates over each image to extract relevant information such as image ID, creation date, environment variables, maintainer, architecture, and operating system.

### Steps:

1. **Retrieve Image Digests:**
   - Use `docker images` command with `--digests` option to get image list including digests.
   
2. **Iterate and Extract Information:**
   - Iterate over each image digest.
   - Extract image name and tag.
   - Run `docker inspect` command to retrieve detailed information.
   - Extract relevant details such as image ID, creation date, environment variables, maintainer, architecture, and operating system.
   
3. **Print Information:**
   - Print extracted information for each image in a structured format.

### Script Breakdown:

- **Variables:**
  - `image_digests`: Stores all Docker images along with their digests.

- **Iterative Processing:**
  - Loops through each image digest.
  - Extracts details using various commands (`grep`, `sed`, `cut`).
  
- **Output:**
  - Prints extracted information for each image including:
    - Image ID
    - Creation Date
    - Environment Variables
    - Maintainer
    - Architecture
    - Operating System
