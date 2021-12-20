#!/bin/bash

exitIfEnvironmentVariableIsNotSet() {
   VARIABLE_NAME=$1
   VARIABLE_VALUE=${!VARIABLE_NAME}
   if [[ -z ${!VARIABLE_VALUE} ]]
   then
      echo "ERROR: Environment variable $1 is not set!"
      exit 1
   fi
}

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

