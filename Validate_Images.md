---
created: 2024-04-20T09:39
updated: 2024-04-20T14:34
tags:
  - docker
---





[[Script List]]
[[Active Docker Containers]]

This script will iterate through all Docker images you have locally, and for each image, it will run a dummy container using that image. If the container runs successfully (i.e., the validation command within the container exits with status 0), it considers the image valid; otherwise, it considers it invalid.

Please note that this approach doesn't guarantee comprehensive validation of the images but provides a basic check for their viability. For more thorough validation, you might need to implement additional checks specific to your use case.