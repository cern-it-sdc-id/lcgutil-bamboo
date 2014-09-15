#!/bin/bash




if [[ "$1" == "" || "$2" == "" || "$3" == "" ]]; then
	echo "Usage $0 [config name] [srpm directory] [res_dir]"
	exit 1
fi

DISABLE_TMPFS=0
if [ "$4" == "no-tmpfs" ]; then
    DISABLE_TMPFS=1
fi

DIR=$(dirname $(readlink -f $0) )

# import copyfile
source $DIR/lockers.sh

# Create tmpfs
if [ $DISABLE_TMPFS -eq 0 ]; then
    echo "Print the amount of RAM"
    free -m
    echo "Printed mem info"

    mount -t tmpfs -o size=1536m tmpfs /var/lib/mock

    echo "Print the amount of  RAM after creating the RAM disk"
    free -m
    echo "Printed mem info"
else
    echo "tmpfs disabled"
fi

# Build
echo "*** begin mock build *** "
MOCK_CONFIG=$1
MOCK_EXE="/usr/bin/mock"
MOCK_OPTS_CLEAN="--scrub=yum-cache"
MOCK_CONFIG_DIRNAME="$( cd "$DIR/../mock_configs" && pwd )"
SRC_RPM_DIR=$2
MOCK_RESULT_DIR="/var/lib/mock/${MOCK_CONFIG}/result"
DEST_RPM_DIR=$( echo "$3" | sed 's@\([^/]\)/*@\1@g')
LOCK_FILE="/tmp/${MOCK_CONFIG}_lock"

pushd "${SRC_RPM_DIR}"
RPMS_NAME=`ls -t | head -n 1`
if [ -z "${RPMS_NAME}" ]; then
    echo "No rpms found!"
    exit 1
fi
RPMS_NAME=`readlink -f "${RPMS_NAME}"`
popd

echo "## SRPM names : "
echo " name : $RPMS_NAME"

echo "## list mock config..."
ls $MOCK_CONFIG_DIRNAME

echo "## dest dir ${DEST_RPM_DIR}/ "

#create_lock ${LOCK_FILE} 900

echo "## launch mock clean ..."
$MOCK_EXE --configdir=${MOCK_CONFIG_DIRNAME}/ -r $MOCK_CONFIG $MOCK_OPTS_CLEAN  || true
echo "## launch mock ..."
echo " build command mock --configdir=${MOCK_CONFIG_DIRNAME}/ -r $MOCK_CONFIG $RPMS_NAME"
$MOCK_EXE --configdir=${MOCK_CONFIG_DIRNAME}/ -r $MOCK_CONFIG $RPMS_NAME
if [ $? -ne 0 ]; then
    echo "Mock build failed!"
    exit 1
fi

#delete_lock ${LOCK_FILE}


echo "## copy result" 
rm -f $DEST_RPM_DIR
mkdir -p $DEST_RPM_DIR
cp -r $MOCK_RESULT_DIR/* $DEST_RPM_DIR

#echo "## clean everything "
#rm -f ${SRC_RPM_DIR}/*.rpm
#rm -rf ${SRC_RPM_DIR}

echo "## list RPMS & resu "
ls -l $DEST_RPM_DIR/

echo "## print the build log for debug purpose "
echo "## root.log"
cat $DEST_RPM_DIR/root.log
echo "## build.log"
cat $DEST_RPM_DIR/build.log

# Umount tmpfs
if [ $DISABLE_TMPFS -eq 0 ]; then
    sync
    umount -f /var/lib/mock
fi

