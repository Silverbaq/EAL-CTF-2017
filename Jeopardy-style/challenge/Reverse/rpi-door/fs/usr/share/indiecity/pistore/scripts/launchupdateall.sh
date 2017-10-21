#! /bin/bash
#script to run the script that actually runs the update script
#reason for this is because I cant pass arguments through to script 

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#echo $THISDIR/updateclient.sh
$THISDIR/runupdatescript.sh -c true -i true
