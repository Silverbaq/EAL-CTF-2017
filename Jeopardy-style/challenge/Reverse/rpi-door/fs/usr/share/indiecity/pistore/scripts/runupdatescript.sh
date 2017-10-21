#! /bin/bash
#script to run the update client script with root permissions

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#echo $THISDIR/updateclient.sh
UPDATESCRIPT=$THISDIR/updatescript.sh
#echo $UPDATESCRIPT


#exit codes
SUCCESS=0
ERROR=1
CANCELLED=2

#----------------------------------------------------------------------------------
#defaults
ISQUIETMODE=false
DOCLIENTUPDATE=false
DOICELIBUPDATE=false

#----------------------------------------------------------------------------------
#read options
while getopts ":c:i:q:" OPTION
do
	case $OPTION in
	c ) DOCLIENTUPDATE=$OPTARG;;
	i ) DOICELIBUPDATE=$OPTARG;;
	q ) ISQUIETMODE=true ;;
	esac
done

#---------------------------------------------------------------------------------------
if [ -z "$SUDO_USER" ]
	then
		USERNAME="$USER"
else
	USERNAME="$SUDO_USER"
fi

# Set up our logging
USER_HOME=$(awk -F: -v v="$USERNAME" '{if ($1==v) print $6}' /etc/passwd)

SCRIPTLOGFILE="$USER_HOME/indiecity/pistore/Scripts.log"
echo "### $0 - $(date) ###" >> "$SCRIPTLOGFILE"

#---------------------------------------------------------------------------------------



# See if the pistore is running already
CLIENTPROCESS="pistore_real"

RESTART=false

if $DOCLIENTUPDATE; then
PID=$(pidof "$CLIENTPROCESS")
if [ -n "$PID" ] ; then

	RESTART=true
	DOSHUTDOWN=true

	if ! $ISQUIETMODE ; then
		#echo "Do you want to shut down? (Y/n)"
		echo "An update is available for pistore but"
		echo "pistore is running and needs to shutdown before it can be updated"
		read -p "Do you want to stop it and update now? (Y/n)" -n 1 -s KEY
		echo
	
		if [ "$KEY" == "n" ] ; then
			DOSHUTDOWN=false
		fi
	fi

	if $DOSHUTDOWN ; then
		# Keep looping round until we determine that the pistore has shut itself down.
		CYCLES=0
		while [ -n "$PID" ]
			do
			   
				kill $PID
				sleep 1
				PID=$(pidof "$CLIENTPROCESS")
				sleep 2
		
				# Increment our cycles count. We want to timeout after 10 failed checks (30s).
				CYCLES=$[CYCLES+1]

				if [ $CYCLES -ge 10 ]
					then
						echo "ERROR: pistore doesn't seem to be shutting down. Can't continue." | tee -a "$SCRIPTLOGFILE"
						exit $ERROR
				fi
		done
		echo "pistore is now closed" >> "$SCRIPTLOGFILE"
	else
		echo "Update Cancelled" >> "$SCRIPTLOGFILE"
		exit $CANCELLED
	fi

fi
fi

#clear sudo password cache
sudo -k

# Check if the user requires sudo password entry
sudo -n true &> /dev/null

if [ "\$?" != "0" ]
	then
		SUDOPASSWD=true
else
	SUDOPASSWD=false
fi
		echo
		echo "This script will now:"
		echo "* Run apt-get update to update repository information."
if $DOCLIENTUPDATE ;  then
		echo "* Use apt-get to download and update the latest pistore package."
fi 
if $DOICELIBUPDATE ; then
		echo "* Use apt-get to download and update the latest icelib package."
fi
		echo

if [ $SUDOPASSWD ]
	then
		echo "This script needs root permissions."
		echo
		echo "Please type in your password if you want to continue:"
fi

sudo $UPDATESCRIPT -c $DOCLIENTUPDATE -i $DOICELIBUPDATE

ERRORCODE="$?"

if [ "$ERRORCODE" != "0" ];  then
        echo "Client update failed." | tee -a "$SCRIPTLOGFILE"
        read -p "**** Press any key to continue ****" -n 1 -s

        exit $ERROR
fi


echo "Update complete" | tee -a "$SCRIPTLOGFILE"


# Restart the new pistore 

# DW - I Cant get the client to restart and then not be shutdown when the terminal finishes
#      so I'm commenting this all out for now
#		have tried :
# 		#a.out > /dev/null 2>& 1 &
#		nohup
# 		disown
#	#nohup
#	#nohup lxterminal -t "TEst" &
#	#nohup sudo lxterminal -t "TEst2" &
#	#lxterminal -t "Test3" &
#	#nohup sg indiecity  lxterminal -t "Test4" &
#	#nohup pistore-debug &
#	#pistore-debug > /dev/null 2>& 1 &
#	and although these seem to work for other apps the client always closes when this script finishes

if $DOCLIENTUPDATE ; then


if ! $ISQUIETMODE ; then

	echo
	read -p "Would you like to start pistore now? (Y/n)" -s -n 1 KEY
	echo 

	if [ $KEY == "n" ];then
		RESTART=false
	else
		RESTART=true
	fi
fi


if $RESTART ; then
	echo "Restarting pistore ..." | tee -a "$SCRIPTLOGFILE"

	pistore 
fi

fi

#add a space in log file
echo >> "$SCRIPTLOGFILE"
exit $SUCCESS
