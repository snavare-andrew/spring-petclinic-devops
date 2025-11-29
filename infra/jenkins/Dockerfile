FROM jenkins/jenkins:lts-jdk21

USER root
RUN apt-get update && \
    apt-get install -y docker.io maven ansible git curl jq && \
    rm -rf /var/lib/apt/lists/*

COPY jenkins/init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

COPY --chown=jenkins:jenkins jenkins/plugins.txt /usr/share/jenkins/plugins.txt

RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/plugins.txt \
 && chown -R jenkins:jenkins /var/jenkins_home

ENV JENKINS_HOME=/var/jenkins_home

USER jenkins
