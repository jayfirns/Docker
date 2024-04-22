---
created: 2024-04-20T09:20
updated: 2024-04-21T13:42
---
Don't forget your password!!
Did we find a back door with [[Hacking a Docker??]]

```bash
docker-compose up -d
```

Here is a github [link](https://github.com/linuxserver/docker-kasm)



```yaml
services:
  kasm:
    image: lscr.io/linuxserver/kasm:latest
    container_name: kasm
    privileged: true
    environment:
      - KASM_PORT=443
      - DOCKER_HUB_USERNAME=john #optional
      - DOCKER_HUB_PASSWORD=admin #optional
      - DOCKER_MTU=1500 #optional
    volumes:
      - /path/to/data:/opt
      - /path/to/profiles:/profiles #optional
      - /dev/input:/dev/input #optional
      - /run/udev/data:/run/udev/data #optional
    ports:
      - 3000:3000
      - 443:443
    restart: unless-stopped
```

