#!/bin/bash

set -e

export VOMS_PASS="$1" 
export CERTDIR="$HOME/.globus"
export MY_VO="dteam"

echo "## setup user credential in $CERTDIR"
mkdir -p $CERTDIR
cp /afs/cern.ch/user/a/aalvarez/public/saketag-cert.pem $CERTDIR/usercert.pem
cp /afs/cern.ch/user/a/aalvarez/public/saketag-key.pem $CERTDIR/userkey.pem


echo "## Generate proxy certificate "
voms-proxy-init --voms $MY_VO <<EOF
$VOMS_PASS
EOF

echo "## End generation"


