#!/bin/bash


MY_DIR="$(dirname $0)"
MY_ABS_DIR="$(readlink -e ${MY_DIR})"

$MY_ABS_DIR/../lib/deploy_voms_grid.sh
$MY_ABS_DIR/../lib/generate_proxy_voms.sh $1
