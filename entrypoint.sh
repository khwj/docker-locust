#!/bin/bash

set -eo pipefail

LOCUST_MASTER_PORT=${LOCUST_MASTER_PORT:-5557}

LOCUST=( "/usr/local/bin/locust" )
LOCUST+=( -f ${LOCUST_SCRIPT:-/locust-tasks/tasks.py} )
LOCUST+=( --host=$TARGET_HOST )

LOCUST_MODE=${LOCUST_MODE:-standalone}
if [[ "$LOCUST_MODE" = "master" ]]; then
    LOCUST+=( --master --master-bind-host=$LOCUST_MASTER --master-bind-port=$LOCUST_MASTER_PORT)
elif [[ "$LOCUST_MODE" = "worker" ]]; then
    LOCUST+=( --slave --master-host=$LOCUST_MASTER --master-port=$LOCUST_MASTER_PORT)
    while ! wget --spider -qT5 $LOCUST_MASTER:$LOCUST_MASTER_WEB >/dev/null 2>&1; do
        echo "Waiting for master"
        sleep 5
    done
fi

echo "${LOCUST[@]}"

exec ${LOCUST[@]}
