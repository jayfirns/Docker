---
created: 2024-04-23T23:55
updated: 2024-04-24T15:59
---



Simplifying our approach to [[Ubuntu Desktop Docker]]
We'll try to make a server container from scratch...


# Docker

```dockerfile
# Version: 0.0.1

FROM ubuntu:20.04

# Avoiding user interaction with tzdata
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    git \
    nmap \
    && apt-get clean

CMD ["bash"]
```

# yaml

```yaml
# Version: 0.0.1

version: '3.8'
services:
  ubuntu-server:
    build: .
    # You can add ports, volumes, environment variables, etc., as needed

```



### Building and Running

1. Navigate to your project directory containing the Dockerfile and docker-compose.yml.
    
2. Run the command to build your Docker image:

```bash
docker-compose build
```

3. Once the build is complete, start the container:

```bash
docker-compose up -d
```

4. You can then access the running container using:

```bash
docker-compose exec ubuntu-server bash
```

### Benefits of Ubuntu Server Image

- **Lightweight**: Ubuntu Server images are smaller and more optimized compared to desktop images, making them faster to download and use in Docker.
- **Simplicity**: By avoiding the complexity of setting up a GUI, you streamline the Docker setup process, reducing the likelihood of encountering compatibility or configuration issues.
- **Focus on Server Use Cases**: Ubuntu Server images come pre-configured with packages and settings tailored for server applications, making them well-suited for running server-side services and applications in Docker containers.

This approach should provide a more straightforward and reliable Docker setup, focusing on server functionality rather than graphical desktop environments. If you have any specific server applications or services you want to run within the container, you can customize the Dockerfile further to include those dependencies.