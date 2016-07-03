# Dockerized 1000kit JBoss EAP image

This repository contains `JBoss EAP 7.0.0` image.



### Installed versions:

 JBoss EAP 7.0.0

### Availability

The `Dockerfile` is available in the `7.0.0` branch and is built in the Docker HUB as `1000kit/jboss-eap:7.0.0`.

## Build Image

Please download the EAP 7.0.0 zip package from redhat and the EAP 6.4.8 Patch file. Put both in the install directory.

Take a Dockerfile and build with the default arguments:

~~~~
$ docker build -t 1000kit/jboss-eap:7.0.0 .
~~~~

or simply use the `build.sh` script
