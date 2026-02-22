#!/bin/bash

set -eu

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

source "${SCRIPT_DIR}/linux.sh"
source "${SCRIPT_DIR}/secrets.sh"

exitIfEnvironmentVariableIsNotSet B2_ACCOUNT_ID
exitIfEnvironmentVariableIsNotSet B2_ACCOUNT_KEY
exitIfEnvironmentVariableIsNotSet B2_RESTIC_BUCKET
exitIfEnvironmentVariableIsNotSet PATHS_TO_BACKUP

perform_backup() {
   restic backup --repo "b2:${B2_RESTIC_BUCKET}" --verbose "${PATHS_TO_BACKUP[@]}"
}

echo ""
echo "== RESTIC BACKBLAZE =="
echo ""
echo "1. Backup"
echo ""
echo -n "Enter choice: "
read choice

if [[ "$choice" == 1 ]]
then
   perform_backup
else
   echo -e "${RED}Unrecognised choice: ${choice}${NC}"
   exit 1
fi

