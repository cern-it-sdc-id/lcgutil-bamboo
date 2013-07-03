#!/bin/bash

MY_DIR="$(dirname $0)"
MY_ABS_DIR="$(readlink -e ${MY_DIR})"


PLATFORM="$(sed 's/.*\(el[0-9]\).*/\1/g')"
REPO_FILE="http://grid-deployment.web.cern.ch/grid-deployment/dms/lcgutil/repos/lcgutil-continuous-${PLATFORM}.repo"

echo " launch setup lcgutil client env for $PLATFORM *** "

$MY_ABS_DIR/../lib/deploy_repo_file.sh $REPO_FILE
$MY_ABS_DIR/../lib/deploy_voms_grid.sh
$MY_ABS_DIR/../lib/generate_proxy_voms.sh $1


