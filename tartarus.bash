#!/bin/bash
scriptdir="$(dirname "$0")"
source $scriptdir/tartarus.inc
for i in $( ls $basepath/*.conf); do
	profile=$(echo $i|awk -F'.' '{print $1}')
	/usr/sbin/charon.ftp --host $ftphost --user $ftpuser --password $ftppass --profile $profile --maxage $ageindays
	tartarus $i
done
