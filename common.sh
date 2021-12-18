#!/bin/bash

exitIfEnvironmentVariableIsNotSet() {
   VARIABLE_NAME=$1
   VARIABLE_VALUE=${!VARIABLE_NAME}
   if [[ -z ${VARIABLE_VALUE} ]]
   then
      echo "[ERROR] Environment variable $1 is not set!"
      exit 1
   fi
}

