#! /bin/bash

#This script will 
#1 Delete the app's .zip file, if it exists.
#2 Run the optional dev supplied uninstall script.
#3 Delete the app's files.
#4 Remove the app from the XML registry.

#-----------------------
#PASSED IN ARGS
INSTALLDIR=""
ZIPFILE=""


while getopts ":d:i:" OPTION
do
	case $OPTION in
	d ) INSTALLDIR=$OPTARG ;;
	i ) PRODUCTID=$OPTARG ;;	
	esac
done


#-----------------------

ERRORCODE=0

# Check we've got root.
if [ "$(whoami)" != "root" ]
	then
		echo "ERROR: You need root permissions to run this script."
		exit 1
fi


#0 Set up our logging
if [ -z "$SUDO_USER" ]
	then
		USERNAME="$USER"
else
	USERNAME="$SUDO_USER"
fi
USER_HOME=$(awk -F: -v v="$USERNAME" '{if ($1==v) print $6}' /etc/passwd)

SCRIPTLOGFILE="$USER_HOME/indiecity/pistore/Scripts.log"

#-----------------------
echo "### $0 - $(date) ###" >> "$SCRIPTLOGFILE"
echo "INSTALLDIR=$INSTALLDIR" >> "$SCRIPTLOGFILE"
echo "PRODUCTID=$PRODUCTID" >> "$SCRIPTLOGFILE"
#--------------------------------------------------------------------------------------------------
#1 Get the location of the app's .zip file so we can delete it.

echo "Removing any remaining .zip files." | tee -a "$SCRIPTLOGFILE"

ZIPDIR="/var/lib/indiecity/pistore/Installers/$PRODUCTID"

if [ -d "$ZIPDIR" ]
	then
		rm -R $ZIPDIR/*
fi

#--------------------------------------------------------------------------------------------------
#2 run the optional dev supplied uninstall script
#read the uninstaller script from registry
echo "Check for Uninstall script..." | tee -a "$SCRIPTLOGFILE"
UNINSTALLSCRIPT=$(icreg -g "$PRODUCTID" "UNINSTALLERSCRIPT")
FULLSCRIPTPATH="$INSTALLDIR/$UNINSTALLSCRIPT"
SCRIPTDIR=$(dirname "$FULLSCRIPTPATH")
SCRIPTFILE=$(basename "$FULLSCRIPTPATH")

if [ -d "$SCRIPTDIR" ]
	then
	pushd "$SCRIPTDIR" > /dev/null
	#we change to the scripts directory to cope with badly written scripts
	if [ -n "$UNINSTALLSCRIPT" ] && [ -f "$SCRIPTFILE" ]
		then
			echo "Uninstall script = $FULLSCRIPTPATH" | tee -a "$SCRIPTLOGFILE"
			chmod +x "$SCRIPTFILE" 
			bash ./"$SCRIPTFILE" | tee -a "$SCRIPTLOGFILE"
	else
		echo "No developer uninstall script found" >> "$SCRIPTLOGFILE"
	fi
	popd > /dev/null
else
	echo "No uninstall script dir found"	>> "$SCRIPTLOGFILE"
fi
#--------------------------------------------------------------------------------------------------
#3 Delete the app's files based on what's in .installed_files.txt

echo "Removing app's files." | tee -a "$SCRIPTLOGFILE"

INSTALLEDFILES=".installed_files.txt"

pushd "$INSTALLDIR" > /dev/null

if [ -f "$INSTALLEDFILES" ]
	then
		while read line
			do
				echo "Removing $line" | tee -a "$SCRIPTLOGFILE"
				rm "$line"
		done < "$INSTALLEDFILES"
	
		# Wipe out the remaining dir structure.
		rm -R ./*
else
	echo "Could not find .installed_files.txt. Could not remove files." | tee -a "$SCRIPTLOGFILE"
	exit 1
fi

popd > /dev/null

#--------------------------------------------------------------------------------------------------
#4 Remove the app from the registry

echo "Removing app from XML registry." | tee -a "$SCRIPTLOGFILE"

icreg -r "$PRODUCTID"

if [ "$?" != "0" ]
	then
		"Error when removing app data from XML registry." | tee -a "$SCRIPTLOGFILE"
		exit 1
fi

#--------------------------------------------------------------------------------------------------
echo "Uninstall Complete." | tee -a "$SCRIPTLOGFILE"
#--------------------------------------------------------------------------------------------------
exit $ERRORCODE
