# Version: 0.0.6

FROM ubuntu:20.04

# Avoiding user interaction with tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages including ping
RUN apt-get update && apt-get install -y \
    python3 \
    sudo \
    nano\
    wget \
    git \
    wireless-tools \
    net-tools \
    nmap \
    openssh-server \
    iputils-ping \
    && apt-get clean

# Start SSH service
RUN service ssh start

# Expose SSH port
EXPOSE 22

# Start Python HTTP server
CMD ["python3", "-m", "http.server", "8080"]
