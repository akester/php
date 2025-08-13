#!/bin/bash

set -e
set -x

KEY="$AUTHORIZED_KEY_FILE"

if [ "$KEY" = "" ]; then
    echo "No authorized keys were provided, this container won't be accessible."
fi

mkdir -p /home/web/.ssh
chown web:web /home/web/.ssh
chmod 0700 /home/web/.ssh

echo "$KEY" > /home/web/.ssh/authorized_keys
chmod 644 /home/web/.ssh/authorized_keys

# Start SSH, but keep around so we can kill it when the container needs to stop.
/usr/sbin/sshd\ -D -e &
PID=$!

trap "kill $PID 2>/dev/null" EXIT
wait $PID
