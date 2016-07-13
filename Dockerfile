FROM 1000kit/base-jdk

MAINTAINER Dr. Stefan Tausendpfund <docker@1000kit.org>

LABEL Vendor="1000kit"
LABEL License=GPLv3
LABEL Version=1.0.0

ENV EAP_BASE  7.0.0
ENV JBOSS_HOME /opt/jboss
ENV JBOSS_BASE /opt

USER root

ADD ./install/jboss-eap-${EAP_BASE}.zip /tmp/     

# Create a user and group used to launch processes
RUN groupadd -r jboss -g 2000 \
 && useradd -u 2000 -r -g jboss -m -d /home/jboss -s /sbin/nologin -c "jboss user" jboss \
 && chmod -R 755 /home/jboss \
 && mkdir ${JBOSS_BASE} > /dev/null 2&>1;  chmod 755 ${JBOSS_BASE} ; chown -R jboss:jboss ${JBOSS_BASE} \
 && echo 'jboss ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
 && chown jboss:jboss /tmp/jboss*

# install User
USER jboss

RUN /usr/bin/unzip -q /tmp/jboss-eap-${EAP_BASE}.zip -d ${JBOSS_BASE}/ \
    && ln -s ${JBOSS_BASE}/jboss-eap-7* ${JBOSS_HOME} \
    && ${JBOSS_HOME}/bin/add-user.sh admin admin2016\! --silent \
    && mkdir ${JBOSS_HOME}/standalone/log ; chown jboss:jboss ${JBOSS_HOME}/standalone/log \
    && /bin/rm /tmp/jboss-eap*.zip
 

# define the deployments directory as a volume that can be mounted
# WEnn Volume hier definiert wird werden alle dateien welche anschliessen darin kopiert werden gelöscht
# damit können aghängende Container keine standard deployments hinzufügen
#VOLUME ["/opt/jboss/standalone/configuration",\
#        "/opt/jboss/standalone/log", \
#        "/opt/jboss/standalone/deployments"]

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

# Expose Ports 
EXPOSE 8080 8787 9990

#CMD /opt/jboss/server/jboss/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
CMD ["/opt/jboss/bin/standalone.sh", "-c", "standalone.xml", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0" , "--debug"]

####END

