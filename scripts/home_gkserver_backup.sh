#!/bin/bash

#SET DIRECTORIES
logdest="/home/kepler/logs/home_gkserver_backup.log"
src1="/home/kepler"
vol1="/media/backup_main"
dest1="$vol1/gkserver_home"
exclude1="gkserver" #relative path
trashdir="$vol1/gkserver_home/gkserver_home_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

#verify vol1 is mounted, exit if not
if grep -qs $vol1 /proc/mounts; then
    echo "$vol1 mounted" >> $logdest
else
    echo "$vol1 not mounted" >> $logdest
    exit 1
fi

rsync -avhi --delete --exclude $exclude1 --backup-dir=$trashdir $src1 $dest1 2>&1 | tee -a $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest
