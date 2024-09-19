#!/bin/bash

#SET DIRECTORIES
user="ryan"

logdir="/home/$user/logs"
logdest="media_gkserver_backup.log"

src1="/mnt/hdd1/"
backup_vol="/mnt/backup_int1"
dest1="$backup_vol/library_backup"
trashdir="$backup_vol/library_backup/library_trash/$(date +%m-%d-%Y)"

#SETUP LOGS
mkdir -p $logdir
echo $(date) >> $logdir/$logdest
echo "" >> $logdir/$logdest

#verify vol1 is mounted, exit if not
if grep -qs $backup_vol /proc/mounts; then
    echo "$backup_vol mounted" >> $logdir/$logdest
else
    echo "$backup_vol not mounted" >> $logdir/$logdest
    exit 1
fi

#SYNC
rsync -avhi --delete --backup-dir=$trashdir \
$src1 $dest1 2>&1 | tee $logdir/$logdest

#FINALIZE LOGS
echo "" >> $logdir/$logdest
echo $(date) >> $logdir/$logdest
echo "----------" >> $logdir/$logdest
