!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

exitIfEnvironmentVariableIsNotSet() {
   VARIABLE_NAME=$1
   VARIABLE_VALUE=${!VARIABLE_NAME}
   if [[ -z ${VARIABLE_VALUE} ]]
   then
      echo -e "[${RED}FAILURE${NC}] Environment variable $1 is not set!"
      exit 1
   fi
}

