#!/bin/bash
echo "[II] qnib/init-plain script v0.4.19"
HEALTHCHECK_DIR=${HEALTHCHECK_DIR:-/opt/qnib/healthchecks/}
set -e 

if [[ ! -d  ${HEALTHCHECK_DIR} ]];then
    echo "> No healthcheck dir found '${HEALTHCHECK_DIR}'"
    exit 0
fi
while read -r line;do 
    echo "> execute healthcheck '${x}'"
    ${x}
done <<< $(find ${HEALTHCHECK_DIR} -type f -perm /u+x |sort)
exit 0
