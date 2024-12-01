#!/bin/bash

source linux.sh
source secrets.sh

export B2_ACCOUNT_ID=$B2_ACCOUNT_ID
export B2_ACCOUNT_KEY=$B2_ACCOUNT_KEY

exitIfEnvironmentVariableIsNotSet B2_RESTIC_BUCKET
exitIfEnvironmentVariableIsNotSet PATHS_TO_BACKUP

perform_backup() {
   restic backup --repo b2:${B2_RESTIC_BUCKET} --verbose ${PATHS_TO_BACKUP[@]}
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

