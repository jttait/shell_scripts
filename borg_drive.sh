#!/bin/bash

set -eu

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

source "${SCRIPT_DIR}/linux.sh"
source "${SCRIPT_DIR}/secrets.sh"

exitIfEnvironmentVariableIsNotSet PATH_TO_BORG_DRIVE_REPO
exitIfEnvironmentVariableIsNotSet PATHS_TO_BACKUP

list_backups() {
   borg list "${PATH_TO_BORG_DRIVE_REPO}"
}

perform_backup() {
   local unix_epoch_time=$(date +%s)
   borg create --stats --progress --compression lz4 \
      "${PATH_TO_BORG_DRIVE_REPO}::${unix_epoch_time}" \
      "${PATHS_TO_BACKUP[@]}"
}

perform_restore_all() {
   local latest_archive=$(borg list "${PATH_TO_BORG_DRIVE_REPO}" --last 1 | awk '{print $1}')
   borg extract --progress "${PATH_TO_BORG_DRIVE_REPO}::${latest_archive}"
}

perform_specific_restore() {
   local archive="$1"
   local path="$2"
   borg extract --progress "${PATH_TO_BORG_DRIVE_REPO}::${archive}" "${path}"
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

if [[ "$choice" == 1 ]]
then
   perform_backup
elif [[ "$choice" == 2 ]]
then
   list_backups
elif [[ "$choice" == 3 ]]
then
   echo -n "Enter path to restore to: "
   read path
   mkdir "${path}/borg_restore"
   cd "${path}/borg_restore"
   perform_restore_all
elif [[ "$choice" == 4 ]]
then
   list_backups
   echo -n "Enter archive to restore: "
   read archive
   echo -n "Enter path to restore: "
   read path
   perform_specific_restore "$archive" "$path"
else
   echo -e "${RED}Unrecognised choice: ${choice}${NC}"
   exit 1
fi

