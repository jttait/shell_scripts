#!/bin/bash

PATH_TO_REPO=""
PATH_TO_BACKUP=""

perform_backup() {
   restic -r ${PATH_TO_REPO} --verbose backup ${PATH_TO_BACKUP}
}

echo ""
echo "== RESTIC =="
echo ""
echo "1. Backup"
echo ""
echo -n "Enter choice: "
read choice

if [ $choice == 1 ]
then
   perform_backup
fi

