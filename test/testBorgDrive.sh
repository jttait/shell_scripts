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
pwd
echo '#!/bin/bash' >> ../secrets.sh
echo 'PATHS_TO_BACKUP=( "./directory ./another_directory ./file.txt" )' >> ../secrets.sh
echo 'PATH_TO_BORG_DRIVE_REPO="./repo"' >> ../secrets.sh
mkdir -p directory
mkdir -p another_directory
echo "hello, world" >> file.txt
mkdir -p directory/subdirectory
echo "hello, again" >> directory/subdirectory/file_in_subdirectory.txt
echo "hello there" >> another_directory/file_in_directory.txt
mkdir -p repo
mkdir restore

# init repo
export PATH_TO_BORG_DRIVE_REPO="./repo"
borg init --encryption=repokey ${PATH_TO_BORG_DRIVE_REPO}
unset PATH_TO_BORG_DRIVE_REPO

# backup
../borg_drive.sh
cd restore
export PATH_TO_BORG_DRIVE_REPO=../repo
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
