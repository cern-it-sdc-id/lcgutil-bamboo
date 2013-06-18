
echo "## authenticate with the service account for access"
kinit gdrepo@CERN.CH <<EOF
Kewevu78
EOF
if [ $? -ne 0 ]; then
echo "Could not get AFS token for writing to the repository"
exit 1
fi
aklog
if [ $? -ne 0 ]; then
 echo "Could not convert kerberos to afs token"
 exit 1
fi

echo "## authenticate with success"

