#!/bin/bash

set -e
export REPO_URL=$1

echo " Deploy repo file $REPO_URL ..."

pushd /etc/yum.repos.d/
wget $REPO_URL
popd

echo " List repos files $(ls /etc/yum.repos.d/) "


