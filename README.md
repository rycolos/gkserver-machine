# gkserver-machine
Infrastructure and deployment for gkserver instance.

## Updates and maintenance
Github Actions used as CI/CD pipeline to perform a `git pull` on remote machine and, if changes are detected, perform a `docker compose up -d` to build, recreate, or remove docker services.

Assumes repo is cloned into `~/gkserver`.
Assumes .env file is present in `docker-compose` directory.

Package and Docker container updates are manually made using `updates` [ansible playbook](https://github.com/rycolos/gklab-ansible/tree/main).

## Initialization of new gkserver instance
Create DHCP reservation for ethernet-connected machine.

Key-based ssh authentication should be set up and `/etc/ssh/sshd_config` settings updated:
```
PrintLastLog yes
ClientAliveInterval 120
ClientAliveCountMax 720
PasswordAuthentication no
PermitRootLogin no
```

Machine should be initialized with `init_gkserver` [ansible playbook](https://github.com/rycolos/gklab-ansible), which will clone this repo as a step. 

Additional tasks required:
* Install self-hosted runner for Github Actions and create service [1](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners), [2](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/configuring-the-self-hosted-runner-application-as-a-service)
* Transfer existing Docker data `docker-data` (as desired, per container)
* Create and update `.env` in `docker-compose`, per `.env.template`
* Mount HDDs and edit `fstab` for auto-mount
* Configure Syncthing
* Configure Rclone with `rclone config`
* Install [CyberPower PowerPanel](https://www.cyberpowersystems.com/product/software/power-panel-personal/powerpanel-for-linux/) and configure
* Uncomment backup cronjobs when ready
* Docker compose up

Optionally, run compute benchmarks with Geekbench6:
```
wget https://cdn.geekbench.com/Geekbench-6.2.1-Linux.tar.gz
tar xf Geekbench-6.2.1-Linux.tar.gz
cd Geekbench-6.2.1-Linux
./geekbench6
```