FROM ubuntu
RUN apt-get update&&apt-get -y upgrade&&apt-get -y autoremove&&apt-get -y clean
COPY wildfly.default /etc/default/wildfly
RUN apt-get -y install apt-utils
RUN apt-get -y install wget
WORKDIR /opt
RUN wget http://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.tar.gz
RUN gunzip wildfly-10.1.0.Final.tar.gz
RUN tar xf wildfly-10.1.0.Final.tar
RUN rm /opt/wildfly-10.1.0.Final.tar
RUN ln -s /opt/wildfly-10.1.0.Final /opt/wildfly
COPY wildfly.init /etc/init.d/wildfly
RUN chmod +x /etc/init.d/wildfly
RUN update-rc.d wildfly defaults
RUN groupadd -r wildfly&&useradd -r -g wildfly -d /opt/wildfly -s /sbin/nologin wildfly&&chown -R wildfly:wildfly /opt/wildfly*
COPY standalone.conf /opt/wildfly/bin/
COPY wildfly.limits /etc/security/limits.d/wildfly.conf
RUN apt-get -y install sudo
COPY wildfly.sudo /etc/sudoers.d/wildfly
RUN chmod 0440 /etc/sudoers.d/wildfly
RUN apt-get update&&apt-get -y upgrade&&apt-get -y autoremove&&apt-get clean
RUN apt-get -y install openjdk-11-jdk
USER wildfly
EXPOSE 8080
CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
