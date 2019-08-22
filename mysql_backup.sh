#!/bin/bash
####################################################
# Backup of all MySQL databases in separate files. #
####################################################

#MySQL credentials
USER="root"
PASSWORD="some_password"
HOST="192.168.250.12"

# Destination Catalog (without last /)
BACKUP_DIR="/media/cephfs"

# How many days to keep copies
NUM_BACKUP=30

#date in file name
DATE=`date +%Y%m%d-%H%M%S`

#Tag in logs
SYSLOGTAG=MySQL-Backup

#Email address for notifications
EMAIL="logs@some.com"

#get list of databases
    databases=`mysql -h $HOST -u $USER -p$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
    ERR=$?
    if [ $ERR != 0 ]; then
      # Log backup end time in /var/log/messages
      logger -i -t ${SYSLOGTAG} "Error $listabaz - getting database list"
      # Sending notification by email
      echo "Error getting database list" | mail -s "MySQL Backup error" $EMAIL
    fi

#Backup
for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump -h $HOST -u $USER -p$PASSWORD --databases $db > $BACKUP_DIR/$DATE.$db.sql

       ERR=$?
       if [ $ERR != 0 ]; then
         # Log backup end time in /var/log/messages
         logger -i -t ${SYSLOGTAG} "MySQL Database Backup FAILED; Database: $db. $kopia"
         #Sending notification by email
         echo "$ERR: MySQL backup error: $db" | mail -s "MySQL Backup error - $db" $EMAIL
       else
         #Compression
         gzip $BACKUP_DIR/$DATE.$db.sql
         #Deleting older copies
         find $BACKUP_DIR -type f -prune -mtime +$NUM_BACKUP -exec rm -f {} \;
         # Log backup end time in /var/log/messages
         logger -i -t ${SYSLOGTAG} "MySQL Database Backup Successful; Database: $db"
       fi

    fi
done

# Checking backup logs:  cat /var/log/messages | grep MySQL-Backup
