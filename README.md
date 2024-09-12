# gkserver-machine
Infrastructure and deployment for gkserver instance.

## Updates and maintenance
Github Actions used as CI/CD pipeline to perform a `git pull` on remote machine and, if changes are detected, perform a `docker compose up -d` to build, recreate, or remove docker services.

Assumes repo is cloned into `~/gkserver`.
Assumes .env file is present in `docker-compose` directory.

Package and Docker container updates are manually made using [ansible playbooks](https://github.com/rycolos/gklab-ansible/tree/main).

## Initialization of new gkserver instance
Create DHCP reservation for ethernet-connected machine.

Machine should be initialized with `init_gkserver` [ansible playbook](https://github.com/rycolos/gklab-ansible), which will clone this repo as a step as well as perform a variety of other tasks:
* `config_essential` - Adds SSH public key, hardens SSH config, sets passwordless sudo for user, creates needrestart file for auto restart after update
* `core_packages` - Performs apt update/upgrade, installs key packages, sets default shell to Fish
* `install_docker` - Installs docker, docker compose, and dependencies
* `install_rclone` - Installs rclone, does not configure
* `install_syncthing` - Install syncthing, does not configure
* `gkserver_repo` - Clones [gkserver repo](https://github.com/rycolos/gkserver-config/tree/main) for scripts and docker compose
* `config_git` - Sets git user, email, and editor
* `config_storage` - Creates backup mount points
* `backup_cronjobs` - Creates backup-related cronjobs, defaulted off. 

Additional manual tasks required:
* Install self-hosted runner for Github Actions and create service [1](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners), [2](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/configuring-the-self-hosted-runner-application-as-a-service)
* Transfer existing Docker data `docker-data` (as desired, per container)
* Create and update `.env` in `docker-compose`, per `.env.template`
* Mount HDDs and edit `fstab` for auto-mount
* Configure Syncthing. Update listening address in `<gui>` block in `$HOME/.local/state/syncthing` to `0.0.0.0:8384`
* Configure Rclone with `rclone config`
* Configure [CyberPower PowerPanel](https://www.cyberpowersystems.com/product/software/power-panel-personal/powerpanel-for-linux/)
* Uncomment backup cronjobs when ready
* Docker compose up

Optionally, run compute benchmarks with Geekbench6:
```
wget https://cdn.geekbench.com/Geekbench-6.2.1-Linux.tar.gz
tar xf Geekbench-6.2.1-Linux.tar.gz
cd Geekbench-6.2.1-Linux
./geekbench6
```

Optionally, if installing new HDD, scan for errors with `smartctl`:
```
#Run short test
sudo smartctl -t short /dev/sdX

#Run long test
sudo smartctl -t long /dev/sdX

#Check test status
sudo smartctl -a /dev/sdX

#View results
sudo smartctl -A /dev/sdX

#View simple heatlh check
sudo smartctl -H /dev/sdX
```

Verify that fields `Reallocated_Sector_Ct`, `Current_Pending_Sector`, and `Offline_Uncorrectable` have a `RAW_VALUE` of 0.
