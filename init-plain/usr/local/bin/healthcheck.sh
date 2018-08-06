#!/bin/bash
echo "[II] qnib/init-plain script v0.4.31"
HEALTHCHECK_DIR=${HEALTHCHECK_DIR:-/opt/healthchecks/}
set -e
ERRORCODES=0

if [[ ! -d  ${HEALTHCHECK_DIR} ]];then
    echo "> No healthcheck dir found '${HEALTHCHECK_DIR}'"
    exit 0
fi
if [[ "X${ALLOW_HEALTHCHECK_OVERWRITE}" == "Xtrue" ]] && [[ -f ${HEALTHCHECK_DIR}/force_true ]];then
    echo ">> INITIALIZATION PHASE! Until HC successed the first time, it will be overwritten to be OK."
    set +e
fi
while read -r LINE;do
    echo "> execute healthcheck '${LINE}'"
    ${LINE}
    EC=$?
    if [[ ${EC} -ne 0 ]];then
        echo ">> Healthcheck failed, but as '${HEALTHCHECK_DIR}/force_true' is set it will be ignored"
    fi
    ERRORCODES+=$EC
done <<< $(find ${HEALTHCHECK_DIR} -type f -perm /u+x |sort)
if [[ ${ERRORCODES} == 0 ]];then
    echo "> INITIALIZATION stops, removing ''${HEALTHCHECK_DIR}/force_true'"
    rm -f ${HEALTHCHECK_DIR}/force_true
fi
exit 0
