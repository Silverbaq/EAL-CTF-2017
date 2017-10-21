#! /bin/bash
# This script /disables/ logging from the Client.

if [ -z "$SUDO_USER" ]
	then
		USERNAME="$USER"
else
	USERNAME="$SUDO_USER"
fi

USER_HOME=$(awk -F: -v v="$USERNAME" '{if ($1==v) print $6}' /etc/passwd)

SCRIPTLOGFILE="$USER_HOME"/indiecity/pistore/Scripts.log
echo "### $0 - $(date) ###" >> "$SCRIPTLOGFILE"

LOGSETTINGSFILE="$USER_HOME"/.config/pistore.conf
echo "LOGSETTINGSFILE=$LOGSETTINGSFILE" >> "$SCRIPTLOGFILE"

LOGSETTINGSTEMP="$USER_HOME"/.config/pistore.tmp
echo "LOGSETTINGSTEMP=$LOGSETTINGSTEMP" >> "$SCRIPTLOGFILE"

# Delete any lines beginning with 'GeneralLogLevel' or 'FileLogLevel'
sed '/GeneralLogLevel\|FileLogLevel/d' "$LOGSETTINGSFILE" > "$LOGSETTINGSTEMP" | tee -a "$SCRIPTLOGFILE"

mv "$LOGSETTINGSTEMP" "$LOGSETTINGSFILE" | tee -a "$SCRIPTLOGFILE"

echo "Logging disabled" | tee -a "$SCRIPTLOGFILE"

echo >> "$SCRIPTLOGFILE"
