#!/bin/bash
scriptdir="$(dirname "$0")"
source $scriptdir/tartarus.inc
logger -t $LOGTAG "script begins"
logger -t $LOGTAG "Executing in $scriptdir"
for i in $( ls $basepath/*.conf); do
	logger -t $LOGTAG "Running profile $i"
	profile=$(echo $i|awk -F'.' '{print $1}')
	/usr/sbin/charon.ftp --host $ftphost --user $ftpuser --password $ftppass --profile $profile --maxage $ageindays 2>&1 | logger -t $LOGTAG
	/usr/sbin/tartarus $i 2>&1 | logger -t $LOGTAG
done
logger -t $LOGTAG "script end"
