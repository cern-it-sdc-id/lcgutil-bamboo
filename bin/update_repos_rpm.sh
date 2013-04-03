#!/bin/bash


MY_DIR=$(dirname $(readlink -f $0) )

# import copyfile
source $MY_DIR/copy_files.sh
source $MY_DIR/lockers.sh

function update_repo_func {

echo " *** copy RPMS ***"
copy_files "$RPM_DIR/*.rpm" "$REPO_ADDR"

echo "*** renew repo $REPO_ADDR ***"
createrepo $REPO_ADDR


}


set -e

if [[ "$1" == "" || "$2" == "" ]]; then
	echo "Usage $0 [rpmdir] [rpm_repo_path]"
	exit 0
fi

RPM_DIR=$( echo "$1" | sed 's@//*@/@g' | sed 's@\([^/]\)/$@\1@g' )
REPO_ADDR=$2
LOCK_FILE="$REPO_ADDR/lock_repo"

echo "*** test update repos ***** "
echo "SOURCE RPM Dir : $RPM_DIR"
echo "destination repo : $REPO_ADDR"
echo "Locker : $LOCK_FILE"

echo "*** list RPMS ***"
ls -l $RPM_DIR/*.rpm

write_lock $LOCK_FILE "update_repo_func"

echo "*** clean everything ***"
#rm -f $RPM_DIR/*.rpm
