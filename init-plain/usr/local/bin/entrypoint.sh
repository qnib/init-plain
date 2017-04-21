#!/bin/bash
echo "[II] qnib/init-plain script v0.4.17"
set -e

if [[ -z ${SKIP_ENTRYPOINTS} ]];then
    for x in $(find /opt/qnib/entry/ -type f -perm /u+x |sort);do
        echo "> execute entrypoint '${x}'"
        if [[ "$x" == *.env ]];then
            source ${x}
        else
            ${x}
        fi
   done
fi

if [ "X${ENTRY_USER}" != "X" ];then
  echo "> execute CMD as user '${ENTRY_USER}'"
  exec gosu ${ENTRY_USER} /bin/bash -c "$@"
else
  echo "> execute CMD '$@'"
  exec "$@"
fi
