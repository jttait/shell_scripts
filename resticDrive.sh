#!/bin/bash

exitIfEnvironmentVariableIsNotSet() {
   VARIABLE_NAME=$1
   VARIABLE_VALUE=${!VARIABLE_NAME}
   if [[ -z ${VARIABLE_VALUE} ]]
   then
      echo "ERROR: Environment variable $1 is not set!"
      exit 1
   fi
}

exitIfEnvironmentVariableIsNotSet PATH_TO_RESTIC_DRIVE_REPO
exitIfEnvironmentVariableIsNotSet PATHS_TO_BACKUP

perform_backup() {
   ARRAY=( $PATHS_TO_BACKUP )
   restic -r ${PATH_TO_RESTIC_DRIVE_REPO} --verbose backup $ARRAY[@]
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

