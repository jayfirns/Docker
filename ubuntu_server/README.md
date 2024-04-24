---
created: 2024-04-23T23:29
updated: 2024-04-24T15:59
---
We're going with a server approach over a gui...

Here is our [[Ubuntu Server]]

# Making Changes

### Don't forget to comment out the following:

- Dockerfile - git clone
- Make sure you don't use btop

### File Copy

```bash
scp johnfirnschild@10.0.0.52:/Users/johnfirnschild/Documents/Noob_Linux_stuff/script/system/disk_usage.sh disk_usage.sh

scp johnfirnschild@10.0.0.52:/Users/johnfirnschild/Documents/hacker_basics/nmap/scripts/scan.sh scan.sh

scp johnfirnschild@10.0.0.52:/Users/johnfirnschild/Documents/HomeLab/Docker_Desktop/ubuntu_server ubuntu_server

```