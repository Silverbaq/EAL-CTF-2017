#! /bin/sh 
### BEGIN INIT INFO
# Provides:          indiecitystartupgame
# Required-Start:    $remote_fs $network
# Required-Stop:     $remote_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Script to run a Pi Store app on startup.
# X-Start-Before:    x11-common
# X-Interactive:     true
### END INIT INFO

# We've got the game path we want saved in a file. Let's go find it.

case "$1" in
	start)

		# Remove the file's from the boot process
		update-rc.d -f indiecitystartupgame.sh remove

		FILEPATH="/var/lib/indiecity/init-app"

		if [ -f "$FILEPATH" ]
			then
				GAMETYPE=$(sed -n -e 1p "$FILEPATH")
				
				GAMEDIR=$(sed -n -e 2p "$FILEPATH")
				GAMEEXE=$(sed -n -e 3p "$FILEPATH")

				USERNAME=$(sed -n -e 4p "$FILEPATH")
				
				# Set up our logging
				USER_HOME=$(awk -F: -v v="$USERNAME" '{if ($1==v) print $6}' /etc/passwd)

				SCRIPTLOGFILE="$USER_HOME/indiecity/pistore/Scripts.log"
				echo "### $0 - $(date) ###" >> "$SCRIPTLOGFILE"

				echo "GAMETYPE=$GAMETYPE" >> "$SCRIPTLOGFILE"
				echo "GAMEDIR=$GAMEDIR" >> "$SCRIPTLOGFILE"
				echo "GAMEEXE=$GAMEEXE" >> "$SCRIPTLOGFILE"
				echo "USERNAME=$USERNAME" >> "$SCRIPTLOGFILE"

				cd "$GAMEDIR"
		else
			echo "ERROR: $FILEPATH not found!"
			exit
		fi
		
		# su into the user who initiated run from terminal.
		
		# Run the game
		chvt 8

		if [ "$GAMETYPE" = "PYTHON" ]
			then
				su "$USERNAME" -c "python $GAMEEXE &"
				#openvt -c 8 -f -w -- agetty -l /bin/su -o "-s python $GAMEEXE \u" -a "$USERNAME" tty8 linux
		elif [ "$GAMETYPE" = "BINARY" ]
			then
				#su "$USERNAME" -c "./$GAMEEXE &"
				openvt -c 8 -f -w -- agetty -l /bin/su -o "-s $GAMEEXE \u" -a "$USERNAME" tty8 linux
		else
			echo "ERROR: Game type $GAMETYPE not understood!" | tee -a "$SCRIPTLOGFILE"
			exit
		fi

		chvt 1
				
		# Delete this file and its link (stop it running at startup)
		#rm "$0"

		echo >> "$SCRIPTLOGFILE"
esac
