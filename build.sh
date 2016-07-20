#!/bin/bash

#
#
BVERSION=6.4.0
VERSION=6.4.9
IMAGE="1000kit/jboss-eap"

cd "$( dirname "${BASH_SOURCE[0]}" )"
pwd

if [ ! -e install/jboss-eap-${BVERSION}.zip ]; then
	echo "!! Download EAP BASE ${BVERSION} in install/"
	exit
fi
if [ ! -e install/jboss-eap-${VERSION}-patch.zip ]; then
	echo "!! Download EAP PATCH ${VERSION} in install/"
	exit
fi

echo "build jboss EAP standalone image"
docker build --force-rm -t ${IMAGE}:${VERSION} .
echo "tag image with version ${VERSION}"
docker tag ${IMAGE}:${VERSION} ${IMAGE}:latest

#end
