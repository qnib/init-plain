#!/bin/bash
set -e

if [ "${QNIB_NO_FORK}" != "true" ];then
    for x in $(find /opt/qnib/entry/ -type f -perm +111 |sort);do
        echo "> execute entrypoint '${x}'"
        "${x}"
    done

    if [ "X${ENTRY_USER}" != "X" ];then
        exec su -s /bin/bash -c "$@" ${ENTRY_USER}
    else
        exec "$@"
    fi
else
    exec "$@"
fi
