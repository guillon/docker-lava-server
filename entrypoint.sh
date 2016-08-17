#!/usr/bin/env bash
#
# entrypoint.sh
# This is the default entrypoint for this image.
# By default, it:
# - starts postgresql service
# - starts lava services
# - starts apache service
# - adds admin local user if it doesn't already exists.
#
# Usages:
#   /entrypoint.sh : starts the default services and infinite sleep
#   /entrypoint.sh cmd... : executes cmd... instead
#  ./entrypoint.sh -- cmd...: starts the default services and execute cmd...
#

set -euo pipefail

[ $# = 0 -o "${1-}" = "--" ] || exec "$@"

echo "Starting postgresql..."
service postgresql start

echo "Starting lava-coordinator..."
service lava-coordinator start

echo "Starting lava-server..."
service lava-server start

echo "Starting apache2 server..."
service apache2 start

echo "Creating admin account optionally, initial password is: changeit"
lava-server manage createsuperuser --noinput \
                   --username=admin --email=lavaserver@localhost 2>/dev/null && \
  expect -c 'spawn lava-server manage changepassword admin;expect "Password: ";send "changeit\n";expect "Password (again): ";send "changeit\n";expect "Password changed successfully for user *";interact'

if [ "${1-}" = "--" ]; then
   shift
   echo "Executing:" "$@"
   exec "$@"
else
   echo "Executing: sleep infinity"
   sleep infinity
fi

