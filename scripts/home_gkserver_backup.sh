#!/bin/bash

#SET DIRECTORIES
logdest="/home/kepler/logs/home_gkserver_backup.log"
src1="/home/kepler"
dest1="/media/backup_main/gkserver_home"
exclude1="gkserver"
trashdir="/media/backup_main/gkserver_home/gkserver_home_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

rsync -avhi --delete --exclude $exclude1 --backup-dir=$trashdir $src1 $dest1 2>&1 | tee -a $logdest

#rsync -avhi --delete --exclude /home/kepler/gkserver /home/kepler /media/backup_main/gkserver_home --dry-run

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest
