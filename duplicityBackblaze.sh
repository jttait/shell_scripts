#!/bin/bash

source common.sh
exitIfEnvironmentVariableIsNotSet B2_ACCOUNT_ID
exitIfEnvironmentVariableIsNotSet B2_ACCOUNT_KEY
exitIfEnvironmentVariableIsNotSet B2_DUPLICITY_BUCKET
exitIfEnvironmentVariableIsNotSet PATHS_TO_BACKUP
exitIfEnvironmentVariableIsNotSet DUPLICITY_GPG_KEY
exitIfEnvironmentVariableIsNotSet PATH_TO_RESTORE

B2_URL="b2://${B2_ACCOUNT_ID}:${B2_ACCOUNT_KEY}@${B2_DUPLICITY_BUCKET}"

perform_backup() {
   ARRAY=( $PATHS_TO_BACKUP )
   duplicity --encrypt-key ${DUPLICITY_GPG_KEY} --full-if-older-than 30D --verbosity=5 ${ARRAY[@]} ${B2_URL}
}

perform_restore() {
   duplicity restore --verbosity=5 ${B2_URL} ${PATH_TO_RESTORE}
}

perform_specific_restore() {
   local path="$1"
   duplicity restore --verbosity=5 --file-to-restore $path ${B2_URL} ${PATH_TO_RESTORE}${path}
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
echo "4. Restore all"
echo "5. Restore specific"
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
elif [ $choice == 5 ]
then
   echo -n "Enter path to restore: "
   read path
   perform_specific_restore $path
fi
