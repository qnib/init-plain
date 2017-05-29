#!/bin/bash
QUIET=${QUIET_ENTRYPOINT:-false}

function qecho() {
  if [[ "X${QUIET}" != "Xtrue" ]];then
    echo $@
  fi
}
qecho "[II] qnib/init-plain script v0.4.26"
set -e

if [[ -z ${SKIP_ENTRYPOINTS} ]];then
    ## /opt/entry/
    for x in $(find /opt/entry/ -type f -perm /u+x |sort);do
        qecho "> execute entrypoint '${x}'"
        if [[ "$x" == *.env ]];then
            source ${x}
        else
            ${x}
        fi
    done
    for x in $(find ${ENTRYPOINTS_DIR} -type f -perm /u+x |sort);do
        qecho "> execute entrypoint '${x}'"
        if [[ "$x" == *.env ]];then
            source ${x}
        else
            ${x}
        fi
    done
fi

if [[ "${WAIT_TASK_SLOT}" != "X" ]] && $(echo "${WAIT_TASK_SLOT}" |sed -e 's/,/ /g' | grep -q -w "${SWARM_TASK_SLOT}");then
  qecho "> Slot ${SWARM_TASK_SLOT} in '${WAIT_TASK_SLOT}', so we wait.sh"
  exec wait.sh
fi
if [ "X${ENTRY_USER}" != "X" ];then
  qecho "> execute CMD as user '${ENTRY_USER}'"
  exec gosu ${ENTRY_USER} /bin/bash -c "$@"
else
  qecho "> execute CMD '$@'"
  exec "$@"
fi
