#!/bin/bash
QUIET=${QUIET_ENTRYPOINT:-false}
function qecho() {
  if [[ "X${QUIET}" != "Xtrue" ]];then
    echo $@
  fi
}
qecho "[II] qnib/init-plain script v0.4.20"
set -e

if [[ -z ${SKIP_ENTRYPOINTS} ]];then
    for x in $(find ${ENTRYPOINTS_DIR:-/opt/qnib/entry/} -type f -perm /u+x |sort);do
        qecho "> execute entrypoint '${x}'"
        if [[ "$x" == *.env ]];then
            source ${x}
        else
            ${x}
        fi
   done
fi

if [ "X${ENTRY_USER}" != "X" ];then
  qecho "> execute CMD as user '${ENTRY_USER}'"
  exec gosu ${ENTRY_USER} /bin/bash -c "$@"
else
  qecho "> execute CMD '$@'"
  exec "$@"
fi
