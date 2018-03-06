# Dockerized 1000kit JBoss EAP image

This repository contains `JBoss EAP 7.0.9` image.



### Installed versions:

 JBoss EAP 7.0.9

### Availability

The `Dockerfile` is available in the `7.0.0` branch and is built in the Docker HUB as `1000kit/jboss-eap:7.0.0`.

## Build Image

Please download the EAP 7.0.0 zip package from redhat and the EAP 7.0.9 Patch file. Put both in the `${HOME}/Downloads/redhat/eap7.0` directory.

Take a Dockerfile and build with the default arguments:
* EAP_DOWNLOAD_URL: download http url where eap and patch of redhat can be downloaded

~~~~
$ docker 	build --build-arg EAP_DOWNLOAD_URL="${EAP_DOWNLOAD_URL}" --rm --force-rm -t 1000kit/jboss-eap:7.0.9 .
~~~~

or simply use the `build.sh` script. This will start the `1000kit/apache` server for download if necessary.

* Use Default download dir: `~/Downloads/redhat/eap.7.0` used by apache server for download
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
$ docker run -it 1000kit/jboss-eap:7.0.9
~~~~
