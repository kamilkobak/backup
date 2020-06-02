#!/bin/bash
####################################################
# Backup of all PostgreSQL databases               #
# Author: Kamil Kobak                              #
####################################################


BACKUP_DIR=/var/backup
LOGS=/var/log/postgres_backup.log
DAYS_TO_KEEP=14
FILE_SUFFIX=_pg_backup.sql
HOSTNAME=
PORT=
USERNAME=

#Tag in logs
SYSLOGTAG=PostgreSQL-Backup

# Password
# create a file $HOME/.pgpass containing a line like this:
#   hostname:*:*:dbuser:dbpass
# replace hostname with the value of HOSTNAME and dbuser with the value of USERNAME
# chmod 0600 $HOME/.pgpass


FILE=`date +"%Y%m%d%H%M"`${FILE_SUFFIX}
OUTPUT_FILE=${BACKUP_DIR}/${FILE}


# Check variables
if [ ! -e "$BACKUP_DIR" ]
    then
    mkdir -p "$BACKUP_DIR"
fi

if [ ! $HOSTNAME ]; then
    HOSTNAME="localhost"
fi;
 
if [ ! $USERNAME ]; then
    USERNAME="postgres"
fi;

if [ ! $PORT ]; then
    PORT=5432
fi;



# do the all database backup
if ! pg_dumpall -h "$HOSTNAME" -p "$PORT" -U "$USERNAME" -f $OUTPUT_FILE.in_progress; then
        # Log backup end time in /var/log/messages
        logger -i -t ${SYSLOGTAG} "Backup failed !"
else
        mv $OUTPUT_FILE.in_progress $OUTPUT_FILE
        gzip $OUTPUT_FILE

        # prune old backups
        find $BACKUP_DIR -maxdepth 1 -mtime +$DAYS_TO_KEEP -name "*${FILE_SUFFIX}.gz" -exec rm -rf '{}' ';'

        # Log backup end time in /var/log/messages
        logger -i -t ${SYSLOGTAG} "${OUTPUT_FILE}.gz was created."

fi

