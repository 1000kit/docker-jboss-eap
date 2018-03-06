FROM 1000kit/base-jdk

MAINTAINER 1000kit <docker@1000kit.org>

LABEL Vendor="1000kit" \
      License=GPLv3 \
      Version=1.0.0

ENV EAP_BASE=7.0.0  \
    EAP_PATCH=7.0.9 \
    JBOSS_HOME=/opt/jboss \
    JBOSS_BASE=/opt

ARG EAP_DOWNLOAD_URL

USER root

# Create a user and group used to launch processes
RUN groupadd -r jboss -g 2000 \
 && useradd -l -u 2000 -r -g jboss -m -d /home/jboss -s /sbin/nologin -c "jboss user" jboss \
 && chmod -R 755 /home/jboss \
 && mkdir ${JBOSS_BASE} > /dev/null 2&>1;  chmod 755 ${JBOSS_BASE} ; chown -R jboss:jboss ${JBOSS_BASE} \
 && echo 'jboss ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers 
 
# install User
USER jboss

RUN    echo "EAP: ${EAP_DOWNLOAD_URL}" \   
    && curl -L ${EAP_DOWNLOAD_URL}/jboss-eap-${EAP_BASE}.zip > /tmp/jboss-eap-${EAP_BASE}.zip \
	&& curl -L ${EAP_DOWNLOAD_URL}/jboss-eap-${EAP_PATCH}-patch.zip > /tmp/jboss-eap-${EAP_PATCH}-patch.zip \

    && /usr/bin/unzip -q /tmp/jboss-eap-${EAP_BASE}.zip -d ${JBOSS_BASE}/ \
    && ln -s ${JBOSS_BASE}/jboss-eap-7* ${JBOSS_HOME} \
    && ${JBOSS_HOME}/bin/add-user.sh admin admin2016\! --silent \
    
    && ${JBOSS_HOME}/bin/jboss-cli.sh  --command="patch apply /tmp/jboss-eap-${EAP_PATCH}-patch.zip" \
    
    && mkdir ${JBOSS_HOME}/standalone/log ; chown jboss:jboss ${JBOSS_HOME}/standalone/log \
    && /bin/rm -rf ${JBOSS_HOME}/.installation /tmp/jboss-eap*.zip
 

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

# Expose Ports 
EXPOSE 8080 8787 9990

WORKDIR ${JBOSS_HOME}

#CMD /opt/jboss/server/jboss/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
CMD ["/opt/jboss/bin/standalone.sh", "-c", "standalone.xml", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0" , "--debug"]

####END

