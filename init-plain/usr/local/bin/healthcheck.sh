#!/bin/bash
echo "[II] qnib/init-plain script v0.4.22"
HEALTHCHECK_DIR=${HEALTHCHECK_DIR:-/opt/healthchecks/}
set -e 

if [[ ! -d  ${HEALTHCHECK_DIR} ]];then
    echo "> No healthcheck dir found '${HEALTHCHECK_DIR}'"
    exit 0
fi
if [[ "X${ALLOW_HEALTHCHECK_OVERWRITE}" == "Xtrue" ]] && [[ -f ${HEALTHCHECK_DIR}/force_true ]];then
    echo "> Healthcheck is set to OK via '${HEALTHCHECK_DIR}/force_true' and ALLOW_HEALTHCHECK_OVERWRITE=true"
    exit 0
fi
while read -r line;do 
    echo "> execute healthcheck '${x}'"
    ${x}
done <<< $(find ${HEALTHCHECK_DIR} -type f -perm /u+x |sort)
exit 0
