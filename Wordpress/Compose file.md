---
created: 2024-04-20T17:58
updated: 2024-04-20T18:04
---



```yaml
version: '3.1'

services:

  wordpress:
    image: wordpress
    restart: always
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: john
      WORDPRESS_DB_PASSWORD: admin_password
      WORDPRESS_DB_NAME: wp_homelab
    volumes:
      - wordpress:/var/www/html

  db:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_DATABASE: wp_homelab
      MYSQL_USER: john
      MYSQL_PASSWORD: admin_password
      MYSQL_RANDOM_ROOT_PASSWORD: '1'
    volumes:
      - db:/var/lib/mysql

volumes:
  wordpress:
  db:

```


  
To use the Docker Compose file, you'll need to follow these steps:

1. **Save the Compose File**: Save the Docker Compose file with a `.yaml` or `.yml` extension, such as `docker-compose.yaml` or `docker-compose.yml`.
    
2. **Navigate to the Directory**: Open a terminal or command prompt and navigate to the directory where you saved the Docker Compose file.
    
3. **Run Docker Compose**: Once you're in the directory containing the Compose file, run the following command to start the containers defined in the Compose file:
```bash
docker-compose up -d
```
- This command will build (if necessary) and start the services defined in the Compose file in detached mode (`-d`), meaning they'll run in the background.
    
4. **Access Your WordPress Site**: After running the `docker-compose up` command, your WordPress site should be accessible. Open a web browser and go to `http://localhost:8080` to view your WordPress site. If you're using a different host or port, replace `localhost:8080` with the appropriate address and port.
    
5. **Manage Containers**: You can manage your Docker containers using Docker Compose commands. For example:
    
    - To stop the containers: `docker-compose stop`
    - To start the stopped containers: `docker-compose start`
    - To remove the containers: `docker-compose down`


6. **Customization**: If you need to make changes to the Compose file (e.g., modifying environment variables), edit the file with a text editor and then run `docker-compose up -d` again to apply the changes.
    

By following these steps, you'll be able to deploy and manage your WordPress site and MySQL database using Docker Compose.

ChatGPT can make mistakes. Consider checking important information.