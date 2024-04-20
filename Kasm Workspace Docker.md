---
created: 2024-04-20T09:20
updated: 2024-04-20T09:22
---



Today we're installing [Kasm Docker](https://hub.docker.com/r/kasmweb/ubuntu-focal-dind)

```bash
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/ubuntu-focal-dind:1.14.0
```

- The container is now accessible via a browser : https://IP_OF_SERVER:6901

- User : kasm_user
- Password: password

**Please note that some functionality, such as audio, uploads, downloads, and microphone pass-through, is only available when using Kasm Workspaces for orchestration.**

