#! /bin/bash
# Script to request sudo permissions to run an app's install/uninstall script.

function writeErrorCode
{
	# Write the error code out to a file so the Pi Store can pick it up.
	echo "ERROR: $ERRORCODE" >> "$SCRIPTLOGFILE"
	echo >> "$SCRIPTLOGFILE"

	echo "$EXITCODE" > "$ERRORFILE"
	chown $SCRIPTUSER $ERRORFILE
	exit
}

if [ $# -le 1 ]
	then
		echo "Usage: $0 install_script_path install_script_file"
		exit
fi

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

INSTALLSCRIPTPATH=$1
echo "INSTALLSCRIPTPATH=$INSTALLSCRIPTPATH" >> "$SCRIPTLOGFILE"

INSTALLSCRIPTFILE=$2
echo "INSTALLSCRIPTFILE=$INSTALLSCRIPTFILE" >> "$SCRIPTLOGFILE"

EXITCODE="0"

ERRORFILE="$USER_HOME/indiecity/pistore/script_errorcode"
echo "ERRORFILE=$ERRORFILE" >> "$SCRIPTLOGFILE"

cd "$INSTALLSCRIPTPATH"
EXITCODE="$?"

# Detect if the cd call failed or succeeded.
if [ "$EXITCODE" != "0" ]
	then
		writeErrorCode
fi

chmod +x "$INSTALLSCRIPTFILE" 

sudo ./"$INSTALLSCRIPTFILE" | tee -a "$SCRIPTLOGFILE"
EXITCODE="$?"

# Detect if the sudo call failed or succeeded.
if [ "$EXITCODE" != "0" ]
	then
		writeErrorCode
fi

echo >> "$SCRIPTLOGFILE"
