#! /bin/bash
#pi specific script to run the update client script in own terminal
THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#echo $THISDIR/updateclient.sh
UPDATESCRIPT=$THISDIR/updateclient.sh
#echo $UPDATESCRIPT

#xterm -T "Client Update" -C $UPDATESCRIPT 
lxterminal -t "Client Update" -e $UPDATESCRIPT 

