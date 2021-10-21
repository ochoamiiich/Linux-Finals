# vi /opt/shell-scripts/mysql_backup_1.sh

#!/bin/bash

echo "########## ACCESSING MYSQL DB NOW ##########"
MYSQL_PASSWORD="root"
DATE=$(date +'%m%d%y') 

echo "########## CREATING BACKUP DIRECTORY NOW ##########"
BACKUP_DIR="/opt/backups"
mkdir /opt/backups
DB=wordpress

echo "########## EXPORTING AND COMPRESSING MYSQL DB NOW ##########"
echo $DB
mysqldump -u root -p$MYSQL_PASSWORD $DB | gzip -9 > "$BACKUP_DIR/wordpress_$DATE.sql.gz"