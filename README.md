# tartarusbash
backs up all *.conf tartarus profiles via ftp in one go and also deletes old files on backup server. Only runs full backup, no incremental or differential supported.

# howto
* tartarus is already installed and setup in a basic fashion
* Here are some links:
 http://wertarbyte.de/tartarus.shtml
 http://wiki.hetzner.de/index.php/Tartarus_Backup-Konfiguration
* git clone https://github.com/imp1sh/tartarusbash.git
* cp tartarus.inc.template tartarus.inc
* if you like:
* cp runbefore.bash.template runbefore.bash and
* cp runafter.bash.template runafter.bash
* edit tartarus.inc
* run tartarus.bash either manually or e.g. via cron
* make sure the NAME parameter in the tartarus.conf is the same as the filename of the conf file itself, but without the .conf at the end
