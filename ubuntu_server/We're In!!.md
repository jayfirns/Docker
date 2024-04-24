---
created: 2024-04-24T00:19
updated: 2024-04-24T15:59
---

### M1 Depolyment

```zsh
cd /Users/johnfirnschild/Documents/HomeLab/Docker_Desktop/ubuntu_server
```

```bash
docker-compose exec ubuntu-server bash
```

### Kali Deployment

```bash
/home/kali/Documents/docker_deploy/ubuntu_server
```

- Must log in with root

```bash
sudo docker-compose exec ubuntu-server bash
```

We're In!!

```bash
WARN[0000] /Users/johnfirnschild/Documents/HomeLab/Docker_Desktop/ubuntu_server/docker-compose.yaml: `version` is obsolete 
root@7769061e2dbc:/# ls
bin  boot  dev  etc  home  lib  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@7769061e2dbc:/# pwd
/
root@7769061e2dbc:/# whoami
root
root@7769061e2dbc:/# ping 10.0.0.52
bash: ping: command not found
root@7769061e2dbc:/# 
```


It looks like you successfully accessed the terminal inside your `ubuntu-server` container, and you are currently logged in as the root user.

Regarding the issue with the `ping` command not being found, it seems that the `ping` utility is not installed in the Ubuntu image used for your Docker container. This can happen with minimal Ubuntu images, as they might not include all commonly used networking tools by default.

To resolve this issue, you can install the `iputils-ping` package, which provides the `ping` command, inside your Docker container.

You can install it using the `apt-get` package manager. Here's how you can do it:

```bash
apt-get update apt-get install -y iputils-ping
```


After installing the package, you should be able to use the `ping` command as expected. You can try again after installing the package:

```bash
ping 10.0.0.52
```

This command should now work as expected and allow you to ping the specified IP address.