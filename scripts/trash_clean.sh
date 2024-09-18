#!/bin/bash

#SET RETENTION PERIODS
days=14

#SET DIRECTORIES
user="ryan"
logdir="/home/$user/logs"
logdest="/home/$user/logs/retention.log"
logsrc="/home/$user/logs"
vol1="/mnt/backup_int1"

trashsource1="$vol1/backup_trash"
trashsource2="$vol1/docker_data/docker_data_trash"

mkdir -p $logdir
echo $(date) >> $logdest
echo "" >> $logdest

#verify vol1 is mounted, exit if not
if grep -qs $vol1 /proc/mounts; then
    echo "$vol1 mounted" >> $logdest
else
    echo "$vol1 not mounted" >> $logdest
    exit 1
fi

#prune logs after DAYS
find $logsrc -name "*.log" -mtime +$days -delete -print 2>&1 | tee $logdest

#prune backup_trash folders after DAYS
find $trashsource1 -maxdepth 1 -mindepth 1 -mtime +$days -type d -exec rm -rv {} + -print 2>&1 | tee $logdest
find $trashsource2 -maxdepth 1 -mindepth 1 -mtime +$days -type d -exec rm -rv {} + -print 2>&1 | tee $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest
