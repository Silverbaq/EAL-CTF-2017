#! /bin/bash
# This script will run when an ICELib update is available.

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
apt-get update -qqd &
spinner $!

apt-get install icelib | tee -a "$SCRIPTLOGFILE"

ERRORCODE="$?"
if [ "$ERRORCODE" != "0" ]; then
	echo "ICELib update failed." | tee -a "$SCRIPTLOGFILE"
	exit "$ERRORCODE"
fi

echo "ICELib update Complete." | tee -a "$SCRIPTLOGFILE"
