#!/bin/bash

#SET DIRECTORIES
user="kepler"
logdir="/home/$user/logs"
logdest="/home/$user/logs/plex_gkserver_backup.log"
src1="/media/media_library"
vol1="/media/backup_main"
dest1="$vol1/media_library"
trashdir="$vol1/media_library/media_library_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

#verify vol1 is mounted, exit if not
if grep -qs $vol1 /proc/mounts; then
    echo "$vol1 mounted" >> $logdest
else
    echo "$vol1 not mounted" >> $logdest
    exit 1
fi

rsync -avhi --delete --backup-dir=$trashdir \
$src1 $dest1 2>&1 | tee $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest
