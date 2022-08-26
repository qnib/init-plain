#!/bin/bash
QUIET=${QUIET_ENTRYPOINT:-false}
ENTRY_CMD=${ENTRY_CMD:-bash}

function qecho() {
  if [[ "X${QUIET}" != "Xtrue" ]];then
    echo $@
  fi
}
qecho "[II] qnib/init-plain script v0.4.34"
set -e

if [[ -z ${SKIP_ENTRYPOINTS} ]];then 
    if [[ "X${ENTRYPOINTS_DIR}" != "X" ]];then
      if [[ -d ${ENTRYPOINTS_DIR} ]];then
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
      else
        echo "!!> Could not find specified ENTRYPOINTS_DIR '${ENTRYPOINTS_DIR}'"
      fi
    fi
fi

if [[ "X${WAIT_TASK_SLOT}" != "X" ]] && $(echo "${WAIT_TASK_SLOT}" |sed -e 's/,/ /g' | grep -q -w "${SWARM_TASK_SLOT}");then
  qecho "> Slot ${SWARM_TASK_SLOT} in '${WAIT_TASK_SLOT}', so we wait.sh"
  exec wait.sh
fi
if [ "X${ENTRY_USER}" != "X" ];then
  qecho "> execute CMD as user '${ENTRY_USER}'"
  exec gosu ${ENTRY_USER} ${ENTRY_CMD} -c "$@"
else
  qecho "> execute CMD '$@'"
  exec "$@"
fi
