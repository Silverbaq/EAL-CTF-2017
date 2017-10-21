#! /bin/bash
# This script enables logging from the Client.

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

# Delete any lines beginning with '[Logging]', 'GeneralLogLevel' or 'FileLogLevel'
# We're doing this so we can add the new lines cleanly.
sed '/[Logging]\|GeneralLogLevel\|FileLogLevel/d' "$LOGSETTINGSFILE" > "$LOGSETTINGSTEMP"
mv "$LOGSETTINGSTEMP" "$LOGSETTINGSFILE" | tee -a "$SCRIPTLOGFILE"

echo "[Logging]" >> "$LOGSETTINGSFILE"
echo "GeneralLogLevel=3" >> "$LOGSETTINGSFILE"

echo "Logging enabled" | tee -a "$SCRIPTLOGFILE"
echo "Log files will in the future be saved to $USER_HOME/indiecity/pistore/General.log and $USER_HOME/indiecity/pistore/File.log" | tee -a "$SCRIPTLOGFILE"

echo >> "$SCRIPTLOGFILE"
