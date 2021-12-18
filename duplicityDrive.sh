#!/bin/bash

source common.sh
exitIfEnvironmentVariableIsNotSet DUPLICITY_GPG_KEY
exitIfEnvironmentVariableIsNotSet PATH_TO_BACKUP
exitIfEnvironmentVariableIsNotSet PATH_TO_DUPLICITY_DRIVE_REPO

perform_backup() {
   duplicity --encrypt-key ${DUPLICITY_GPG_KEY} --full-if-older-than 30D --verbosity=5 ${PATH_TO_BACKUP} ${PATH_TO_DUPLICITY_DRIVE_REPO}
}

perform_restore() {
   duplicity restore ${PATH_TO_DUPLICITY_DRIVE_REPO} ${PATH_TO_RESTORE} --verbosity=5
}

cleanup_failures() {
   duplicity cleanup --force ${PATH_TO_DUPLICITY_DRIVE_REPO}
}

only_keep_last_2_full_backups() {
   duplicity remove-all-but-n-full 2 --force ${PATH_TO_DUPLICITY_DRIVE_REPO}
   duplicity remove-all-inc-of-but-n-full 2 --force ${PATH_TO_DUPLICITY_DRIVE_REPO}
}

remove_files_older_than_90_days() {
   duplicity remove-older-than 90D --force ${PATH_TO_DUPLICITY_DRIVE_REPO}
}

backup () {
   perform_backup
   only_keep_last_2_full_backups
   remove_files_older_than_90_days
   cleanup_failures
}

collection_status () {
   duplicity collection-status ${PATH_TO_DUPLICITY_DRIVE_REPO}
}

list_files () {
   duplicity list-current-files ${PATH_TO_DUPLICITY_DRIVE_REPO}
}

echo ""
echo "== DUPLICITY =="
echo ""
echo "1. Backup"
echo "2. Collection status"
echo "3. List files"
echo "4. Restore"
echo ""
echo -n "Enter choice: "
read choice

if [ $choice == 1 ]
then
   backup
elif [ $choice == 2 ]
then
   collection_status
elif [ $choice == 3 ]
then
   list_files
elif [ $choice == 4 ]
then
   perform_restore
fi
