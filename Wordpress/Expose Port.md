---
created: 2024-04-20T16:52
updated: 2024-04-20T17:05
---


#ChatGPT 

To access the front end of your WordPress site running in the Docker container, you'll need to expose the container's ports to the host system and then access it through a web browser. Here's a step-by-step guide:

1. **Expose Port**: Ensure that the Docker container's port 80 (assuming your WordPress site is running on the default HTTP port) is exposed to the host system. You can do this either by setting up port forwarding in your Docker run command or by editing the Docker Compose file if you're using Docker Compose.
    
2. **Find Host IP**: Determine the IP address of your Docker host machine. If you're running Docker Desktop, the host IP is typically `localhost` or `127.0.0.1`.

## Troubleshooting

It seems like your WordPress container is indeed running and the necessary files are present in the `/var/www/html` directory inside the container.

Given that, let's proceed with troubleshooting why you're unable to access the WordPress site. Here are a few steps to try:

1. **Check Container IP**: Sometimes containers are assigned IP addresses within the Docker network. You can find out the IP address of your running container using the following command:
```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' Johns_Home_Lab
```

- This command will output the IP address of your container. Try accessing your WordPress site using this IP address.


**Access WordPress Site**: Try accessing your WordPress site using the container's IP address `172.19.0.2`. Open a web browser on any device connected to the same network as your Ubuntu host machine, and enter the following URL in the address bar:

```
http://172.19.0.2
```
 - This should take you to the front end of your WordPress site.

2. **Check Docker Network**: Ensure that your Docker container is on the same network as your Ubuntu host machine. You can inspect the network settings of your container to verify this:
```bash
docker inspect Johns_Home_Lab | grep -i networkmode
```
- If the output shows a custom network mode, ensure that your Ubuntu host machine is also connected to that same network.

3. **Check Firewall**: As mentioned earlier, check if there are any firewall rules blocking incoming connections to port 80 on your Ubuntu host machine. You can temporarily disable the firewall or open port 80 for testing purposes.
  
4. **Check Hosts File**: Ensure that there are no entries in your Ubuntu host's `/etc/hosts` file that might be redirecting the hostname to a different IP address.

5. **Restart Container**: If none of the above steps resolve the issue, try stopping and starting the container again as you suggested earlier:
```bash
docker stop Johns_Home_Lab docker start Johns_Home_Lab
```
- After restarting the container, try accessing the WordPress site again using the appropriate IP address.

## If all that works...

1. **Access WordPress**: Open a web browser on your local machine and enter the IP address of your Docker host followed by the port number where WordPress is running. For example, if your Docker host IP is `localhost` and you've exposed port 80, you would enter `http://localhost` in the address bar.
    
2. **Access Database**: To access the WordPress database, you typically use a database management tool like phpMyAdmin or MySQL Workbench. If you haven't installed such a tool within your Docker container, you can install it separately and connect it to your MySQL database using the credentials specified in your `wp-config.php` file.

