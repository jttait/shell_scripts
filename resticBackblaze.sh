#!/bin/bash

source common.sh
exitIfEnvironmentVariableIsNotSet B2_RESTIC_BUCKET
exitIfEnvironmentVariableIsNotSet PATH_TO_BACKUP

perform_backup() {
   restic -r ${B2_RESTIC_BUCKET} --verbose backup ${PATH_TO_BACKUP}
}

echo ""
echo "== RESTIC BACKBLAZE =="
echo ""
echo "1. Backup"
echo ""
echo -n "Enter choice: "
read choice

if [ $choice == 1 ]
then
   perform_backup
fi

