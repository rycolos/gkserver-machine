#!/bin/bash

#SET RETENTION PERIODS
days=30

#SET DIRECTORIES
logdest="/home/kepler/logs/retention.log"
logsrc="/home/kepler/logs"
vol1="/media/backup_main"
trashsource1="$vol1/plex_library/plex_library_trash"
trashsource2="$vol1/gkserver_home/gkserver_home_trash"
trashsource3="$vol1/docker-data/docker-data_trash"

echo $(date) >> $logdest
echo "" >> $logdest

#verify vol1 is mounted, exit if not
if grep -qs $vol1 /proc/mounts; then
    echo "$vol1 mounted" >> $logdest
else
    echo "$vol1 not mounted" >> $logdest
    exit 1
fi

#prune logs after 30d
find $logsrc -mtime +$days -delete -print 2>&1 | tee -a $logdest

#prune backup_trash folders after 30d
find $trashsource1 -maxdepth 1 -mindepth 1 -mtime +$days -type d -exec rm -rv {} + -print 2>&1 | tee -a $logdest
find $trashsource2 -maxdepth 1 -mindepth 1 -mtime +$days -type d -exec rm -rv {} + -print 2>&1 | tee -a $logdest
find $trashsource3 -maxdepth 1 -mindepth 1 -mtime +$days -type d -exec rm -rv {} + -print 2>&1 | tee -a $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest
