# Docker

How to run docker on linux? Short answer: don't.

----

## Installation

**1.)**
Install docker.

**2.)**
With root create a docker **config** override: `systemctl edit docker.service`  
(assuming you are not using the json configuration)    

```
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock --userns-remap=szabi --data-root=/home/szabi/.docker
```

- This opens up the api interface to your docker installation.  
 You can access it with [portainer](https://portainer.readthedocs.io/) for example.  
- Since my root partition is small I used the `--data-root` parameter.
- Permission inside the containers are not isolated so we need to setup
  a [username/group mapper](https://www.jujens.eu/posts/en/2017/Jul/02/docker-userns-remap/)
  (userns-remap parameter).

**3.)**
Add your user to the _docker_ **group** (`gpasswd -a szabi docker`)

You may want to set docker as your default group, but that seems
to be a bad idea.

**4.)**
Create **mappings** in /etc (from container to host):

_/etc/subuid_
```
szabi:1000:1 <--- files created by root should map to uid 1000 (which is me)
szabi:100000:65536 <-- remap range (min, max) - uid 100 in the container will be 100100 in the host
```

_/etc/subguid_
```
szabi:990:1 <-- groups created by group should belong to gid 990 (which is docker on my machine)
szabi:100000:65536
```

Get the appropriate numbers from `/etc/passwd` and `/etc/groups`.

**5.)**
Enable docker:  `systemctl start docker`

**6.)**
Modify systemwide **[umask](https://wiki.archlinux.org/index.php/umask)**.
(permissions for new files created) This is important,
since folders accessed by docker (via the docker group) must be writable (`rw-`), but
default group permission for new files on most systems is read only (`r--`).

You can check current values with `umask -S`. On Arch you can set umask
in `/etc/profile`, or you may need to set it via `pam_umask.so`, depending
on your distro or setup.

Umask should show _"u=rwx,g=rwx,o=r"_.

Depending on your environment, you may find this solution a security risk.
I assume you know what you're doing.

If you're using git only from the commandline, then you can wrap
the executable in an alias or a function (umask 002 && git).

**7.)**
Make git **respect umask** values: git ignores umask by default. Use the
`git config --global core.sharedRepository group` to enable it for your user.

**8.)**
When you checkout a repository that you want to use with docker
first you must **set the group ownership** (after you added your custom
secret, dotenv or nodemon files):

`chgrp -R docker .` (in the repo dir)

**9.)**
All **new files** should be in the docker group inside the
repository. Set the repo folder group owner to docker (`chgrp docker ./repo`),
and set the group to sticky (`chmod g+s ./repo`).

(If you find this solution ugly, there are other ways (writing
[post-checkout](https://git-scm.com/docs/githooks#_post_checkout) hooks,
or use this [example script](https://github.com/git/git/blob/master/contrib/hooks/setgitperms.perl),
ymmv)

## Kernel parameters

Without the vsyscall setting the containers may segfault randomly.

In `/etc/default/grub` add the `vsyscall=emulate` parameter:

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet resume=/dev/mapper/VolGroup00-lvolswap sysrq_always_enabled=1 vsyscall=emulate"
```

rebuild the config with `grub-mkconfig -o /boot/grub/grub.cfg`
and then reboot.

## Useful commands and scripts

- `docker login registry.foobar.net`  
  (to access a custom registry)
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
