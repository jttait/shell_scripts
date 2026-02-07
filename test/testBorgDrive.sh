#!/bin/bash

failIfDirectoriesDifferent() {
  if [[ ! -d "$1" ]]; then
    echo "[FAIL] $1 does not exist"
    exit 1
  fi
  if [[ ! -d "$2" ]]; then
    echo "[FAIL] $2 does not exist"
    exit 1
  fi
   DIFF=$(diff -r $1 $2)
   if [ "$DIFF" != "" ]
   then
      echo "[FAIL]: $1 was not restored"
      exit 1
   else
      echo "[PASS]: $1 was restored"
   fi
}

failIfFilesDifferent() {
  if [[ ! -f "$1" ]]; then
    echo "[FAIL] $1 does not exist"
    exit 1
  fi
  if [[ ! -f "$2" ]]; then
    echo "[FAIL] $2 does not exist"
    exit 1
  fi
  DIFF=$(diff $1 $2)
  if [ "$DIFF" != "" ]
  then
      echo "[FAIL] $1 was not restored"
      exit 1
  else
      echo "[PASS] $1 was restored"
  fi
}

# setup
TEST_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
echo '#!/bin/bash' >> "${TEST_DIR}/../secrets.sh"
echo "PATHS_TO_BACKUP=( \"${TEST_DIR}/directory ${TEST_DIR}/another_directory ${TEST_DIR}/file.txt\" )" >> "${TEST_DIR}/../secrets.sh"
echo "PATH_TO_BORG_DRIVE_REPO=\"${TEST_DIR}/repo\"" >> "${TEST_DIR}/../secrets.sh"
mkdir -p ${TEST_DIR}/directory
mkdir -p ${TEST_DIR}/another_directory
echo "hello, world" >> ${TEST_DIR}/file.txt
mkdir -p ${TEST_DIR}/directory/subdirectory
echo "hello, again" >> ${TEST_DIR}/directory/subdirectory/file_in_subdirectory.txt
echo "hello there" >> ${TEST_DIR}/another_directory/file_in_directory.txt
mkdir -p ${TEST_DIR}/repo
mkdir ${TEST_DIR}/restore

# init repo
export PATH_TO_BORG_DRIVE_REPO="${TEST_DIR}/repo"
borg init --encryption=repokey ${PATH_TO_BORG_DRIVE_REPO}
unset PATH_TO_BORG_DRIVE_REPO

# backup
../borg_drive.sh
../borg_drive.sh

echo "ls TEST_DIR"
ls "${TEST_DIR}"

echo "ls TEST_DIR/restore"
ls "${TEST_DIR}/restore"

echo "ls TEST_DIR/restore/borg_restore"
ls "${TEST_DIR}/restore/borg_restore"

failIfDirectoriesDifferent "${TEST_DIR}/directory" "${TEST_DIR}/restore/borg_restore/${TEST_DIR}/directory"
failIfDirectoriesDifferent "${TEST_DIR}/another_directory" "${TEST_DIR}/restore/borg_restore/${TEST_DIR}/another_directory"
failIfFilesDifferent "${TEST_DIR}/file.txt" "${TEST_DIR}/restore/borg_restore/${TEST_DIR}/file.txt"

# cleanup
rm -f file.txt
rm -rf directory
rm -rf another_directory
rm -rf repo
rm -rf restore
