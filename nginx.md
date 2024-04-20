---
tags:
  - docker
  - nginx
  - youtube
created: 2024-04-20T14:33
updated: 2024-04-20T14:33
---
#youtube[Techno Tim Docker Tutorial](https://www.youtube.com/watch?v=SnSH8Ht3MIc)

### Starting with [nginx](https://hub.docker.com/_/nginx)

Called the nginx lightweight 1.25.4-alpine release
Created a simple html file and referenced a png


You can expose ports with the following.  However this is not required.

```
EXPOSE 80
```

Confirm you have #docker installed

```bash
docker info
```

To simply build your new docker file, though this will build it without a name
```bash
docker build .
```

Check the #image
```bash
docker images

REPOSITORY               TAG       IMAGE ID       CREATED         SIZE
<none>                   <none>    af3b0fd83a34   8 seconds ago   45.5MB
```

to specify a name for your container use the following command.
- **Ensure you're in the correct directory, containing your docker file**

```bash
docker build -t hello-internet .
```

Now you can run #docker images again

```bash
docker images

REPOSITORY               TAG       IMAGE ID       CREATED          SIZE
hello-internet           latest    af3b0fd83a34   57 seconds ago   45.5MB
```

Now you have to create the #container

```bash
docker run -d -p 80:80 af3b0fd83a34
```

Verify it's running with #docker ps
here you can see the auto generated name of the container

```bash
ubuntu@upi:~/Docker/Docker$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                               NAMES
c0b21c48a51b   af3b0fd83a34   "/docker-entrypoint.…"   9 seconds ago   Up 8 seconds   0.0.0.0:80->80/tcp, :::80->80/tcp   determined_gates
```

Now you can navigate to the ip for [ubuntu](http://10.0.0.101/)

### How to stop the #container 

execute docker stop and the name of the container

```bash
docker stop determined_gates
```

Verify it has been stopped

```bash
ubuntu@upi:~/Docker/Docker$ docker stop determined_gates
determined_gates

ubuntu@upi:~/Docker/Docker$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

ubuntu@upi:~/Docker/Docker$ docker ps -a
CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS                      PORTS     NAMES
c0b21c48a51b   af3b0fd83a34             "/docker-entrypoint.…"   19 minutes ago   Exited (0) 16 seconds ago             determined_gates
06785a4fe489   kalilinux/kali-rolling   "bash"                   3 weeks ago      Exited (137) 5 days ago               happy_hugle
fce401e35366   hello-world              "/hello"                 3 weeks ago      Exited (0) 3 weeks ago                wizardly_sinoussi
```

- **Note the docker is not visible with a basic ps command
- You must use docker ps -a to identify all non active containers


# dockerignore file

### This is an example of using the dockerignore file properly

We've created a .dockerignore file in the root directory of the docker project and a cheesy password file inside the html directory

```bash
ubuntu@upi:~/Docker/Docker$ ls -la
total 32
drwxr-xr-x 3 ubuntu ubuntu 4096 Apr  4 21:26  .
drwxrwxr-x 4 ubuntu ubuntu 4096 Apr  4 20:54  ..
-rw-r--r-- 1 ubuntu ubuntu 6148 Apr  4 20:54  .DS_Store
-rw-rw-r-- 1 ubuntu ubuntu   21 Apr  4 21:25  .dockerignore
-rw-r--r-- 1 ubuntu ubuntu  145 Apr  4 20:54 'Docker Tutorial.md'
-rw-r--r-- 1 ubuntu ubuntu   62 Apr  4 20:54  Dockerfile
drwxr-xr-x 3 ubuntu ubuntu 4096 Apr  4 20:54  src

ubuntu@upi:~/Docker/Docker/src/html$ ls
img.png  index.html  password.txt
ubuntu@upi:~/Docker/Docker/src/html$ cat password.txt
my secret password
```

### For the purpose of this test we will rebuild the image

```bash
docker build -t security_test .
```

Using the exec command you're able to get inside the docker container
- we will execute this command to view our password file

```bash
ubuntu@upi:~/Docker/Docker$ docker ps -a

CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS                     PORTS                               NAMES
351bcc6a814a   3ac61d4e87f1             "/docker-entrypoint.…"   4 minutes ago    Up 4 minutes               0.0.0.0:80->80/tcp, :::80->80/tcp   trusting_newton

docker exec -it 351bcc6a814a /bin/sh

```

Exec into interactive mode and get into /bin/sh

```bash
/ # cd usr/share/nginx/html/
/usr/share/nginx/html # ls
50x.html      img.png       index.html    password.txt
/usr/share/nginx/html # cat password.txt
my secret password
/usr/share/nginx/html #
```

**Here we are able to see the password**

# implementing dockerignore

First remove the docker with the password file

```bash
ubuntu@upi:~/Docker/Docker$ docker stop trusting_newton
trusting_newton
ubuntu@upi:~/Docker/Docker$ docker rm trusting_newton
trusting_newton
```

Docker Ignore files are 'relative' to the file you want to ignore.  Since our password is found inside of /src/html we need to use a double ** to say ignore anywhere within the path

```bash
ubuntu@upi:~/Docker/Docker$ cat .dockerignore

**/password.txt
```


#learningopportunity Had a small issue with [[Docker Image Removal]] at this point, but we got it figured out.

After properly noting the password.txt file in the .dockerignore file, let's rebuild a new #container by calling the container id

```bash
ubuntu@upi:~/Docker/Docker$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                               NAMES
468a1d4b1e24   af3b0fd83a34   "/docker-entrypoint.…"   3 minutes ago   Up 3 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp   jolly_jones
```

We're able to get back in a new container with the following:

```bash
docker exec -it 468a1d4b1e24 /bin/sh
```

Once we're in...

```bash
ubuntu@upi:~/Docker/Docker$ docker exec -it 468a1d4b1e24 /bin/sh
/ # cd /usr/share/nginx/html/
/usr/share/nginx/html # ls
50x.html    img.png     index.html
/usr/share/nginx/html #
```

We see no password.txt file.