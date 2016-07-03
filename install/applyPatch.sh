#!/bin/bash

echo "=>Apply Patch $1"
JBOSS_HOME=${JBOSS_HOME:-/opt/jboss}
JBOSS_CLI=${JBOSS_HOME}/bin/jboss-cli.sh
JBOSS_MODE="standalone"
JBOSS_CONFIG="${JBOSS_MODE}.xml"


function wait_for_server() {
  until $JBOSS_CLI -c "ls /deployment" &> /dev/null; do
    sleep 1
    done
}

echo "=> Starting JBoss EAP server"
$JBOSS_HOME/bin/${JBOSS_MODE}.sh -c $JBOSS_CONFIG &

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Executing the patch"

$JBOSS_CLI -c --command="patch apply /tmp/$1"


#--connect << EOF
#  patch apply /tmp/$1
#  exit
#EOF
echo "=> Shutdown Server"
$JBOSS_CLI  -c --command=":shutdown"

cd ${JBOSS_HOME}/${JBOSS_MODE}
rm -rf data tmp log work > /dev/null 2&>1

echo "=> finished"
#end
