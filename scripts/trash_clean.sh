#!/bin/bash

#SET RETENTION PERIODS
days=30

#SET DIRECTORIES
logdest="/home/kepler/logs/retention.log"
logsrc="/home/kepler/logs"
trashsource1="/media/backup_main/plex_library/plex_library_trash"
trashsource2="/media/backup_main/gkserver_home/gkserver_home_trash"
trashsource3="/media/backup_main/docker-data/docker-data_trash"

echo $(date) >> $logdest
echo "" >> $logdest

#prune logs after 30d
find $logsrc -mtime +$days -delete -print 2>&1 | tee -a $logdest

#prune backup_trash folders after 30d
find $trashsource1 -maxdepth 1 -mindepth 1 -mtime +$days -type d -exec rm -rv {} + -print 2>&1 | tee -a $logdest
find $trashsource2 -maxdepth 1 -mindepth 1 -mtime +$days -type d -exec rm -rv {} + -print 2>&1 | tee -a $logdest
find $trashsource3 -maxdepth 1 -mindepth 1 -mtime +$days -type d -exec rm -rv {} + -print 2>&1 | tee -a $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest
