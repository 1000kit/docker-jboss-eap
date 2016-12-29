#!/bin/bash


function getStatus(){
	containerName=$1
    containerId=$(getContainerId ${containerName})
    echo $containerId
    if [ -z $containerId ]; then
        return 1
    else
        return 0
    fi
}

function getContainerId() {
	containerName=$1
    containerId=$(docker ps | grep -v Exit | grep ${containerName} | awk '{print $1}')
	echo "${containerId}"
}

function startApache() {
	containerName=$1
	port=$2
	DLPath=$3
	echo "start Apache: get status"
	getStatus ${containerName}
	if [ "$?" != "1" ]; then
		echo "start Apache: already runs"	
		return 1
	fi	
	echo "start Apache: Start apache Server"	
	docker run -d -p ${port}:80 -v ${DLPath}:/var/www/html/Downloads/:ro --name ${containerName} 1000kit/apache
} 

function stopApache() {
	containerName=$1
	containerId=$(getContainerId ${containerName})
	if [ -n $containerId ]; then
	    SRV=$(docker kill ${containerId})
	    SRV=$(docker rm ${containerId})
	fi
}

function apacheCMD {
	func=$1
	containerName=$2
	port=$3
	DLPath=$4
	case "$func" in	
		start)
			startApache $containerName $port ${DLPath}
			;;		
		stop)
			stopApache $containerName
			;;
		status)
			containerId=$(getContainerId ${containerName})
			if [ -n $containerId ]; then
				echo "container $containerName is running with id: ${containerId}"
			else
				echo "container $containerName is not running"
			fi
			;;
		*)
			echo "Usage: apacheCMD [start|stop|status] containerName [port]"
        	exit 1
        	;;
	esac
}
#end