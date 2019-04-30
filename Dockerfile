FROM cloudbees/java-build-tools

USER root

ARG JENKINS_REMOTING_VERSION=3.27

# See https://github.com/jenkinsci/docker-slave/blob/master/Dockerfile#L31
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTING_VERSION/remoting-$JENKINS_REMOTING_VERSION.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar
  

RUN apt-get update \
  && apt-get install -y software-properties-common \
  && apt-get install -y libunwind-dev 
	
RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb \
  && dpkg -i packages-microsoft-prod.deb
 
RUN apt-get install -y apt-transport-https \
  && apt-get update \
  && apt-get install -y dotnet-sdk-2.2
  
RUN apt-get install -y liblttng-ust0 libcurl3 libssl1.0.0 libkrb5-3 zlib1g libicu55

COPY jenkins-slave /usr/local/bin/jenkins-slave

RUN chmod a+rwx /home/jenkins
WORKDIR /home/jenkins
USER jenkins

ENTRYPOINT ["/opt/bin/entry_point.sh", "/usr/local/bin/jenkins-slave"]
