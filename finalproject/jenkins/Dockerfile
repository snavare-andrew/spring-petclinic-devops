FROM jenkins/jenkins:lts

# Skip the initial setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Switch to root to install plugins
USER root

# Switch back to jenkins user
USER jenkins

# Install plugins
RUN jenkins-plugin-cli --plugins \
    prometheus \
    git \
    workflow-aggregator \
    blueocean