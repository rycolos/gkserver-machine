#!/bin/bash

#CONFIG
user="ryan"

mnt1="/mnt/backup_int1"
mnt2="/mnt/syncthing"
remote="b2:gkserver-backup"

logdir="/home/$user/logs"
logdest="b2_gkserver_backup.log"

config="/home/$user/.config/rclone/rclone.conf"

#SETUP LOGS
mkdir -p $logdir
echo $(date) >> $logdir/$logdest
echo "" >> $logdir/$logdest

#SYNC
    #docker-data
rclone sync $mnt1/docker_data $remote/docker_data \
--config=$config \
--fast-list --progress --transfers 20 2>&1 | tee $logdir/$logdest

    #other-backups
rclone sync $mnt1/other_backups $remote/other_backups \
--config=$config \
--fast-list --progress --transfers 20 2>&1 | tee $logdir/$logdest

    #archives
rclone sync $mnt1/library_backup/archives $remote/archives \
--config=$config \
--fast-list --progress --transfers 20 2>&1 | tee $logdir/$logdest

    #music
rclone sync $mnt1/library_backup/music $remote/music \
--config=$config \
--fast-list --progress --transfers 20 2>&1 | tee $logdir/$logdest

    #syncthing
rclone sync $mnt2/ $remote/syncthing \
--config=$config \
--fast-list --progress --transfers 20 2>&1 | tee $logdir/$logdest


#FINALIZE LOGS
echo "" >> $logdir/$logdest
echo $(date) >> $logdir/$logdest
echo "----------" >> $logdir/$logdest