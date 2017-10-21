#! /bin/bash
# This script adds a user account to the indiecity group.
# Membership of this group is required to run Pi Store.

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

OSGROUPS=$(groups)
echo "OSGROUPS=$OSGROUPS" >> "$SCRIPTLOGFILE"

#make sure that indiecity group exists
if [[ "$OSGROUPS" != *indiecity* ]]
	then
		echo "Pi Store would like your permission to create an 'indiecity' group on this Pi. You may have to enter your sudo password."
		sudo addgroup indiecity | tee -a "$SCRIPTLOGFILE"

		# Check if the addgroup command executed successfully.
		if [ "$?" != "0" ]
			then
				echo "ERROR: Could not add indiecity group." | tee -a "$SCRIPTLOGFILE"
				echo >> "$SCRIPTLOGFILE"
				exit 1;
		fi

		echo "Added indiecity group." | tee -a "$SCRIPTLOGFILE"
fi

# If the user to add hasn't been specified, we'll assume it's the current user to be added.
if [ -z "$1" ]
	then
		USERTOADD="$USERNAME"
else
	USERTOADD="$1"
fi

echo "USERTOADD=$USERTOADD" >> "$SCRIPTLOGFILE"

echo "Pi Store would like your permission to add the user '$USERTOADD' to the indiecity usergroup. You may have to enter your sudo password."
sudo usermod -aG indiecity "$USERTOADD" | tee -a "$SCRIPTLOGFILE"

# Check if the usermod command executed successfully
if [ "$?" != "0" ]
	then
		echo "ERROR: Could not add user '$USERNAME' to indiecity group." | tee -a "$SCRIPTLOGFILE"
		echo >> "$SCRIPTLOGFILE"
		exit 1;
fi

echo >> "$SCRIPTLOGFILE"
