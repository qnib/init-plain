#!/usr/local/bin/dumb-init /bin/bash
set -e

if [ -S /shareddev/log ];then
    ln -s /shareddev/log /dev/log
    logger -s "Created symlink from syslog container"
fi

exec "$@"
