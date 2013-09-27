#!/bin/bash

MY_DIR="$(dirname $0)"
MY_ABS_DIR="$(readlink -e ${MY_DIR})"


PLATFORM="$( uname -a | sed 's/.*\(el[0-9]\).*/\1/g')"
REPO_FILE="http://grid-deployment.web.cern.ch/grid-deployment/dms/lcgutil/repos/lcgutil-continuous-${PLATFORM}.repo"
REPO_FILE_EPEL="http://grid-deployment.web.cern.ch/grid-deployment/dms/lcgutil/repos/epel-and-testing-${PLATFORM}.repo"


echo " launch setup lcgutil client env for $PLATFORM *** "

set -e

echo " Deploy epel testing for $PLATFORM "
rm -rf /etc/yum.repos.d/*epel*repo
$MY_ABS_DIR/../lib/deploy_repo_file.sh $REPO_FILE_EPEL

echo " Deploy lcgutil continuous build repo file "
$MY_ABS_DIR/../lib/deploy_repo_file.sh $REPO_FILE
echo " Deploy voms environment "
$MY_ABS_DIR/../lib/deploy_voms_grid.sh
$MY_ABS_DIR/../lib/generate_proxy_voms.sh $1


