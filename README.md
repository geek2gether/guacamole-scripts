# guacamole-scripts

The scripts can be used for any guacamole installation.

Just use wget to download the script and make changes to meet your environment.

Guacamole Backup Process:

For guac_backup.sh
 
step 1. wget https://raw.githubusercontent.com/geek2gether/guacamole-scripts/refs/heads/main/guac_backup.sh

step 2. chmod +x guac_backup.sh

step 3. run command: export MYSQL_PASSWORD="your mysql root password"

step 4. sudo ./guac_backup.sh

The script will be completed and a folder is created at "/backup" with the compreesed backup files.


Guacamole Restore Process:

step 1. wget https://raw.githubusercontent.com/geek2gether/guacamole-scripts/refs/heads/main/guac_restore.sh

step 2. chmod +x guac_restore.sh

step 3. run command: export MYSQL_PASSWORD="your mysql root password"

step 4. sudo ./guac_restore.sh /backup/<backup-file> for example ./guac_restore.sh /backup/guac-2024-10-16-0043.tar.gz

