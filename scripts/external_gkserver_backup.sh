#!/bin/bash

#SET DIRECTORIES
logdest="/home/kepler/logs/external_gkserver_backup.log"
src1="/media/backup_main"
vol1="/media/backup3_ext"
dest1="$vol1"
trashdir="$vol1/gkserver_backup_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

#verify src1 is mounted, exit if not
if grep -qs $src1 /proc/mounts; then
    echo "$src1 mounted" >> $logdest
else
    echo "$src1 not mounted" >> $logdest
    exit 1
fi

#verify vol1 is mounted, exit if not
if grep -qs $vol1 /proc/mounts; then
    echo "$vol1 mounted" >> $logdest
else
    echo "$vol1 not mounted" >> $logdest
    exit 1
fi

rsync -avhi --delete --no-perms --no-group --no-owner \
--backup-dir=$trashdir \
$src1 $dest1 2>&1 | tee $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest