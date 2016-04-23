#!/usr/local/bin/dumb-init /bin/bash
set -e

if [ -S /shareddev/$(hostname)/log ];then
    ln -s /shareddev/$(hostname)/log /dev/log
    logger -s "Created container specific symlink to syslog container"
elif [ -S /shareddev/log ];then
    ln -s /shareddev/log /dev/log
    logger -s "Created symlink from syslog container"
fi

exec "$@"
