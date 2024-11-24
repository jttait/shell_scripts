#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

exitIfEnvironmentVariableIsNotSet() {
   VARIABLE_NAME=$1
   VARIABLE_VALUE=${!VARIABLE_NAME}
   if [[ -z ${VARIABLE_VALUE} ]]
   then
      echo -e "${RED}Environment variable $1 is not set! Exiting!${NC}"
      exit 1
   fi
}
