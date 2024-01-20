# gkserver-machine
Infrastructure and deployment for gkserver instance

Github Actions used to perform a `git pull` on remote machine and, if changes are detected, perform a `docker compose up -d` to build, recreate, or remove docker services.

Assumes repo is cloned into `~/gkserver`. 