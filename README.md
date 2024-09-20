# gkserver-machine
Infrastructure and deployment for gkserver instance.

## Updates and maintenance
Github Actions used as CI/CD pipeline to perform a `git pull` on remote machine and, if changes are detected, perform a `docker compose up -d` to build, recreate, or remove docker services.

Assumes repo is cloned into `~/gkserver`.
Assumes .env file is present in `docker-compose` directory.

Package and Docker container updates are manually made using [ansible playbooks](https://github.com/rycolos/gklab-ansible/tree/main):
* `update_sys__apt_docker` - For Debian-based systems with Docker. Pull any updated docker images, update and upgrade apt packages, reboot if required
* `update_sys__apt` - For Debian-based systems without Docker. Update and upgrade apt packages, reboot if required

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
* Transfer existing Docker data to `~/gkserver/docker_data` (as desired, per container)
* Mount HDDs and edit `fstab` for auto-mount
* Configure [MergerFS](https://github.com/trapexit/mergerfs/blob/master/README.md) (see below)
* Create and update `.env` in `docker-compose`, per `.env.template`
* Configure Syncthing. Update listening address in `<gui>` block in `$HOME/.local/state/syncthing` to `0.0.0.0:8384`
* Configure Rclone with `rclone config` for Backblaze B2 cloud backups
* Configure [CyberPower PowerPanel](https://www.cyberpowersystems.com/product/software/power-panel-personal/powerpanel-for-linux/)
    * `sudo pwrstat -lowbatt -runtime 300 -capacity 35 -shutdown on`, `sudo pwrstat -pwrfail -active off -shutdown off`, verify with `sudo pwrstat -config`   
* Uncomment backup cronjobs when ready
* Docker compose up and verify services are running

### Benchmarking
Optionally, run compute benchmarks with Geekbench6:
```
wget https://cdn.geekbench.com/Geekbench-6.2.1-Linux.tar.gz
tar xf Geekbench-6.2.1-Linux.tar.gz
cd Geekbench-6.2.1-Linux
./geekbench6
```

### Disk Diagnostics
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

### Format/Partition New Drives
Optionally, for formatting and partitioning new disks:
```
sudo parted /dev/sdX mklabel gpt
sudo parted -a opt /dev/sdX mkpart primary ext4 0% 100%
sudo mkfs.ext4 /dev/sdX1
```

Add to `/etc/fstab`
```
#E.g., 
UUID=4b313333-a7b5-48c1-a957-d77d637e4fda /mnt/data ext4 defaults 0 2
```

### MergerFS
Install latest release from [MergerFS repo](https://github.com/trapexit/mergerfs/releases)

```
#update url for latest version
wget https://github.com/trapexit/mergerfs/releases/download/2.40.2/mergerfs_2.40.2.ubuntu-noble_amd64.deb
sudo dpkg -i mergerfs_2.40.2.ubuntu-noble_amd64.deb

#verify install and remove .deb
sudo mergerfs --version
rm mergerfs_2.40.2.ubuntu-noble_amd64.deb

#add line to /etc/fstab
/mnt/hdd* /mnt/library_mfs mergerfs cache.files=off,dropcacheonclose=true,category.create=mfs,minfreespace=100G,fsname=mergerfs 0 0

#mount unmounted fstab volumes
sudo mount -a
```
