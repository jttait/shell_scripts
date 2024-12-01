#!/bin/bash

source linux.sh
source secrets.sh

exitIfEnvironmentVariableIsNotSet PATH_TO_BORG_DRIVE_REPO
exitIfEnvironmentVariableIsNotSet PATHS_TO_BACKUP

list_backups() {
   borg list ${PATH_TO_BORG_DRIVE_REPO}
}

perform_backup() {
   unixEpochTime=`date +%s`
   borg create --stats --progress --compression lz4 \
      ${PATH_TO_BORG_DRIVE_REPO}::${unixEpochTime} \
      ${PATHS_TO_BACKUP[@]}
}

perform_restore_all() {
   LATEST_ARCHIVE=$(borg list ${PATH_TO_BORG_DRIVE_REPO} --last 1 | awk '{print $1}')
   borg extract --progress ${PATH_TO_BORG_DRIVE_REPO}::${LATEST_ARCHIVE}
}

perform_specific_restore() {
   borg extract --progress ${PATH_TO_BORG_DRIVE_REPO}::$1 $2
}

echo ""
echo "== BORG DRIVE =="
echo ""
echo "1. Backup"
echo "2. List"
echo "3. Restore all"
echo "4. Restore specific"
echo ""
echo -n "Enter choice: "
read choice

if [ $choice == 1 ]
then
   perform_backup
elif [ $choice == 2 ]
then
   list_backups
elif [ $choice == 3 ]
then
   perform_restore_all
elif [ $choice == 4 ]
then
   list_backups
   echo -n "Enter archive to restore: "
   read archive
   echo -n "Enter path to restore: "
   read path
   perform_specific_restore $archive $path
fi

