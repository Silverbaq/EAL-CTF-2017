#! /bin/bash
# This script will run when the pistore has detected an update is available and 
# initiated its own shutdown.

# Check we've got root.
if [ "$(whoami)" != "root" ]
	then
		echo "ERROR: You need root permissions to run this script."
		exit 1
fi

if [ -z "$SUDO_USER" ]
	then
		USERNAME="$USER"
else
	USERNAME="$SUDO_USER"
fi

# Set up our logging
USER_HOME=$(awk -F: -v v="$USERNAME" '{if ($1==v) print $6}' /etc/passwd)

SCRIPTLOGFILE="$USER_HOME"/indiecity/pistore/Scripts.log
echo "### $0 - $(date) ###" >> "$SCRIPTLOGFILE"

# Keep looping round until we determine that the pistore has shut itself down.
#PID=`pidof "pistore_real"`
#CYCLES=0
#RESTART=0
# We might want to send some sort of signal to the pistore for it to shutdown.

#while [ -n "$PID" ]
#	do
#	   RESTART=1
#		kill $PID
#		sleep 1
#		PID=`pidof "pistore_real"`
#		sleep 2
		
#		# Increment our cycles count. We want to timeout after 10 failed checks (30s).
#		CYCLES=$[CYCLES+1]
#
#		if [ $CYCLES -ge 10 ]
#			then
#				echo "ERROR: pistore doesn't seem to be shutting down. Can't continue." | tee -a "$SCRIPTLOGFILE"
#				exit 1
#		fi
#done

#echo "pistore is now closed or wasn't previously running." >> "$SCRIPTLOGFILE"

spinner()
{
    local pid=$1
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}


echo -n "Updating apt-get package lists (this may take several minutes)..." | tee -a "$SCRIPTLOGFILE"
#sleep 30 &
apt-get update -qqd &
spinner $!

#TODO display update whilst waiting for update - show update for now.

#apt-get -s install pistore
apt-get install pistore | tee -a "$SCRIPTLOGFILE"

ERRORCODE="$?"
if [ "$ERRORCODE" != "0" ]; then
	echo "Update failed." | tee -a "$SCRIPTLOGFILE"
	exit "$ERRORCODE"
fi

echo "Update Complete." | tee -a "$SCRIPTLOGFILE"

# Restart the new pistore

#if [ $RESTART -eq 1 ];
#then
#echo "restarting..." | tee -a "$SCRIPTLOGFILE"
#sleep 3
#pistore &
#disown $!
#fi

#echo >> "$SCRIPTLOGFILE"

#maybe offer user interaction
#echo "Would you like to start  client now? (y/n)"
#read -s -n 1 KEY
#echo "typed in $KEY"
#if [ $KEY = "y" ];
#then
#echo "start client then"
#else
#echo "NO"
#fi
#indiecity-client
