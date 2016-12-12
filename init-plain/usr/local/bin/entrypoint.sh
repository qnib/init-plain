#!/bin/bash
set -e

for x in $(find /opt/qnib/entry/ -type f -perm +111 |sort);do
     echo "> execute entrypoint '${x}'"
     if [[ "$x" == *.env ]];then
         source ${x}
     else
         "${x}"
     fi
done

if [ "X${ENTRY_USER}" != "X" ];then
  exec su -s /bin/bash -c "$@" ${ENTRY_USER}
else
  exec "$@"
fi
