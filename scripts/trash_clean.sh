#!/bin/bash

#SET RETENTION PERIODS
days=14

#SET DIRECTORIES
user="ryan"

logdir="/home/$user/logs"
logdest="retention.log"

logsrc="/home/$user/logs"
vol1="/mnt/backup_int1"

trashsource1="$vol1/library_trash"
trashsource2="$vol1/docker_data_trash"

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

#prune logs after DAYS
find $logsrc -name "*.log" -mtime +$days -delete -print 2>&1 | tee $logdir/$logdest

#prune backup_trash folders after DAYS
find $trashsource1 -maxdepth 1 -mindepth 1 -mtime +$days -type d -exec rm -rv {} + -print 2>&1 | tee $logdir/$logdest
find $trashsource2 -maxdepth 1 -mindepth 1 -mtime +$days -type d -exec rm -rv {} + -print 2>&1 | tee $logdir/$logdest

echo "" >> $logdir/$logdest
echo $(date) >> $logdir/$logdest
echo "----------" >> $logdir/$logdest
