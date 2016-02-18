#!/bin/bash
echo "Script started, please wait"
# getting the directory the script is in
scriptdir="$(dirname "$0")"
# sourcing the variables from tartarus.inc

if [ ! -f $scriptdir/tartarus.inc ]; then
	echo "File $scriptdir/tartarus.inc doesn not exist, but it has to in order for the script to work. Please copy it over from the template and fill it with live!"
	echo "exiting"
	exit 1
else
	source $scriptdir/tartarus.inc
fi

# install tartarus apt repo list
if [ ! -f /etc/apt/sources.list.d/wertarbyte.list ]; then
	wget -O /etc/apt/sources.list.d/wertarbyte.list http://wertarbyte.de/apt/wertarbyte-apt.list
	wget -O - http://wertarbyte.de/apt/software-key.gpg | apt-key add -
	echo "repo setup under /etc/apt/sources.list.d/wertarbyte.list"
else
	echo "repo not created, already there in /etc/apt/sources.list.d/wertarbyte.list."
fi

# install packages
packages="tartarus pwgen"
for package in $packages; do
	dpkg -l $package
	if [ ! $? -eq 0 ]; then
		apt-get update
		apt-get -y install $package
		echo "$package installed."
	else
		echo "$package not installed, probably already there."
	fi
done

# create /etc/tartarus if not yet there
if [ ! -d $basepath ]; then
	mkdir $basepath
	echo "folder $basepath created."
else
	echo "folder $basepath not created. Probably already there."
fi

# creates encryption key if not yet there
if [ ! -f $basepath/$enckeyfile ]; then
	echo `pwgen -s 30` > $basepath/$enckeyfile
	echo "encryption key written to $basepath/$enckeyfile."
else
	echo "encryption key not written, already there."
fi

# create generic.inc if not yet there
if [ ! -f $basepath/generic.inc ]; then
cat <<EOF > $basepath/generic.inc
# /etc/tartarus/generic.inc
# Generische Einstellungen für die Sicherung
# auf den Hetzner-FTP-Server
STORAGE_FTP_SSL_INSECURE="yes"
STORAGE_METHOD="FTP"
# Adresse des FTP-Server
STORAGE_FTP_SERVER="$ftphost"
# FTP-Zugangsdaten
STORAGE_FTP_USER="$ftpuser"
STORAGE_FTP_PASSWORD="$ftppass"
# Übertragung verschlüsseln und SFTP verwenden
STORAGE_FTP_USE_SFTP="no"

# Kompression
COMPRESSION_METHOD="bzip2"
# Größe des LVM-Snapshots
LVM_SNAPSHOT_SIZE="1000M"

# Backup-Daten symmetrisch verschlüsseln
ENCRYPT_SYMMETRICALLY="yes"
# Passwort aus /etc/tartarus/backup.sec lesen
ENCRYPT_PASSPHRASE_FILE="/etc/tartarus/backup.sec"

# Während der Erstellung der Sicherung nicht über
# Dateisystemgrenzen hinausgehen
STAY_IN_FILESYSTEM="yes"
EOF
	echo "file $basepath/generic.inc created."
else
	echo "file $basepath/generic.inc not created, already there."
fi

for backupelement in $backuplist; do
	together=${hostnameshort}_${backupelement}
	echo $together
	if [ ! -f "$basepath/$hostnameshort_$backupelement.conf" ]; then
		if [ "$backupelement" = "usrlocal" ]; then
			backupelement="usr/local"
		fi
		cat <<EOF > "$basepath/$together.conf"
# $basepath/$together.conf
#
# Allgemeine Einstellungen einlesen
source $basepath/generic.inc
# Name des Sicherungsprofils
NAME="$together"
# Verzeichnis / sichern
DIRECTORY="/$backupelement"
# Keine temporären Dateien sichern
# mehrere Ordner durch Leerzeichen trennen
EXCLUDE=""
# keinen LVM-Snapshot erstellen
CREATE_LVM_SNAPSHOT="no"
EOF
	echo "file $basepath/$together written."
	else
		echo "$basepath/$together.conf already there, not being created."
	fi
done

echo "############################################################################################"
echo "Please write down the passphrase that will be used to cyrpt the backup and store it safely."
cat $basepath/$enckeyfile
echo "############################################################################################"
