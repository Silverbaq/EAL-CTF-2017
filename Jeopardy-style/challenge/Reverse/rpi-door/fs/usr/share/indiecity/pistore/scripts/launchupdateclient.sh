#! /bin/bash
#script to run the runupdatescript with the right args

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$THISDIR/runupdatescript.sh -c true

