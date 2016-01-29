#!/bin/bash
echo "Script started, please wait"
# getting the directory the script is in
scriptdir="$(dirname "$0")"
# sourcing the variables from tartarus.inc
source $scriptdir/tartarus.inc
logger -t $LOGTAG "START"
logger -t $LOGTAG "Running script prior to backup" 
if [ -z $scriptdir/runbefore.bash ]; then
	$scriptdir/runbefore.bash 2>&1 | logger -t $LOGTAG
else
	logger -t $LOGTAG "No jobs to run prior to backup"
fi
# loop that runs through all conf files
cd $basepath
for i in $( ls *.conf); do
	profile=$(echo $i|awk -F'.' '{print $1}')
	logger -t $LOGTAG "Running profile $profile with corresponding config file $i"
	/usr/sbin/charon.ftp --host $ftphost --user $ftpuser --password $ftppass --profile $profile --maxage $ageindays 2>&1 | logger -t $LOGTAG
	/usr/sbin/tartarus $i 2>&1 | logger -t $LOGTAG
done
logger -t $LOGTAG "Running script after backup"
# running jobs after backup finished
if [ -z $scriptdir/runafter.bash ]; then
	$scriptdir/runafter.bash 2>&1 | logger -t $LOGTAG
else
	logger -t $LOGTAG "No jobs to run after backup"
fi
logger -t $LOGTAG "END"
