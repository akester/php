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

# Generate host keys if we don't have them.
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    echo "Generating SSH host keys..."
    ssh-keygen -q -N "" -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key
    ssh-keygen -q -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
    ssh-keygen -q -N "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
fi


# Start SSH, but keep around so we can kill it when the container needs to stop.
/usr/sbin/sshd -D -e &
PID=$!

trap "kill $PID 2>/dev/null" EXIT
wait $PID
