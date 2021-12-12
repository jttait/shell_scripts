#!/bin/bash

B2_URL="file:///"

BACKUP_DIR="~/backup/"
RESTORE_DIR="~/restore/"

GPG_KEY=""

perform_backup() {
   duplicity --encrypt-key ${GPG_KEY} --full-if-older-than 30D --verbosity=5 ${BACKUP_DIR} ${B2_URL}
}

perform_restore() {
   duplicity restore ${B2_URL} ${RESTORE_DIR} --verbosity=5
}

cleanup_failures() {
   duplicity cleanup --force ${B2_URL}
}

only_keep_last_2_full_backups() {
   duplicity remove-all-but-n-full 2 --force ${B2_URL}
   duplicity remove-all-inc-of-but-n-full 2 --force ${B2_URL}
}

remove_files_older_than_90_days() {
   duplicity remove-older-than 90D --force ${B2_URL}
}

backup () {
   perform_backup
   only_keep_last_2_full_backups
   remove_files_older_than_90_days
   cleanup_failures
}

collection_status () {
   duplicity collection-status ${B2_URL}
}

list_files () {
   duplicity list-current-files ${B2_URL}
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
