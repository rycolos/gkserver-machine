#!/bin/bash

#CONFIG
user="ryan"

logdir="/home/$user/logs"
logdest="docker_gkserver_backup.log"

dockerdir="/home/$user/gkserver/docker-compose"
src1="/home/$user/gkserver/docker_data/"
vol1="/mnt/backup_int1"
dest1="$vol1/docker_data"
trashdir="$vol1/docker_data_trash/$(date +%m-%d-%Y)"

#SETUP LOGS
mkdir -p $logdir
echo $(date) >> $logdir/$logdest
echo "" >> $logdir/$logdest

#verify vol1 is mounted, exit if not
if grep -qs $vol1 /proc/mounts; then
    echo "$vol1 mounted" >> $logdir/$logdest
else
    echo "$vol1 not mounted" >> $logdir/$logdest
    exit 1
fi

#stop docker
/usr/bin/docker compose -f $dockerdir/docker-compose.yml stop

#SYNC
rsync -avhi --delete --backup-dir=$trashdir $src1 $dest1 2>&1 | tee $logdir/$logdest

#start docker
/usr/bin/docker compose -f $dockerdir/docker-compose.yml start

#FINALIZE LOGS
echo "" >> $logdir/$logdest
echo $(date) >> $logdir/$logdest
echo "----------" >> $logdir/$logdest