# Dockerized 1000kit JBoss EAP image

This repository contains `JBoss EAP 6.4.1` image.



### Installed versions:

 JBoss EAP 6.4.1

### Availability

The `Dockerfile` is available in the `6.4.1` branch and is built in the Docker HUB as `1000kit/jboss-eap:6.4.1`.

## Build Image

Please download the EAP 6.4.1 zip package from redhat. Put both in the `${HOME}/Downloads/redhat/eap6.4` directory.

Take a Dockerfile and build with the default arguments:
* EAP_DOWNLOAD_URL: download http url where eap and patch of redhat can be downloaded

~~~~
$ docker 	build --build-arg EAP_DOWNLOAD_URL="${EAP_DOWNLOAD_URL}" --rm --force-rm -t 1000kit/jboss-eap:6.4.1 .
~~~~

or simply use the `build.sh` script. This will start the `1000kit/apache` server for download if necessary.

* Use Default download dir: `~/Downloads/redhat/eap.6.4` used by apache server for download
~~~~
$ build.sh
~~~~

* alternative path used by apache server
~~~~
$ build.sh /opt/downloads
~~~~

* use external download URL:
~~~~
$ export EAP_DOWNLOAD_URL=https://<host>/<link>
$ build.sh
~~~~

## run
~~~~
$ docker run -it 1000kit/jboss-eap:6.4.1
~~~~
