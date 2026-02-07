#!/bin/bash

throwExceptionIfDirectoriesDifferent() {
   DIFF=$(diff -r $1 $2)
   if [ "$DIFF" != "" ]
   then
      echo "[FAIL]: $1 was not restored"
      exit 1
   else
      echo "[PASS]: $1 was restored"
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
cd restore
../../borg_drive.sh
cd ..
throwExceptionIfDirectoriesDifferent ./directory ./restore/directory
throwExceptionIfDirectoriesDifferent ./another_directory ./restore/another_directory
throwExceptionIfDirectoriesDifferent ./file.txt ./restore/file.txt

# cleanup
rm -f file.txt
rm -rf directory
rm -rf another_directory
rm -rf repo
rm -rf restore
