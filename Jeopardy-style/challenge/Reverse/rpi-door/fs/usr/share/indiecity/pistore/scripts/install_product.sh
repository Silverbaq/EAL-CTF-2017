#! /bin/bash

#This script will 
#1 dearchive the given file
#2 register product info in the registry as listedin the *_reg.xml
#3 apt-get update and  apt-get any prerequisites as listed in the prereqs file
#4 run the optional dev supplied install script

#-----------------------
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

#-----------------------
#PASSED IN ARGS
INSTALLDIR=""
ZIPFILE=""


while getopts ":d:z:" OPTION
do
	case $OPTION in
	d ) INSTALLDIR=$OPTARG ;;
	z ) ZIPFILE=$OPTARG ;;	
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


#--------------------------------------------------------------------------------------------------
#1 dearchive the given file
echo "Unpacking $ZIPFILE to $INSTALLDIR" | tee -a "$SCRIPTLOGFILE"

# Get the list of files which are going to be installed.
INSTALLEDFILESTXT=".installed_files.txt"
unzip -Z -1 "$ZIPFILE" | awk '/\/$/ {next};{print $0}' > "$INSTALLDIR/$INSTALLEDFILESTXT"

# Continue unzipping the archive
unzip -o "$ZIPFILE" -d "$INSTALLDIR"
ERRORCODE="$?"
if [ "$ERRORCODE" != "0" ]
	then
	exit "$ERRORCODE"
fi
#--------------------------------------------------------------------------------------------------
#2 register product info in the registry as listedin the *_reg.xml
echo "Registering product..." | tee -a "$SCRIPTLOGFILE"
REGFILE=$(find "$INSTALLDIR" -name "*_reg.xml" -print -quit)
#TODO make sure we get the correct reg file 
echo "REGISTERING $REGFILE" >> "$SCRIPTLOGFILE"
PRODUCTID=$(icreg -f "$REGFILE")
echo "PRODUCTID = $PRODUCTID" >> "$SCRIPTLOGFILE"
#TODO check that product id matches expectations for an id 

ERRORCODE="$?"
if [ "$ERRORCODE" != "0" ]
	then
	exit "$ERRORCODE"
fi
#--------------------------------------------------------------------------------------------------
#3.1 apt-get update
echo "Installing Dependencies..." | tee -a "$SCRIPTLOGFILE"
#apt-get update
#TODO quiet output and spinner?
#TODO Is there anypoint in an update if there are no dependencies?

#3.2 apt-get any prerequisites as listed in the prereqs file
PREREQSFILE="$INSTALLDIR/prereqs"
if [ -f "$PREREQSFILE" ]
	then
		NUMDEPS=0
		while read line
			do
				if [ $NUMDEPS -lt 1 ]
					then
						DEPENDENCIES="$line"
				else
					DEPENDENCIES="$DEPENDENCIES"" $line"
				fi
				NUMDEPS=`expr $NUMDEPS + 1`
		done < "$PREREQSFILE"
	
		if [ -n "$DEPENDENCIES" ]
			then						
							
			echo -n "Updating apt-get package lists (this may take several minutes)..." | tee -a "$SCRIPTLOGFILE"		
			apt-get update -qqd &
			spinner $!
							
			# Now get the dependencies:
			MESSAGE="These prerequisite packages will be installed:"
		 
			#echo "$MESSAGE"
			#echo "$DEPENDENCIES"
			echo "$MESSAGE" >> "$SCRIPTLOGFILE"
			echo "$DEPENDENCIES" >> "$SCRIPTLOGFILE"
			echo "" >> "$SCRIPTLOGFILE"
			apt-get install "$DEPENDENCIES"
			ERRORCODE="$?"

			if [ "$ERRORCODE" != "0" ]
				then
				echo "Error installing prereqs" >> "$SCRIPTLOGFILE"
				exit "$ERRORCODE"
			fi
		else
			echo "No Dependencies listed" >> "$SCRIPTLOGFILE"
		fi
else					
	echo "No prereqs file found" >> "$SCRIPTLOGFILE"
fi
#--------------------------------------------------------------------------------------------------
#4 run the optional dev supplied install script
#read the installer script from registry
echo "Check for Install script..." | tee -a "$SCRIPTLOGFILE"
INSTALLSCRIPT=$(icreg -g "$PRODUCTID" "INSTALLERSCRIPT")
FULLSCRIPTPATH="$INSTALLDIR""/""$INSTALLSCRIPT"
#echo "Full script path = $FULLSCRIPTPATH"
#then split
SCRIPTDIR=$(dirname "$FULLSCRIPTPATH")
SCRIPTFILE=$(basename "$FULLSCRIPTPATH")


if [ -d "$SCRIPTDIR" ]
	then
	pushd "$SCRIPTDIR" > /dev/null
	#we change to the scripts directory to cope with badly written scripts
	if [ -f "$SCRIPTFILE" ]
		then
		echo "Install script = $FULLSCRIPTPATH" | tee -a "$SCRIPTLOGFILE"
		chmod +x "$SCRIPTFILE" 
		bash ./"$SCRIPTFILE" | tee -a "$SCRIPTLOGFILE"

	else
		echo "no developer install script found" >> "$SCRIPTLOGFILE"
	fi
	popd > /dev/null
else
	echo "no install script dir found"	>> "$SCRIPTLOGFILE"
fi
#--------------------------------------------------------------------------------------------------
#5 set executable bit on exe file.
EXEFILEPATH=$(icreg -g "$PRODUCTID" "EXE")
FULLEXEPATH="$INSTALLDIR/$EXEFILEPATH"

EXEDIR=$(dirname "$FULLEXEPATH")
EXEFILE=$(basename "$FULLEXEPATH")

if [ -d "$EXEDIR" ]
	then
		pushd "$EXEDIR" > /dev/null
		#we change to the scripts directory to cope with badly written scripts
		if [ -f "$EXEFILE" ]
			then
				echo "Exe file = $FULLEXEPATH" | tee -a "$SCRIPTLOGFILE"
				chmod +x "$EXEFILE" 

		else
			echo "Could not find exe file" >> "$SCRIPTLOGFILE"
		fi
		popd > /dev/null
else
	echo "Could not find exe dir"	>> "$SCRIPTLOGFILE"
fi
#--------------------------------------------------------------------------------------------------
echo "Install Complete." | tee -a "$SCRIPTLOGFILE"
#--------------------------------------------------------------------------------------------------
exit $ERRORCODE
