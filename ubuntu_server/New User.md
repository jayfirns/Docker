---
created: 2024-04-24T00:28
updated: 2024-04-24T15:59
---



Absolutely, starting with basic system administration tasks is a great way to familiarize yourself with managing your Ubuntu server. Here's how you can create a non-root user and add them to the sudo group:

1. **Log in to your Ubuntu server**: If you're not already logged in, connect to your server via SSH using the root account or another user with sudo privileges.
    
2. **Create a new user**: Use the `adduser` command to create a new user. Replace `newusername` with the desired username:

```bash
adduser john
```


Follow the prompts to set a password and provide any additional information for the new user.

3. **Add the user to the sudo group**: Once the user is created, you can add them to the sudo group, which grants them sudo (administrative) privileges:

```bash
usermod -aG sudo john
```

This command adds the user `newusername` to the `sudo` group, enabling them to execute commands with sudo.

4. **Verify sudo access**: To ensure that the new user has sudo access, you can switch to their account using the `su` command and then attempt to execute a command with sudo:

```bash
su - john sudo ls /root
```

Replace `/root` with any directory or command that requires sudo privileges. You should be prompted for the user's password and then see the output of the command.

5. **Test sudo access**: Exit from the user's account back to the root account by typing `exit`, and then log in again as the new user using SSH. Try running a command with sudo to confirm that sudo access is working correctly:

```bash
sudo apt update
```

This command updates the package lists on the server. If you're prompted for the user's password and the command executes successfully, then sudo access is set up correctly.

That's it! You've created a non-root user and added them to the sudo group on your Ubuntu server. This user now has administrative privileges and can perform tasks that require elevated permissions.



## Issue

sudo not installed:

```bash
root@7769061e2dbc:/# apt install sudo
root@7769061e2dbc:/# which sudo
/usr/bin/sudo
root@7769061e2dbc:/# 
```

