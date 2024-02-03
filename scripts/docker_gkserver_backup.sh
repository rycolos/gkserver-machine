#!/bin/bash

#SET DIRECTORIES
logdest="/home/kepler/logs/docker_gkserver_backup.log"
dockerdir="/home/kepler/gkserver/docker-compose"
src1="/home/kepler/gkserver/docker-data"
vol1="/media/backup_main"
dest1="$vol1/docker-data"
trashdir="$vol1/docker-data/docker-data_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

#verify vol1 is mounted, exit if not
if grep -qs $vol1 /proc/mounts; then
    echo "$vol1 mounted" >> $logdest
else
    echo "$vol1 not mounted" >> $logdest
    exit 1
fi

#stop docker
/usr/bin/docker compose -f $dockerdir/docker-compose.yml stop

rsync -avhi --delete --backup-dir=$trashdir $src1 $dest1 2>&1| tee -a $logdest

#start docker
/usr/bin/docker compose -f $dockerdir/docker-compose.yml start

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest