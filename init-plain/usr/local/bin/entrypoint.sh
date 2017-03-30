#!/bin/bash
set -e

for x in $(find /opt/qnib/entry/ -type f -perm /u+x |sort);do
     echo "> execute entrypoint '${x}'"
     if [[ "$x" == *.env ]];then
         source ${x}
     else
         ${x}
     fi
done

if [ "X${ENTRY_USER}" != "X" ];then
  echo "> execute CMD as user '${ENTRY_USER}'"
  exec su -s /bin/bash -c "$@" ${ENTRY_USER}
else
  echo "> execute CMD '$@'"
  exec "$@"
fi
