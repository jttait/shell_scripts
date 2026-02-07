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
echo "PATH_TO_RESTIC_DRIVE_REPO=\"${TEST_DIR}/repo\"" >> "${TEST_DIR}/../secrets.sh"
mkdir -p directory
mkdir -p another_directory
echo "hello, world" >> file.txt
mkdir -p directory/subdirectory
echo "hello, again" >> directory/subdirectory/file_in_subdirectory.txt
echo "hello there" >> another_directory/file_in_directory.txt
mkdir -p repo
mkdir restore

# init repo
export PATH_TO_RESTIC_DRIVE_REPO="./repo"
restic init --repo ${PATH_TO_RESTIC_DRIVE_REPO}
unset PATH_TO_RESTIC_DRIVE_REPO

# backup
../restic_drive.sh

# restore
../restic_drive.sh

# test
failIfDirectoriesDifferent ./directory ./restore/directory
failIfDirectoriesDifferent ./another_directory ./restore/another_directory
failIfFilesDifferent ./file.txt ./restore/file.txt

# cleanup
rm -f file.txt
rm -rf directory
rm -rf another_directory
rm -rf repo
rm -rf restore
