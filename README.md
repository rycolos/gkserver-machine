# gkserver-machine
Infrastructure and deployment for gkserver instance

Github Actions used to perform a `git pull` on remote machine and, if changes are detected, perform a `docker compose up -d` to build, recreate, or remove docker services.

Assumes repo is cloned into `~/gkserver`, if manually cloning. 

Assumes .env file is present in `docker-compose` directory.

Machine should be initialized with `init_gkserver` [ansible playbook](https://github.com/rycolos/gklab-ansible), which will clone this repo as a step. 

Additional tasks required:
* Install self-hosted runner for Github Actions and create service [1](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners), [2](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/configuring-the-self-hosted-runner-application-as-a-service)
* Transfer existing Docker data `docker-data` (if desired)
* Create `.env` in `docker-compose`
* Configure and harden ssh
* Mount HDDs and edit fstab
* Install rclone and configure
* Install syncthing and configure
* Install CyberPower PowerPanel and configure