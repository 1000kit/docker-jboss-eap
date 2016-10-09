FROM 1000kit/base-jdk

MAINTAINER Dr. Stefan Tausendpfund <docker@1000kit.org>

LABEL Vendor="1000kit"
LABEL License=GPLv3
LABEL Version=1.0.0

ENV EAP_BASE=6.4.0
ENV EAP_PATCH=6.4.9
ENV JBOSS_HOME=/opt/jboss
ENV JBOSS_BASE=/opt

ARG EAP_DOWNLOAD_URL
ARG EAPPATCH_DOWNLOAD_URL

USER root

ADD ./install/applyPatch.sh /tmp/

# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues)

RUN groupadd -r jboss -g 2000 \
 && useradd -u 2000 -r -g jboss -m -d /home/jboss -s /sbin/nologin -c "jboss user" jboss \
 && chmod -R 755 /home/jboss \
 && mkdir ${JBOSS_BASE} > /dev/null 2&>1 ;  chmod 755 ${JBOSS_BASE} ; chown -R jboss:jboss ${JBOSS_BASE} \
 && echo 'jboss ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
 && chown jboss:jboss /tmp/apply*

# install User
USER jboss

RUN    echo "EAP: ${EAP_DOWNLOAD_URL}" \
    && echo "PATCH ${EAPPATCH_DOWNLOAD_URL}" \   
    && curl -L ${EAP_DOWNLOAD_URL} > /tmp/jboss-eap-${EAP_BASE}.zip \
	&& curl -L ${EAPPATCH_DOWNLOAD_URL} > /tmp/jboss-eap-${EAP_PATCH}-patch.zip \

	&& /usr/bin/unzip -q /tmp/jboss-eap-${EAP_BASE}.zip -d ${JBOSS_BASE}/ \
    && ln -s ${JBOSS_BASE}/jboss-eap-6* ${JBOSS_HOME} \
    && ${JBOSS_HOME}/bin/add-user.sh admin admin2016\! --silent \
    
    && chmod 755 /tmp/applyPatch.sh \  
    && /tmp/applyPatch.sh jboss-eap-${EAP_PATCH}-patch.zip \
    
    && mkdir ${JBOSS_HOME}/standalone/log \
	&& /bin/rm -rf ${JBOSS_HOME}/.installation \
    && /bin/rm /tmp/jboss-eap*.zip /tmp/apply*.sh 

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND=true

# Expose Ports 8787:debug
EXPOSE 9990 9999 8443 8787 8080

WORKDIR ${JBOSS_HOME}

#CMD /opt/jboss/server/jboss/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
CMD ["/opt/jboss/bin/standalone.sh", "-c", "standalone.xml", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0" , "--debug"]

####END
# interessant
# https://github.com/dell-cloud-marketplace/docker-wildfly/blob/master/run.sh
