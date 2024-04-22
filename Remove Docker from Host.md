---
created: 2024-04-22T11:51
updated: 2024-04-22T11:55
---




Let's proceed with removing Docker from your server and reinstalling it to ensure a clean installation. Here are the steps to do so:

1. **Stop Docker Services**: First, stop any running Docker services:

```bash
sudo systemctl stop docker
```

2. **Remove Docker Packages**: Remove Docker packages using the package manager. The exact command may vary depending on how Docker was installed on your system. If Docker was installed using APT, you can remove it with:

```bash
sudo apt-get purge docker-ce docker-ce-cli containerd.io
```

3. **Delete Docker Configuration and Data**: Optionally, you can delete Docker's configuration and data directories to ensure a clean slate. Be cautious with this step as it will delete all Docker-related data, including images and containers:

```bash
sudo rm -rf /etc/docker /var/lib/docker
```

4. **Remove Docker Group**: If the `docker` group was created previously and you want to remove it, you can do so with:

```bash
sudo groupdel docker
```

    
5. **Remove Docker Executable**: If Docker was installed using a package, the executable might still exist. Remove it if necessary:

```bash
sudo rm /usr/bin/docker
```


6. **Remove Docker Repository**: If Docker was installed using a repository, remove the Docker repository:

```bash
sudo rm /etc/apt/sources.list.d/docker.list
```

7. **Update Package Lists**: Update the package lists to ensure you get the latest version of Docker during the reinstall:

```bash
sudo apt-get update
```

    
8. **Reinstall Docker**: Follow the appropriate installation instructions to reinstall Docker on your system. You can use the official Docker documentation for Ubuntu: [[Install Docker on Ubuntu]].
