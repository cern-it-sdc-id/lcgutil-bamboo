#!/bin/bash
set -e

if [[ "$1" == "" || "$2" == "" ]]; then
	echo "Usage $0 [rpmdir] [rpm_repo_path]"
	exit 0
fi

RPM_DIR=$( echo "$1" | sed 's@\([^/]\)/*@\1@g')
REPO_ADDR=$2

echo "*** test update repos ***** "
echo "SOURCE RPM Dir : $RPM_DIR"
echo "destination repo : $REPO_ADDR"

echo "*** list RPMS ***"
ls -l $RPM_DIR/*.rpm

echo " *** copy RPMS ***"
cp $RPM_DIR/*.rpm $REPO_ADDR

echo "*** renew repo $REPO_ADDR ***"
createrepo $REPO_ADDR

echo "*** clean everything ***"
rm -rf $RPM_DIR
