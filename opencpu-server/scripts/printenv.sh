#!/bin/bash
VARS="JAVA_HOME R_JAVA_LD_LIBRARY_PATH R_LD_LIBRARY_PATH LD_LIBRARY_PATH"
R_HOME=$(R RHOME)
source "${R_HOME}/etc/ldpaths"
for VAR in ${VARS}
do
  echo "${VAR}=${!VAR}"
done
