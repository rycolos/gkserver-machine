#!/bin/sh

#configure pwrtstat to use this command with sudo pwrstat -pwrfail -cmd /home/kepler/gkserver/scripts/powerfail_discord.sh

echo "Warning: Utility power failure has occurred for a while, system will be shutdown soon!" | wall
echo "Warning: Utility power failure has occurred for a while, system will be shutdown soon!" | python3 /home/kepler/gkserver/scripts/discord-pipe.py
