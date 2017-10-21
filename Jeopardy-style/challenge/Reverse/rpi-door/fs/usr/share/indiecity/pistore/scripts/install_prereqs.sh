#! /bin/bash
# Script to look for an app's prereqs file.
# If it finds it, it will install the app's dependencies.

function writeErrorCode
{
	# Write the error code out to a file so the Pi Store can pick it up.
	echo "ERROR: $ERRORCODE" >> "$SCRIPTLOGFILE"
	echo >> "$SCRIPTLOGFILE"

	echo "$ERRORCODE" > "$ERRORFILE"
	chown $SCRIPTUSER $ERRORFILE
	exit
}

if [ "$#" -ne "2" ]
	then
		echo "Usage: $0 app_path safe_name"
		exit 1
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

APPPATH="$1"
echo "APPPATH=$APPPATH" >> "$SCRIPTLOGFILE" 

SAFENAME="$2"
echo "SAFENAME=$SAFENAME" >> "$SCRIPTLOGFILE" 

PREREQSFILE="prereqs"
DEPENDENCIES=""

ERRORCODE=0

ERRORFILE="$USER_HOME/indiecity/pistore/script_errorcode"
echo "ERRORFILE=$ERRORFILE" >> "$SCRIPTLOGFILE"

cd "$APPPATH"
ERRORCODE="$?"

# Detect if the cd call failed.
if [ "$ERRORCODE" != "0" ]
	then
		writeErrorCode
fi

echo >> "$SCRIPTLOGFILE"

# Look for the prereqs file.
#if [ -f "$PREREQSFILE" ]
#	then
#		while read line
#			do
#				DEPENDENCIES="$DEPENDENCIES""$line "
#		done < "$PREREQSFILE"
		
		#gksudo apt-get update		
		
		# Now get the dependencies:
		#sudo apt-get install "$DEPENDENCIES"
#		MESSAGE="Pi Store would like your permission to install these prerequisite packages for $SAFENAME: $DEPENDENCIES"
		#gksudo -m "$MESSAGE" apt-get -y install $DEPENDENCIES 
		#ERRORCODE="$?"

		#echo "Pi Store would like your permission to install the dependencies for $SAFENAME:"
		#echo "$DEPENDENCIES"
		
		# Detect if the sudo call failed.
#		if [ "$ERRORCODE" != "0" ]
#			then			
#				writeErrorCode
#		fi
#fi
