---
created: 2024-04-21T14:14
updated: 2024-04-21T14:14
---




#ChatGPT 


```yaml
version: '3'
services:
  kasm_db:
    image: postgres
    container_name: kasm_db
    environment:
      POSTGRES_USER: kasmapp
      POSTGRES_PASSWORD: your_password
      POSTGRES_DB: kasm
    volumes:
      - ./db_data:/var/lib/postgresql/data
    restart: unless_stopped

  kasm:
    image: lscr.io/linuxserver/kasm:latest
    container_name: kasm_123
    privileged: true
    environment:
      - KASM_PORT=443
      - DOCKER_HUB_USERNAME= #optional
      - DOCKER_HUB_PASSWORD= #optional
      - DOCKER_MTU=1500 #optional
    volumes:
      - /path/to/data:/opt
      - /path/to/profiles:/profiles #optional
      - /dev/input:/dev/input #optional
      - /run/udev/data:/run/udev/data #optional
    ports:
      - 3000:3000
      - 443:443
    depends_on:
      - kasm_db
    restart: unless-stopped

```