#!/bin/bash

source common.sh
exitIfEnvironmentVariableIsNotSet B2_RESTIC_BUCKET
exitIfEnvironmentVariableIsNotSet PATHS_TO_BACKUP

perform_backup() {
   ARRAY=( $PATHS_TO_BACKUP )
   restic -r ${B2_RESTIC_BUCKET} --verbose backup ${ARRAY[@]}
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

