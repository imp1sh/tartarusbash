#!/bin/bash
# put that script in /etc/tartarus and just run it manually or via cron for example
# backup files are being deleted that are older than
ageindays=7
ftppass=""
ftpuser=""
ftphost=""
for i in $( ls *.conf); do
	profile=$(echo $i|awk -F'.' '{print $1}')
	/usr/sbin/charon.ftp --host $ftphost --user $ftpuser --password $ftppass --profile $profile --maxage $ageindays
	tartarus $i
done
