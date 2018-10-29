#!/bin/bash

# Add default user to mock group
#usermod -a -G mock default
usermod -a -G mock $(id -u)

# Add default uid to /etc/passwd
#if ! whoami &> /dev/null; then
#  if [ -w /etc/passwd ]; then
#    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
#  fi
#fi

[[ ! $(whoami 2> /dev/null) ]] && \
  [[ -w /etc/passwd ]] && \
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
   
