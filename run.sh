#!/bin/sh

# Regenerate keys
rm -rf /root/.ssh/id_rsa* && cat /dev/zero | ssh-keygen -q -N "" 1>/dev/null

exec supervisord -n -c /etc/supervisor/supervisord.conf