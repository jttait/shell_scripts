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
mkdir -p directory
mkdir -p another_directory
echo "hello, world" >> file.txt
mkdir -p directory/subdirectory
echo "hello, again" >> directory/subdirectory/file_in_subdirectory.txt
echo "hello there" >> another_directory/file_in_directory.txt
mkdir -p repo
mkdir restore
export PATHS_TO_BACKUP="./directory ./another_directory ./file.txt"
export PATH_TO_RESTIC_DRIVE_REPO=./repo

# init repo
restic init --repo ${PATH_TO_RESTIC_DRIVE_REPO}

# backup
../resticDrive.sh

# restore
../resticDrive.sh

# test
throwExceptionIfDirectoriesDifferent ./directory ./restore/directory
throwExceptionIfDirectoriesDifferent ./another_directory ./restore/another_directory
throwExceptionIfDirectoriesDifferent ./file.txt ./restore/file.txt

# cleanup
rm -f file.txt
rm -rf directory
rm -rf another_directory
rm -rf repo
rm -rf restore
