# Docker

## Installation

1. install docker
2. with root create a docker config override: `systemctl edit docker.service`    
   ```
   [Service]
   ExecStart=
   ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock --data-root=/home/szabi/.docker
   ```
   - This opens up the api interface to your docker installation.  
     You can access it with [portainer](https://portainer.readthedocs.io/) for example.  
   - Since my root partition is small I used the `--data-root` parameter.
3. `systemctl start docker` (or enable it)
4. you may need to add addresses and hostnames to your `/etc/hosts`
5. to access a custom registry: `docker login registry.foobar.net`

## Segfaults inside containers

in `/etc/default/grub`

add the `vsyscall=emulate` parameter:

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet resume=/dev/mapper/VolGroup00-lvolswap sysrq_always_enabled=1 vsyscall=emulate"
```

rebuild the config with `grub-mkconfig -o /boot/grub/grub.cfg`
and then reboot.


## Useful commands and scripts

- `docker-compose -f docker-compose.yml -f another.yml pull` (or `up -d`, or `down`)
- `docker info`
- `docker images`
- `docker ps`, `docker ps -a`
- `docker exec -it foobar_project_1 bash`
- `docker logs foobar_project_1 -f`
- `docker inspect -f '{{.State.Health}}' foobar_project_1`


- `docker stop <CONTAINER ID>`
- `docker kill <CONTAINER ID>`
- `docker rm <CONTAINER ID>`
- `docker images`
- `docker stop <IMAGE ID>`  
  (unlike down above it just stops the vm, won't remove it and its network interfaces)
- `docker rmi <IMAGE ID>`  
  (delete all images by id)

### Get host ip

Export the ip using `ip addr`.

```bash
INTERFACE=`ip addr | awk '/state UP/ {print $2}' | sed 's/.$//' | grep -v -E "(docker|veth)" | head -n 1`
export IP=`ip addr show $INTERFACE | grep --color=never "inet " | awk '{print $2}'`
```

---

## Access through nfs (macos only)

1. /etc/nfs.conf: `nfs.server.mount.require_resv_port = 0`
2. /etc/exports: `/Users -alldirs -insecure -mapall=501:20 localhost` (or use /home)
3. export `PROJECT_DIR` in bash_profile (or bashrc for proper distros)

Defining volumes in docker:

```yaml
version: "3.2"

volumes:
  api-nfs:
    driver: local
    driver_opts:
      type: nfs
      o: addr=host.docker.internal,rw,nolock,hard,nointr,nfsvers=3
      device: ":${PROJECT_DIR}/api/var/cache"
#...
#...
services:
  api:
    volumes:
      - "api-nfs:/var/www/html/var/cache"
      #  ^         ^
      # from nfs   into container
```
