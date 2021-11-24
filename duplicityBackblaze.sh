B2_KEY_ID=""
B2_APP_KEY=""
B2_BUCKET=""
B2_URL="b2://${B2_KEY_ID}:${B2_APP_KEY}@${B2_BUCKET}"

BACKUP_DIR="~/backup/"
RESTORE_DIR="~/restore/"
GPG_KEY=""


perform_backup() {
   duplicity --encrypt-key ${GPG_KEY} --full-if-older-than 30D --verbosity=5 ${BACKUP_DIR} ${B2_URL}
}

perform_restore() {
   duplicity restore --verbosity=5 ${B2_URL} ${RESTORE_DIR}
}

perform_specific_restore() {
   local path="$1"
   duplicity restore --verbosity=5 --file-to-restore $path ${B2_URL} ${RESTORE_DIR}${path}
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
