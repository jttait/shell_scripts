#!/bin/bash

set -eu

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

exitIfEnvironmentVariableIsNotSet() {
   local variable_name=$1
   local variable_value=${!variable_name}
   if [[ -z "${variable_value}" ]]
   then
      echo -e "${RED}Environment variable $1 is not set! Exiting!${NC}"
      exit 1
   fi
}
