#!/bin/bash

#
#
BVERSION=7.0.0
VERSION=7.0.3

IMAGE="1000kit/jboss-eap"

cd "$( dirname "${BASH_SOURCE[0]}" )"
pwd

startHTTP=false

if [[ ! -z "${EAP_DOWNLOAD_URL}" ]]; then	
	echo "use provided Download URL"
else
	if [ ! -e install/jboss-eap-${BVERSION}.zip ]; then
		echo "!! Download EAP BASE ${BVERSION} in install/"
		exit
	fi
	if [ ! -e install/jboss-eap-${VERSION}-patch.zip ]; then
		echo "!! Download EAP PATCH ${VERSION} in install/"
		exit
	fi	
	
	LOCIP=`hostname -I | cut -d' ' -f1`
	echo $LOCIP
	
	python3 -m http.server --bind ${LOCIP} 8000 &
	HTTP_PID=$!
	
	EAP_DOWNLOAD_URL="http://${LOCIP}:8000/install/"	
	
fi


echo "build jboss EAP standalone image"
echo "EAPURL: ${EAP_DOWNLOAD_URL}"

docker 	build --build-arg EAP_DOWNLOAD_URL="${EAP_DOWNLOAD_URL}" --force-rm -t ${IMAGE}:${VERSION} .
		
		
echo "tag image with version ${VERSION}"
docker tag ${IMAGE}:${VERSION} ${IMAGE}:latest

if [ ! -z ${HTTP_PID} ]; then
	echo "Stop HTTP Server ${HTTP_PID}"
	kill -9 ${HTTP_PID}
fi
#end
