#!/usr/local/bin/dumb-init /bin/bash
set -e

if [ ! -z ${LOGNAME} ] && [ -S /shareddev/${LOGNAME}/log ];then
    ln -s /shareddev/${LOGNAME}/log /dev/log
    logger -s "Created container specific symlink to syslog container"
elif [ -S /shareddev/log ];then
    ln -s /shareddev/log /dev/log
    logger -s "Created symlink from syslog container"
fi
for x in $(find /opt/qnib/entry/ -type f -perm +111 |sort);do
     echo "> execute entrypoint '${x}'"
     "${x}"
done

if [ "X${ENTRY_USER}" != "X" ];then
  exec su -s /bin/bash -c "$@" ${ENTRY_USER}
else
  exec "$@"
fi
