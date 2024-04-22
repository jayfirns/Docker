---
created: 2024-04-20T16:48
updated: 2024-04-20T23:49
tags:
  - docker
---
# Stop an Active Container

1. **Stop the container**: First, you need to stop the container. You can do this by using the `docker stop` command followed by the container ID or name. In your case, the container ID is `468a1d4b1e24`, and the name is `jolly_jones`.

```bash
docker stop jolly_jones
```

- Or you can use the container ID: 

```bash
docker stop 468a1d4b1e24
```
    
2. **Remove the container**: Once the container is stopped, you can remove it using the `docker rm` command followed by the container ID or name.
```bash
docker rm jolly_jones
```
   
   - Or using the container ID:
   
```bash
docker rm 468a1d4b1e24
```

After running these commands, the container should be stopped and removed from your system. You can then verify that it's no longer running by running `docker ps` again. Once the old container is removed, you should be able to access your WordPress site running on the new container without any conflicts.


```bash
docker system prune --all
```

