---
created: 2024-04-20T16:06
updated: 2024-04-20T17:21
tags:
  - docker
---


This is the [docker hub](https://hub.docker.com/r/arm64v8/wordpress) for #wordpress and here is the [wiki](https://en.wikipedia.org/wiki/WordPress)

#ChatGPT 


**Setting Up WordPress with Docker on Home Network**

1. **Create Docker Network**

```bash
docker network create johns-network
```

Creates a Docker network named "johns-network" for isolating containers on the home network.

2. **Run WordPress Container**

```bash
docker run --name Johns_Home_Lab --network johns-network -d arm64v8/wordpress
```

Starts a WordPress container named "Johns_Home_Lab" using the arm64v8/wordpress image and connects it to the "johns-network" Docker network.

By following these steps, you can set up a WordPress site on your home network using Docker.

## docker ps

```bash
ubuntu@upi:~/Docker$ docker ps
CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS          PORTS     NAMES
a1429bcb6274   arm64v8/wordpress   "docker-entrypoint.s…"   31 minutes ago   Up 31 minutes   80/tcp    Johns_Home_Lab
```


# Start and Stop the Container

```bash
docker stop Johns_Home_Lab
```

1. **Stop the Container**: Since you've already stopped the container using `docker stop Johns_Home_Lab`, we'll proceed to start it again.


1. **Check Current Container Status**: Before proceeding, let's make sure the container is not running. You can use the `docker ps -a` command to list all containers, including those that are stopped.
```bash
docker ps -a
```

- If you see the `Johns_Home_Lab` container listed with a status of `Exited`, it means it's not currently running.

```bash
ubuntu@upi:~/Docker$ docker ps -a
CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS                     PORTS     NAMES
a1429bcb6274   arm64v8/wordpress        "docker-entrypoint.s…"   38 minutes ago   Exited (0) 5 minutes ago             Johns_Home_Lab
06785a4fe489   kalilinux/kali-rolling   "bash"                   6 weeks ago      Exited (137) 3 weeks ago             happy_hugle
fce401e35366   hello-world              "/hello"                 6 weeks ago      Exited (0) 6 weeks ago               wizardly_sinoussi
```


2. **Start the Container with Port Mapping**: We'll start the container again, this time ensuring that port 80 on the container is mapped to port 80 on the host machine.

```bash
docker run -p 80:80 --name Johns_Home_Lab --network johns-network -d arm64v8/wordpress
```

- This command starts the container `Johns_Home_Lab`, maps port 80 of the container to port 80 of the host machine, and connects it to the `johns-network` Docker network.

## Issue!!

```bash
ubuntu@upi:~/Docker$ docker run -p 80:80 --name Johns_Home_Lab --network johns-network -d arm64v8/wordpress
docker: Error response from daemon: Conflict. The container name "/Johns_Home_Lab" is already in use by container "a1429bcb6274293427ff570d2d3b9a12f2490d46bc0ac8955e98a74807532cbe". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'.
```


  
It appears that the container name "Johns_Home_Lab" is already in use by a container that is currently running. This means that the container with that name needs to be stopped and removed before we can start a new one with the same name.

To resolve this, we'll first stop and remove the existing container, and then we'll start a new one with the correct port mapping. Here's how you can proceed:

1. **Stop and Remove the Existing Container**: We'll stop and remove the existing container using its ID or name.
```bash
docker stop a1429bcb6274293427ff570d2d3b9a12f2490d46bc0ac8955e98a74807532cbe 
docker rm a1429bcb6274293427ff570d2d3b9a12f2490d46bc0ac8955e98a74807532cbe
```

2. **Start the New Container with Port Mapping**: Now, we'll start a new container with the correct port mapping.

```bash
docker run -p 80:80 --name Johns_Home_Lab --network johns-network -d arm64v8/wordpress
```

- This command starts the container `Johns_Home_Lab`, maps port 80 of the container to port 80 of the host machine, and connects it to the `johns-network` Docker network.



    
2. **Access the WordPress Site**: With the container running and port mapping configured, you should be able to access the WordPress site's front end using the host machine's IP address. Since you mentioned your host machine's IP address is `10.0.0.101`, you should be able to access the site by entering `http://10.0.0.101` in your web browser's address bar.


## What does the below do??

- If you need to access the WordPress container for any reason, you can do so using the following command:

```bash
docker exec -it Johns_Home_Lab /bin/bash
```

This command will open a Bash shell inside the running container named "Johns_Home_Lab", allowing you to perform administrative tasks or troubleshoot if needed.




- If you'd like to be able to access the instance from the host without the container's IP, standard port mappings can be used

```bash
docker run --name some-wordpress -p 8080:80 -d arm64v8/wordpress
```


## Docker Secrets

As an alternative to passing sensitive information via environment variables, `_FILE` may be appended to the previously listed environment variables, causing the initialization script to load the values for those variables from files present in the container. In particular, this can be used to load passwords from Docker secrets stored in `/run/secrets/<secret_name>` files. For example:

```bash
docker run --name some-wordpress -e WORDPRESS_DB_PASSWORD_FILE=/run/secrets/mysql-root ... -d arm64v8/wordpress:tag
```