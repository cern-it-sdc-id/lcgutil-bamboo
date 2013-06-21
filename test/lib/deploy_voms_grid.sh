#!/bin/bash

MYDIR="$(dirname $0)"

set -e

echo "## deploy EGI trust anchors ..."
cp $MYDIR/../share/yum/repos/EGI-trustanchors.repo /etc/yum.repos.d/

echo "## installl grid crendentials ..."
yum install lcg-CA -y

echo "## install voms credentials ...."
yum install voms-clients -y


echo "## copy grid security vomsdir "
cp -r $MYDIR/../share/voms/vomsdir /etc/grid-security/ 

echo "## End of grid voms deployment"


