#!/bin/bash

#SET DIRECTORIES
user="kepler"
logdir="/home/$user/logs"
logdest="/home/$user/logs/gdrive_gkserver_backup.log"
config="/home/$user/.config/rclone/rclone.conf"
src1="/media/backup_main/documents/"
dest1="gdrive:backup_gkserver/documents/"
src2="/media/backup_main/gkserver_home/"
dest2="gdrive:backup_gkserver/home/"
# src3="/media/media_library/music/"
# dest3="gdrive:backup_gkserver/plex_library/"
src4="/media/backup_main/docker-data/"
dest4="gdrive:backup_gkserver/docker_data/"
# src5="/media/backup_main/ryan_mba_user/"
# dest5="gdrive:backup_gkserver/ryan_mba_user/"
src6="/media/backup_main/ryan_gaming_music_working_on/"
dest6="gdrive:backup_gkserver/ryan_gaming_music_working_on/"
trashdir="gdrive:/rclone_trash/$(date +%m-%d-%Y)"

echo $(date) >> $logdest
echo "" >> $logdest

#backup docs
rclone sync $src1 $dest1 \
--config=$config \
--progress --delete-excluded --backup-dir $trashdir 2>&1 | tee $logdest

#home dir
rclone sync $src2 $dest2 \
--config=$config \
--progress --delete-excluded --backup-dir $trashdir --exclude=".ssh/**" 2>&1 | tee $logdest

#plex library (music only)
rclone sync $src3 $dest3 \
--config=$config \
--progress --backup-dir $trashdir 2>&1 | tee $logdest

#docker data
rclone sync $src4 $dest4 \
--config=$config \
--progress --backup-dir $trashdir 2>&1 | tee $logdest

#ryan mba
# rclone sync $src5 $dest5 \
# --config=$config \
# --progress --backup-dir $trashdir 2>&1 | tee $logdest

#gamingpc - music working on
rclone sync $src6 $dest6 \
--config=$config \
--progress --backup-dir $trashdir 2>&1 | tee $logdest

echo "" >> $logdest
echo $(date) >> $logdest
echo "----------" >> $logdest