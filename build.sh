#!/bin/bash

#
#
BVERSION=6.4.0
VERSION1=6.4.9
VERSION2=6.4.10
IMAGE="1000kit/jboss-eap"

cd "$( dirname "${BASH_SOURCE[0]}" )"
pwd

startHTTP=false

if [[ ! -z "${EAP_DOWNLOAD_URL}" &&  ! -z "${EAPPATCH_DOWNLOAD_URL}" ]]; then	
	echo "use provided Download URL"
else
	if [ ! -e install/jboss-eap-${BVERSION}.zip ]; then
		echo "!! Download EAP BASE ${BVERSION} in install/"
		exit
	fi
	if [ ! -e install/jboss-eap-${VERSION1}-patch.zip ]; then
		echo "!! Download EAP PATCH ${VERSION1} in install/"
		exit
	fi
	if [ ! -e install/jboss-eap-${VERSION2}-patch.zip ]; then
		echo "!! Download EAP PATCH ${VERSION2} in install/"
		exit
	fi	
	
	LOCIP=`hostname -I | cut -d' ' -f1`
	echo $LOCIP
	
	python3 -m http.server --bind ${LOCIP} 8000 &
	HTTP_PID=$!
	
	EAP_DOWNLOAD_URL="http://${LOCIP}:8000/install/jboss-eap-${BVERSION}.zip"	
	EAPPATCH_DOWNLOAD_URL="http://${LOCIP}:8000/install/"
	
	
fi


echo "build jboss EAP standalone image"
echo "EAPURL: ${EAP_DOWNLOAD_URL}"
echo "EAPPAT: ${EAPPATCH_DOWNLOAD_URL}"

docker 	build --build-arg EAP_DOWNLOAD_URL="${EAP_DOWNLOAD_URL}" --build-arg EAPPATCH_DOWNLOAD_URL="${EAPPATCH_DOWNLOAD_URL}" --force-rm -t ${IMAGE}:${VERSION2} .
		
		
echo "tag image with version ${VERSION}"
docker tag ${IMAGE}:${VERSION2} ${IMAGE}:latest

if [ ! -z ${HTTP_PID} ]; then
	echo "Stop HTTP Server ${HTTP_PID}"
	kill -9 ${HTTP_PID}
fi
#end
