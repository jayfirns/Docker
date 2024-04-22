---
created: 2024-04-21T13:23
updated: 2024-04-21T14:22
---
Working on [[Identify Docker Volumes#grep the result]] documentation and found this...

After running `docker ps -a`

I was able to retrieve the following sensitive information from my Wordpress site

                "WORDPRESS_DB_HOST=db",
                "WORDPRESS_DB_USER=john",
                "WORDPRESS_DB_PASSWORD=admin_password",
                "WORDPRESS_DB_NAME=wp_homelab",

using the following

```bash
docker inspect <container_id_or_name>
```

Rather than pointing to mounts, look for the appropriate details for credential harvesting

```bash
docker inspect <container_id_or_name> | grep -A 11 '"Mounts":'
```


### 1. **Confirm Database Setup**

First, it’s important to clarify how Kasm is meant to manage its data. If the database is supposed to be internal to the Kasm container, you won't find a separate container for PostgreSQL. If it's external, then the Docker Compose file should have included it, unless it's managed elsewhere not visible in your current Docker environment.

### 2. **Check Internal Database Access**

Since we see no separate database service, the next step is to check inside the `kasm_123` container:

- **Access the container**:
    
    bashCopy code
    
    `sudo docker exec -it kasm_123 bash`
    
- **Look for PostgreSQL**: Inside the container, try locating PostgreSQL or any database-related tools or files.
    
    bashCopy code
    
    `which psql ps aux | grep postgres`
    

### 3. **Review Kasm Documentation**

It would be beneficial to revisit the Kasm documentation or the website where you downloaded the Docker Compose file. Sometimes, specific deployment models will require different configurations, or there might be separate documentation for handling the database.

```bash
root@2c668510afd1:/# which psql root@2c668510afd1:/# ps aux | grep postgres 70 639 0.0 0.3 172004 27136 ? Ss 19:44 0:00 postgres -c ssl=on -c ssl_cert_file=/etc/ssl/certs/db_server.crt -c ssl_key_file=/etc/ssl/certs/db_server.key -c config_file=/var/lib/postgresql/conf/postgresql.conf -c hba_file=/var/lib/postgresql/conf/pg_hba.conf 70 975 0.0 0.0 26332 3884 ? Ss 19:44 0:00 postgres: logger 70 977 0.0 0.3 172156 26044 ? Ss 19:44 0:00 postgres: checkpointer 70 978 0.0 0.0 172072 6588 ? Ss 19:44 0:00 postgres: background writer 70 979 0.0 0.1 172040 8508 ? Ss 19:44 0:01 postgres: walwriter 70 980 0.0 0.0 172720 7356 ? Ss 19:44 0:00 postgres: autovacuum launcher 70 981 0.0 0.0 26608 4284 ? Ss 19:44 0:01 postgres: stats collector 70 982 0.0 0.0 172564 6332 ? Ss 19:44 0:00 postgres: logical replication launcher 70 1128 0.0 0.1 173776 15036 ? Ss 19:44 0:00 postgres: kasmapp kasm kasm_share.kasm_default_network(35866) idle in transaction 70 1129 0.0 0.1 173244 14140 ? Ss 19:44 0:00 postgres: kasmapp kasm kasm_share.kasm_default_network(35882) idle 70 1132 0.0 0.1 173860 15804 ? Ss 19:44 0:00 postgres: kasmapp kasm kasm_api.kasm_default_network(57692) idle in transaction 70 1133 0.0 0.1 173244 14012 ? Ss 19:44 0:00 postgres: kasmapp kasm kasm_api.kasm_default_network(57702) idle 70 1138 0.2 0.5 174424 42544 ? Ss 19:44 0:02 postgres: kasmapp kasm kasm_manager.kasm_default_network(50006) idle 70 1139 0.0 0.1 173244 14012 ? Ss 19:44 0:00 postgres: kasmapp kasm kasm_manager.kasm_default_network(50014) idle 70 1154 0.0 0.3 174184 24892 ? Ss 19:45 0:00 postgres: kasmapp kasm kasm_api.kasm_default_network(39816) idle 70 1200 0.2 0.3 174252 28656 ? Ss 19:45 0:03 postgres: kasmapp kasm kasm_manager.kasm_default_network(57154) idle 70 1247 0.1 0.5 174616 46728 ? Ss 19:45 0:02 postgres: kasmapp kasm kasm_manager.kasm_default_network(46548) idle in transaction 70 1573 0.0 0.2 174156 22844 ? Ss 19:47 0:00 postgres: kasmapp kasm kasm_api.kasm_default_network(58646) idle 70 1708 0.0 0.2 173480 22460 ? Ss 19:47 0:00 postgres: kasmapp kasm kasm_share.kasm_default_network(59044) idle root 5318 0.0 0.0 6020 2048 pts/0 S+ 20:07 0:00 grep --color=auto postgres root@2c668510afd1:/#


```


#ChatGPT 

The output indicates that PostgreSQL is running inside the `kasm_123` container, but `psql` is not available in your `$PATH`. This suggests that while the database is operational, direct command line access via `psql` might not be configured or installed in the standard locations. Here's how you can proceed to interact with the database:

### Using the PostgreSQL Command-Line Tools (if available)

If `psql` is installed but not in your `$PATH`, you can try locating it:

bashCopy code

`find / -name psql 2>/dev/null`

If `psql` is found, you can use the complete path to run it. If it is not found, you may need another method to interact with the database.


```bash
root@2c668510afd1:/# find / -name psql 2>/dev/null 

/opt/docker/overlay2/9bdf04805547126b2e29e72c5045a295a251e884ccef95b1fcbff6d9cb8277aa/merged/usr/local/bin/psql 

/opt/docker/overlay2/7469690bd19f894f7fa66312563b3dc7d253b411180ea4089258db6b575174fc/diff/usr/local/bin/psql
```


#ChatGPT 

Great, you found the location of the `psql` binary in the Docker overlay filesystem. These paths suggest that `psql` is indeed present within the container environment, albeit not in the default `$PATH`. Here’s how you can proceed to use it:

### Using the `psql` binary directly:

Given the paths you found, you can directly invoke `psql` using the full path. It’s likely that the first path (`/opt/docker/overlay2/.../merged/usr/local/bin/psql`) is the correct one to use as it resides within the `merged` directory, which is what your running container sees.

1. **Open a shell session** inside your `kasm_123` container if you aren't already in one.
    
2. **Run `psql`** using the full path you found:
```bash
/opt/docker/overlay2/9bdf04805547126b2e29e72c5045a295a251e884ccef95b1fcbff6d9cb8277aa/merged/usr/local/bin/psql -U kasmapp -d kasm
```

#ChatGPT 

Based on the commands you've found in the Kasm documentation and the `psql` path you've located in the Docker overlay filesystem, the process you described should work to reset the admin password and clear associated credentials in your Kasm deployment. Here's how you can proceed:

1. **Enter the PostgreSQL shell** using the path to `psql` that you identified:

```bash
/opt/docker/overlay2/9bdf04805547126b2e29e72c5045a295a251e884ccef95b1fcbff6d9cb8277aa/merged/usr/local/bin/psql -U kasmapp -d kasm
```

2. **Run the SQL commands** provided in the documentation to reset the admin password and clear security credentials:
```sql
update users set     pw_hash = 'fe519184b60a4ef9b93664a831502578499554338fd4500926996ca78fc7f522',     salt = '83d0947a-bf55-4bec-893b-63aed487a05e',     secret=NULL, set_two_factor=False, locked=False,     disabled=False, failed_pw_attempts = 0 where username ='admin@kasm.local';  DELETE FROM webauthn_credentials WHERE user_id IN (     SELECT user_id FROM users WHERE username = 'admin@kasm.local' );
```

3. **Exit the `psql` shell** with:

```sql
\q
```

These commands reset the admin password to a known hash (you will likely need to know the plaintext password that corresponds to this hash, which should be provided in Kasm's documentation or support resources). They also clear any Two-Factor Authentication (WebAuthn and TOTP) settings that might prevent login.

Before executing, confirm that:

- The username `admin@kasm.local` is the correct administrator username in your setup.
- You have the plaintext version of the password that corresponds to the hash provided, as you'll need it to log in afterwards.

Executing these commands will impact account security settings, so proceed with the understanding that it effectively removes certain security measures for the specified account to regain access. Once you have regained access, consider setting a new password and re-enabling any desired security settings.




If the `psql` does not work as expected (for example, if it fails due to environment issues or missing dependencies), you might need to temporarily modify the Docker container to include the `psql` utility in its `$PATH`, or ensure that all dependencies are present. Alternatively, as mentioned previously, using a dedicated PostgreSQL client container or tool from your host might be necessary.


### Resetting the Admin Password Directly

Since it seems you have access to the running PostgreSQL process, but not `psql`, the next approach is to interact with the database using SQL commands or scripts provided by Kasm, if available.

#### 1. **Find a Way to Run SQL Commands**

If you can find any scripts or SQL command interfaces within the container, you could use them to reset the password. You might need to look for specific scripts that Kasm provides for database operations:

bashCopy code

`find / -name "*.sql" 2>/dev/null`

or

bashCopy code

`find / -name "*.sh" 2>/dev/null`

Look for scripts that might be used to interact with the database.

#### 2. **Consider External Tools**

If you're unable to find or use `psql` or another method to run SQL commands within the container, you might consider connecting to the PostgreSQL server from another container that has `psql` installed or from your host machine, if network configurations allow external connections. Here's an example of how you could run a PostgreSQL client container:

bashCopy code

`docker run -it --rm --network container:kasm_123 postgres psql -h localhost -U kasmapp -d kasm`

This command runs a temporary PostgreSQL client within the same network as your Kasm container, attempting to connect to the database.

#### 3. **Documentation and Support**

Since the setup is somewhat unconventional (with the database running inside a presumably multi-service container without straightforward access tools), checking back with the Kasm documentation or their support forum might provide specific insights or procedures for this scenario.

These steps should help you figure out how to reset the password or gain further access to configure the system.