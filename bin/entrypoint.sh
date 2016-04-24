#!/usr/local/bin/dumb-init /bin/bash
set -e

if [ -z ${LOGNAME} ] && [ -S /shareddev/${LOGNAME}/log ];then
    ln -s /shareddev/${LOGNAME}/log /dev/log
    logger -s "Created container specific symlink to syslog container"
elif [ -S /shareddev/log ];then
    ln -s /shareddev/log /dev/log
    logger -s "Created symlink from syslog container"
fi

exec "$@"
