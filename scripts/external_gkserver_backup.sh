#!/bin/bash

#SET DIRECTORIES
user="ryan"

logdir="/home/$user/logs"
logdest="external_gkserver_backup.log"

src1="/mnt/backup_int1"
vol1="/mnt/backup_ext1"
dest1="$vol1"
trashdir="$vol1/gkserver_backup_trash/$(date +%m-%d-%Y)"

#SETUP LOGS
mkdir -p $logdir
echo $(date) >> $logdir/$logdest
echo "" >> $logdir/$logdest

#verify src1 is mounted, exit if not
if grep -qs $src1 /proc/mounts; then
    echo "$src1 mounted" >> $logdir/$logdest
else
    echo "$src1 not mounted" >> $logdir/$logdest
    exit 1
fi

#verify vol1 is mounted, exit if not
if grep -qs $vol1 /proc/mounts; then
    echo "$vol1 mounted" >> $logdir/$logdest
else
    echo "$vol1 not mounted" >> $logdir/$logdest
    exit 1
fi

#SYNC
rsync -avhi --delete \
--backup-dir=$trashdir \
$src1 $dest1 2>&1 | tee $logdir/$logdest

#CLEAN TRASH
find $vol1/gkserver_backup_trash/ -maxdepth 1 -mindepth 1 -mtime +7 -type d -exec rm -rv {} + -print 2>&1 | tee $logdest

#FINALIZE LOGS
echo "" >> $logdir/$logdest
echo $(date) >> $logdir/$logdest
echo "----------" >> $logdir/$logdest