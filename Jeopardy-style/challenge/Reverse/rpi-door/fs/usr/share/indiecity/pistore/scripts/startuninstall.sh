#! /bin/bash
#This script will launch the uninstall_product.sh script using sudo

while getopts ":n:d:i:" OPTION
do
	case $OPTION in
	n ) GAMENAME=$OPTARG ;;
	d ) INSTALLDIR=$OPTARG ;;
	i ) PRODUCTID=$OPTARG ;;
	esac
done


echo "This script will uninstall $GAMENAME but needs root permissions to do so"
echo "Please type in your password"
sudo -k
sudo ./uninstall_product.sh -d "$INSTALLDIR" -i "$PRODUCTID"

ERRORCODE=$?
#echo "The exitcode is $ERRORCODE"

# Set up our logging
if [ -z "$SUDO_USER" ]
	then
		USERNAME="$USER"
else
	USERNAME="$SUDO_USER"
fi
USER_HOME=$(awk -F: -v v="$USERNAME" '{if ($1==v) print $6}' /etc/passwd)


SCRIPTLOGFILE="$USER_HOME"/indiecity/pistore/Scripts.log
ERRORFILE="$USER_HOME/indiecity/pistore/script_errorcode"

# Remove the error file in case there's a residual one from a previous process.
if [ -f "$ERRORFILE" ]
	then
		rm "$ERRORFILE"
fi

# Write the error code out to a file so the Pi Store can pick it up.
# We want to write this out, even if it's 0.
echo "$ERRORCODE" > "$ERRORFILE"
chown $USERNAME $ERRORFILE

echo 

if [ "$ERRORCODE" != "0" ]
	then
		echo "Uninstall failed."
else
	echo "Uninstall successful."
fi

read -p "**** Press any key to continue ****" -n 1 -s 

exit $ERRORCODE
