#! /bin/bash
# Script to add script to run game on start-up to relevant dir, then reboot Pi.

if [ $# -le 2 ]
	then
		echo "Usage: $0 game_type game_dir game_exe"
		exit
fi

# Get the current user.
if [ -z "$SUDO_USER" ]
	then
		USERNAME="$USER"
else
	USERNAME="$SUDO_USER"
fi

USER_HOME=$(awk -F: -v v="$USERNAME" '{if ($1==v) print $6}' /etc/passwd)

# Set up our logging
SCRIPTLOGFILE="$USER_HOME"/indiecity/pistore/Scripts.log
echo "### $0 - $(date) ###" >> "$SCRIPTLOGFILE"

GAMETYPE="$1"
echo "GAMETYPE=$GAMETYPE" >> "$SCRIPTLOGFILE"

GAMEDIR="$2"
echo "GAMEDIR=$GAMEDIR" >> "$SCRIPTLOGFILE"

GAMEEXE="$3"
echo "GAMEEXE=$GAMEEXE" >> "$SCRIPTLOGFILE"

FILE="/var/lib/indiecity/init-app"

# Create a text file with the gamepath in for our script to access.
sudo echo "$GAMETYPE" > "$FILE"
sudo echo "$GAMEDIR" >> "$FILE"
sudo echo "$GAMEEXE" >> "$FILE"
sudo echo "$USERNAME" >> "$FILE"

# Copy our start-up script to /etc/init.d and add link
sudo cp "/usr/share/indiecity/pistore/scripts/indiecitystartupgame.sh" /etc/init.d/ | tee -a "$SCRIPTLOGFILE"
sudo update-rc.d indiecitystartupgame.sh defaults | tee -a "$SCRIPTLOGFILE"

echo >> "$SCRIPTLOGFILE"

# Restart the Pi
sudo shutdown -r now
