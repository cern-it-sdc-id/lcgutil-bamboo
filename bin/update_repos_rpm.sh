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

function clean_old_rpms {
    echo " *** cleaning up"
    pushd $RPM_DIR
    for rpm in `ls -1 *.rpm`; do
        echo "   + " $rpm
        rm_pattern=`echo $rpm | awk 'match($0, /^((([a-zA-Z]+-?)+)(([0-9]+\.)*([0-9]+)))/, m) { print m[1]"-*.rpm"; }'`
        echo "$REPO_ADDR/$rm_pattern"
        rm -vf $REPO_ADDR/$rm_pattern
    done
    echo " *** done cleaning up"
    popd
}


set -e

if [[ "$1" == "" || "$2" == "" ]]; then
	echo "Usage $0 [rpmdir] [rpm_repo_path]"
	exit 0
fi

RPM_DIR=$( echo "$1" | sed 's@//*@/@g' | sed 's@\([^/]\)/$@\1@g' )
REPO_ADDR=$2
DIR_SCRIPT=$(dirname $0)


echo "*** test update repos ***** "
echo "SOURCE RPM Dir : $RPM_DIR"
echo "destination repo : $REPO_ADDR"


echo "*** setup auth ***"
bash $DIR_SCRIPT/auth_service_gd.sh

echo "*** list RPMS ***"
ls -l $RPM_DIR/*.rpm

#write_lock $LOCK_FILE "update_repo_func"
clean_old_rpms
update_repo_func

echo "*** clean everything ***"
#rm -f $RPM_DIR/*.rpm
