#!/bin/bash

throwExceptionIfDirectoriesDifferent() {
   DIFF=$(diff -r $1 $2)
   if [ "$DIFF" == "" ]
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
export PATH_TO_BORG_DRIVE_REPO=./repo

# init repo
borg init --encryption=repokey ${PATH_TO_BORG_DRIVE_REPO}

# backup
../borgDrive.sh
cd restore
export PATH_TO_BORG_DRIVE_REPO=../repo
../../borgDrive.sh
cd ..
throwExceptionIfDirectoriesDifferent ./directory ./restore/directory
throwExceptionIfDirectoriesDifferent ./another_directory ./restore/another_directory
throwExceptionIfDirectoriesDifferent ./file.txt ./restore/file.txt

# cleanup
rm file.txt
rm -r directory
rm -r another_directory
rm -r repo
rm -r restore
