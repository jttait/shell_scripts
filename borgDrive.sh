#!/bin/bash

unixEpochTime=`date +%s`

list_backups() {
   borg list ${PATH_TO_BORG_DRIVE_REPO}
}

perform_backup() {
   borg create --stats --progress --compression lz4 ${PATH_TO_BORG_DRIVE_REPO}::${unixEpochTime} ${PATH_TO_BACKUP}
}

echo ""
echo "== BORG =="
echo ""
echo "1. Backup"
echo "2. List"
echo ""
echo -n "Enter choice: "
read choice

if [ $choice == 1 ]
then
   perform_backup
elif [ $choice == 2 ]
then
   list_backups
fi

