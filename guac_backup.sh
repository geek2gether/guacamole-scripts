#!/bin/bash
####################################
#
# Backup Guacamole and Tomcat.
#
####################################

#####################################################
# Guacamole Paths to Backup
backup_guacamole="/etc/guacamole/"
backup_tomcat_webapps="/var/lib/tomcat9/webapps/"
backup_tomcat_conf="/var/lib/tomcat9/conf/server.xml"
#####################################################

# Declare some variables
dest="/backup"
day=$(date '+%Y-%m-%d-%H%M')
hostname=$(hostname -s)
file="$hostname-$day"
logfile="$dest/backup.log"
mysql_user="root"
mysql_password="${MYSQL_PASSWORD:-mysecurepassword}" # Use env var if available
database_name="guacamole_db"

# Create necessary backup folder, including the /backup directory
mkdir -p "$dest/$file/database" "$dest/$file/tomcat"

# Log rotation: Keep only last 7 log files
if [ -d "$dest" ]; then
    find "$dest"/*.log -mtime +7 -exec rm {} \;
fi

# Backup guacamole and Tomcat files
echo "[$(date)] Backing up $backup_guacamole and Tomcat files to be archived" | tee -a "$logfile"
cp -ra $backup_guacamole "$dest/$file/guacamole" || echo "[$(date)] Error copying $backup_guacamole" | tee -a "$logfile"
cp -ra $backup_tomcat_webapps "$dest/$file/tomcat/webapps" || echo "[$(date)] Error copying $backup_tomcat_webapps" | tee -a "$logfile"
cp -ra $backup_tomcat_conf "$dest/$file/tomcat/server.xml" || echo "[$(date)] Error copying $backup_tomcat_conf" | tee -a "$logfile"

# Backup MySQL Database
echo "[$(date)] Beginning MySQL backup ..." | tee -a "$logfile"
mysqldump -u "$mysql_user" --password="$mysql_password" "$database_name" > "$dest/$file/database/guacamole_db.sql"

if [ $? -eq 0 ]; then
  echo "[$(date)] MySQL database backup was successful" | tee -a "$logfile"
else
  echo "[$(date)] MySQL database backup failed" | tee -a "$logfile"
fi

# Compress all backup files into one tar.gz file
echo "[$(date)] Compressing backup files into $file.tar.gz ..." | tee -a "$logfile"
tar -czf "$dest/$file.tar.gz" -C "$dest" "$file"

# Remove the uncompressed backup folder after compression
rm -rf "$dest/$file"

# List the backup file to verify
ls -lh "$dest/$file.tar.gz" | tee -a "$logfile"

echo "[$(date)] Backup script completed" | tee -a "$logfile"
