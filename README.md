# init-plain
 Script to provide an entrypoint and helpers for the plain docker image series. 

## entrypoint.sh

The script is supposed to be specified as `ENTRYPOINT` for a given Docker Image.
E.g. within [qnib/alplain-init](https://github.com/qnib/alplain-init).

It will iterate over the executables within `/opt/qnib/entry` and either execute or source them.

```
#!/bin/bash
set -e

for x in $(find /opt/qnib/entry/ -type f -perm /u+x |sort);do
     echo "> execute entrypoint '${x}'"
     if [[ "$x" == *.env ]];then
         source ${x}
     else
         ./${x}
     fi
done

if [ "X${ENTRY_USER}" != "X" ];then
  exec su -s /bin/bash -c "$@" ${ENTRY_USER}
else
  exec "$@"
fi
```

Once this is done, the command defined with `CMD` will be executed and the process control is handed over - in case an `$ENTRY_USER` is specified under a user other then `root`.

## `/opt/qnib/entry`

### Share log-socket

The first script (`00-`) executed will search for a log-device of an underlying syslog server and create a symlink to `/dev/log`, so that the container can naturally use this socket.

```
$ cat /opt/qnib/entry/00-logging.sh
#!/bin/bash

if [ ! -z ${LOGNAME} ] && [ -S /shareddev/${LOGNAME}/log ];then
    ln -s /shareddev/${LOGNAME}/log /dev/log
    logger -s "Created container specific symlink to syslog container"
elif [ -S /shareddev/log ];then
    ln -s /shareddev/log /dev/log
    logger -s "Created symlink from syslog container"
fi
```

### environment variables

In case environment variables should be sourced before the main process starts, the prefix `.env` should be used.

This exemplary script sources docker-secrets as environment variables.

```
$ cat /opt/qnib/entry/10-docker-secrets.env
#!/bin/bash

########
## Check for /run/secrets and expose them as ENV variables
mkdir -p /run/secrets/
if [ -d /run/secrets/ ];then
    for sec in $(ls /run/secrets/);do
        KEY=$(echo ${sec} |tr '[:lower:]' '[:upper:]' |sed -e 's/-/_/g')
        echo "[II] Set environment variable ${KEY} from '/run/secrets/${sec}'"
        declare "$KEY=$(cat /run/secrets/${sec})"
        export $KEY
    done
else
    echo "[II] No /run/secrets directory, skip step"
fi
```