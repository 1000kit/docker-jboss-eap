#!/bin/bash



#
#
BVERSION=6.4.1
VERSION=6.4.1

IMAGE="1000kit/jboss-eap"

cd "$( dirname "${BASH_SOURCE[0]}" )"
pwd

. ./build_lib.sh

startHTTP=false
if [ ! -z $1 ]; then
    EAPDownloadDir=$1
fi
if [ -z "${EAPDownloadDir}" ]; then
	
	EAPDownloadDir="${HOME}/Downloads/redhat/eap6.4"
	echo "Using ${EAPDownloadDir} as Download dir"	
fi


if [[ ! -z "${EAP_DOWNLOAD_URL}" ]]; then	
	echo "use provided Download URL"
else
	if [ ! -e ${EAPDownloadDir}/jboss-eap-${BVERSION}.zip ]; then
		echo "!! Download EAP BASE ${BVERSION} in ${EAPDownloadDir} or provide parameter to this script for location"
		exit
	fi
	
	LOCIP=`hostname -I | cut -d' ' -f1`
	
	# check if apache docker runs
	echo "Start apache Server for download"
	apacheCMD start apacheEAP 18080 "${EAPDownloadDir}"
	startHTTP=true
	EAP_DOWNLOAD_URL="http://${LOCIP}:18080/Downloads/"	
	
fi

echo "build jboss EAP standalone image"
echo "EAPURL: ${EAP_DOWNLOAD_URL}"

docker 	build --build-arg EAP_DOWNLOAD_URL="${EAP_DOWNLOAD_URL}" --rm --force-rm -t ${IMAGE}:${VERSION} .
		
		
echo "tag image with version ${VERSION}"
docker tag ${IMAGE}:${VERSION} ${IMAGE}:latest

if [ "${startHTTP}" != "false" ]; then
	apacheCMD stop apacheEAP
fi

#end
