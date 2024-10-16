#!/bin/bash
####################################
#
# Restore Guacamole and Tomcat.
#
####################################

#####################################################
# Guacamole and Tomcat restore paths
restore_guacamole="/etc/guacamole/"
restore_tomcat_webapps="/var/lib/tomcat9/webapps/"
restore_tomcat_conf="/var/lib/tomcat9/conf/server.xml"
#####################################################

# Declare some variables
backup_dir="/backup"
backup_file="$1"  # Passed as an argument
logfile="$backup_dir/restore.log"
mysql_user="root"
mysql_password="${MYSQL_PASSWORD:-mysecurepassword}"  
database_name="guacamole_db"

# Check if the backup file exists
if [ -z "$backup_file" ]; then
    echo "Usage: $0 <backup-file.tar.gz>" | tee -a "$logfile"
    exit 1
fi

if [ ! -f "$backup_dir/$backup_file" ]; then
    echo "Backup file $backup_file not found in $backup_dir" | tee -a "$logfile"
    exit 1
fi

# Extract the backup file
echo "[$(date)] Extracting backup file $backup_file ..." | tee -a "$logfile"
tar -xzf "$backup_dir/$backup_file" -C "$backup_dir"
if [ $? -ne 0 ]; then
    echo "[$(date)] Error extracting backup file $backup_file" | tee -a "$logfile"
    exit 1
fi

# Find the extracted folder (assuming it's named based on hostname and timestamp)
extracted_folder=$(basename "$backup_file" .tar.gz)

# Restore Guacamole files
echo "[$(date)] Restoring Guacamole files to $restore_guacamole" | tee -a "$logfile"
cp -ra "$backup_dir/$extracted_folder/guacamole/"* "$restore_guacamole" || echo "[$(date)] Error restoring Guacamole files" | tee -a "$logfile"

# Restore Tomcat files
echo "[$(date)] Restoring Tomcat webapps to $restore_tomcat_webapps" | tee -a "$logfile"
cp -ra "$backup_dir/$extracted_folder/tomcat/webapps/"* "$restore_tomcat_webapps" || echo "[$(date)] Error restoring Tomcat webapps" | tee -a "$logfile"

echo "[$(date)] Restoring Tomcat server.xml to $restore_tomcat_conf" | tee -a "$logfile"
cp -ra "$backup_dir/$extracted_folder/tomcat/server.xml" "$restore_tomcat_conf" || echo "[$(date)] Error restoring Tomcat server.xml" | tee -a "$logfile"

# Restore MySQL Database
echo "[$(date)] Restoring MySQL database $database_name ..." | tee -a "$logfile"
mysql -u "$mysql_user" --password="$mysql_password" "$database_name" < "$backup_dir/$extracted_folder/database/guacamole_db.sql"

if [ $? -eq 0 ]; then
  echo "[$(date)] MySQL database restore was successful" | tee -a "$logfile"
else
  echo "[$(date)] MySQL database restore failed" | tee -a "$logfile"
fi

#Restart services [tomcat and mysql]
sleep 10
echo "[$(date)] Restarting services .. [Tomcat9 and Mysql]" | tee -a "$logfile"
systemctl restart tomcat9 mysql


echo "[$(date)] Restore process completed" | tee -a "$logfile"
