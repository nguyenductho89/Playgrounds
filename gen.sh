#!/bin/sh
#define the template.
cat  << EOF
This is my template.
Port is $PORT
Domain is $DOMAIN
EOF

while getopts u:p:f: option
do
case "${option}"
in
d) DOMAIN=${OPTARG};;
p) PORT=${OPTARG};;
esac
done
