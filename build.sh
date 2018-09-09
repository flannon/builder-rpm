#!/bin/bash

rpmdev-setuptree

curl $SRC_RPM_LOCATION -o $SRC_RPM

rpmbuild --rebuild ./${SRC_RPM}

while :
do
  echo lubdub 2>&1 1>/dev/null
  sleep 5
done

