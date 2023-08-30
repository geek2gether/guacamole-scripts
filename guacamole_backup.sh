#!/bin/bash
####################################
#
# Backup guacamole.
#
####################################

#####################################################
#Guacamole Paths to Backup
backup_guacamole="/etc/guacamole/"
backup_tomcat="/var/lib/tomcat9/webapps/ /var/lib/tomcat9/conf/server.xml"
#####################################################
#Declare some variables
dest="/backup"
#status=$?
day=$(date '+%Y-%m-%d-%-H%M')
hostname=$(hostname -s)
file="$hostname-$day"
logfile=/backup/backup.log
#Create neccesary backup folders
mkdir $dest/$file && mkdir $dest/$file/tomcat && mkdir $dest/$file/database
#Backup guacamole files
echo "Backing up $backup_guacamole, $backup_webapps, $backup_tomcat 'server.xml file' to $dest/$file"
date
echo

cp -r $backup_guacamole $dest/$file/guacamole
cp -r $backup_tomcat $dest/$file/tomcat

echo
echo "Backup finished"
date
#Display backed up files
ls -lh $dest

echo "$day - Backing up entire folder $backup_guacamole, $backup_webapps, and 'server.xml' file in $backup_tomcat to $dest/$file completed" | tee -a "$logfile"
date
echo
#Backup Database
echo "Begining mysql backup ......"
date
sleep 2

mysqldump -v -u root --password=ilovebeth1995! guacamole_db > $dest/$file/database/guacamole_db.sql
if [ $? -eq 0 ]; then
  echo "$day - Mysql database backup was successful" | tee -a "$logfile"
else
  echo "$day - Mysql database backup failed" | tee -a "$logfile"
fi
sleep 2
