---
created: 2024-04-23T22:44
updated: 2024-04-23T23:46
---
Check out the [[HomeLab/Docker_Desktop/ubuntu_desktop/README|README]]

Let's clarify the process to ensure everything is set up correctly from building your Docker image to running the Docker container with all necessary configurations. Here's a step-by-step guide based on the modifications and files we discussed:

### Step 1: Prepare Your Files

You'll need the following files properly configured and saved in your project directory:

1. **Dockerfile**: This file contains the instructions for building the Docker image, including setting up the environment, installing necessary packages, adding users, and copying over any required scripts.
    
2. **docker-compose.yml**: This file defines the services, networks, and volumes for your Docker environment. It specifies how to run your container, including port mappings and environment variables.
    
3. **start.sh**: This script is responsible for starting the X server, the VNC server, and the XFCE desktop environment. This should be set up as an entry point or command script within your Docker container.
    

Here’s what each file should generally contain based on our previous discussions:

# Dockerfile

```dockerfile
# Version: 0.0.5

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    x11vnc \
    xvfb \
    wget \
    git \
    nmap \
    sudo \
    && apt-get clean

RUN useradd -m ubuntu -s /bin/bash && \
    echo "ubuntu:yourpassword" | chpasswd && \
    adduser ubuntu sudo

RUN mkdir /home/ubuntu/.vnc && \
    x11vnc -storepasswd yourpassword /home/ubuntu/.vnc/passwd && \
    chown -R ubuntu:ubuntu /home/ubuntu/.vnc

USER ubuntu
WORKDIR /home/ubuntu
# RUN git clone [your-repository-url]

COPY start.sh /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]

```

- ### Key Changes for Version: 0.0.3

	- **Remove `sudo` from the `chmod` command**: Since Docker builds run as root by default, you can directly change file permissions without needing `sudo`.
	- **User and Permissions**: After changing permissions, the Dockerfile switches to the user `ubuntu`. Ensure all necessary permissions and ownerships are set before switching to the non-root user.

# yaml

```yaml
version: '3.8'
services:
  ubuntu-desktop:
    build: .
    ports:
      - "5900:5900"  # Expose VNC port to access xfce desktop
    volumes:
      - ./example-repo:/home/ubuntu/example-repo
    environment:
      DISPLAY: :1

```

# start.sh

```bash
#!/bin/bash

Xvfb :1 -screen 0 1024x768x16 &
export DISPLAY=:1
sleep 5 # Give Xvfb some time to start
x11vnc -display :1 -nopw -listen 0.0.0.0 -xkb -forever -shared &
sleep 3 # Give x11vnc some time to start
startxfce4
```


### Building and Running Your Docker Container

1. **Build the Docker Image**: Navigate to your project directory where your `Dockerfile` and `docker-compose.yml` are located, then run:

```bash
docker-compose build
```

- This command builds the Docker image based on the instructions in your `Dockerfile`.

2. **Run the Docker Container**: Once the build is complete, you can start the container using:

```bash
docker-compose up -d
```

- This command starts the Docker container in detached mode. The `start.sh` script is automatically executed as the container starts because it’s specified in the `CMD` directive in your `Dockerfile`.
    

### Step 3: Connect to Your Docker Container

- **Using a VNC Client**: Open your VNC client and connect to `localhost:5900`. You should be prompted to enter the VNC password (which is "yourpassword" as specified earlier), and then you should see the XFCE desktop environment.

This setup automates the execution of the `start.sh` script within the container environment, so there's no need to manually run `./start.sh` from the host machine. Everything required to start and manage the X server and desktop environment is handled inside the container once it's running.

### So, does docker build capture the start.sh that exists in the project directory?

#ChatGPT

Yes, Docker does capture the `start.sh` script from your project directory when it builds the image, provided you have the appropriate `COPY` instruction in your Dockerfile to include the script into the image. The `COPY` instruction is crucial as it tells Docker to take the file from your host machine (the machine where you're running Docker) and include it into the Docker image at a specified location.

Here’s a quick rundown on how that works with the Dockerfile setup:

### How `COPY` Works in Dockerfile

In the Dockerfile, you would typically have a line like this:

```dockerfile
COPY start.sh /usr/local/bin/start.sh
```


This line does the following:

1. **Source (`start.sh`)**: Specifies the source file on your host system. This should be relative to the build context, which is usually the directory where the Dockerfile is located unless specified otherwise.
    
2. **Destination (`/usr/local/bin/start.sh`)**: Specifies the destination path inside the Docker image. This is where the file will be placed within the file system of the built image.
    

When you run `docker-compose build` or `docker build`, Docker processes each instruction in the Dockerfile. When it processes the `COPY` instruction, it takes the `start.sh` file from your project directory and copies it into the image at the location `/usr/local/bin/start.sh`. Once the image is built, this script is then part of the image and can be executed within any container that is started from this image.

### Ensuring Successful Copy

To ensure that the `start.sh` script is correctly included and functional within your Docker image:

- **File Location**: Ensure that the `start.sh` file is in the correct location relative to your Dockerfile. If your Dockerfile is in a subdirectory, you need to adjust the path accordingly or change your Docker context when you build the image.
    
- **File Permissions**: After copying the script into the Docker image, it’s a good practice to set the appropriate execution permissions. You’ve already addressed this with:

```dockerfile
RUN sudo chmod +x /usr/local/bin/start.sh
```

- This command sets the executable permission on the script, ensuring that it can be run within the container.

- **Execution in CMD or ENTRYPOINT**: Your Dockerfile ends with a `CMD` instruction that specifies the script as the command to be executed when a container is started from the image:

```bash
CMD ["/usr/local/bin/start.sh"]
```

- This ensures that the `start.sh` script runs automatically every time a container is spun up from the image, handling all necessary setup for the X server and the desktop environment.

With these elements correctly configured, your `start.sh` script should seamlessly integrate into your Docker setup and function as intended when you launch your container.