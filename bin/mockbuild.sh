#!/bin/bash

if [[ "$1" == "" || "$2" == "" || "$3" == "" ]]; then
	echo "Usage $0 [config name] [srpm directory] [res_dir]"
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "*** begin mock build *** "
MOCK_CONFIG=$1
MOCK_EXE="/usr/bin/mock"
MOCK_OPTS_CLEAN="--scrub=yum-cache"
MOCK_CONFIG_DIRNAME="$( cd "$DIR/../mock_configs" && pwd )"
SRC_RPM_DIR=$2
MOCK_RESULT_DIR="/var/lib/mock/${MOCK_CONFIG}/result"
DEST_RPM_DIR=$( echo "$3" | sed 's@\([^/]\)/*@\1@g')

RPMS_NAME="`pwd`/${SRC_RPM_DIR}/`ls -t ${SRC_RPM_DIR} | head -n 1`"

echo "## SRPM names : "
echo " name : $RPMS_NAME"

echo "## list mock config..."
ls $MOCK_CONFIG_DIRNAME

echo "## dest dir ${DEST_RPM_DIR}/ "

echo "## launch mock clean ..."
$MOCK_EXE --configdir=${MOCK_CONFIG_DIRNAME}/ -r $MOCK_CONFIG $MOCK_OPTS_CLEAN  || true
echo "## launch mock ..."
echo " build command mock --configdir=${MOCK_CONFIG_DIRNAME}/ -r $MOCK_CONFIG $RPMS_NAME"
$MOCK_EXE --configdir=${MOCK_CONFIG_DIRNAME}/ -r $MOCK_CONFIG $RPMS_NAME

echo "## creat link to result "
rm -f $DEST_RPM_DIR
ln -s  $MOCK_RESULT_DIR $DEST_RPM_DIR

echo "## clean everything "
rm -rf ${SRC_RPM_DIR}

echo "## list RPMS & resu "
ls -l RPMS_build/

echo "## print the build log for debug purpose "
echo "## root.log"
cat RPMS_build/root.log
echo "## build.log"
cat RPMS_build/build.log
