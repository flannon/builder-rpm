#!/bin/bash

# Add default user to mock group
usermod -a -G mock default

# Add default uid to /etc/passwd
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi
