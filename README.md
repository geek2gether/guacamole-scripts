# guacamole-scripts

The scripts can be used for any guacamole installation.

Just use wget to download the script and make changes to meet your environment.

Usage:

For guacamole_backup.sh
 
step 1. wget https://raw.githubusercontent.com/geek2gether/guacamole-scripts/main/guacamole_backup.sh

step 2. Open the script and set dest=/backup to be the absolute path of your backup location e.g dest=/backups/guacamole.

Step 3. On line 43, replace the password with your mysql root user password.

step 4. chmod +x guacamole_backup.sh

step 5. sudo sh guacamole_backup.sh

Thank you.
