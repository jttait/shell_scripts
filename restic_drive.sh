#!/bin/bash

source linux.sh
source secrets.sh

exitIfEnvironmentVariableIsNotSet PATH_TO_RESTIC_DRIVE_REPO
exitIfEnvironmentVariableIsNotSet PATHS_TO_BACKUP

perform_backup() {
   restic backup --repo ${PATH_TO_RESTIC_DRIVE_REPO} --verbose ${PATHS_TO_BACKUP[@]}
}

perform_restore_all() {
   RESTORE_PATH=$(echo $1)
   restic -r ${PATH_TO_RESTIC_DRIVE_REPO} restore latest --target $RESTORE_PATH
}

echo ""
echo "== RESTIC DRIVE =="
echo ""
echo "1. Backup"
echo "2. Restore"
echo ""
echo -n "Enter choice: "
read choice

if [ $choice == 1 ]
then
   perform_backup
elif [ $choice == 2 ]
then
   echo -n "Enter location to restore to: "
   read path
   perform_restore_all $path
fi

