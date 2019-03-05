#!/bin/bash

set -eo pipefail

LOCUST=( "/usr/local/bin/locust" )

LOCUST+=( -f ${LOCUST_SCRIPT:-/locust-tasks/tasks.py} )
LOCUST+=( --host=$TARGET_HOST )

LOCUST_MODE=${LOCUST_MODE:-standalone}
if [[ "$LOCUST_MODE" = "master" ]]; then
    LOCUST+=( --master)
elif [[ "$LOCUST_MODE" = "worker" ]]; then
    LOCUST+=( --slave --master-host=$LOCUST_MASTER)
    while ! wget -sqT5 $LOCUST_MASTER:$LOCUST_MASTER_WEB >/dev/null 2>&1; do
        echo "Waiting for master"
        sleep 5
    done
fi

echo "${LOCUST[@]}"

exec ${LOCUST[@]}
