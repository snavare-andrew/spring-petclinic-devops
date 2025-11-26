#!/usr/bin/env bash
set -euo pipefail

# Script to setup OpenJDK 21 on the newly created prod VM to run the application

sudo apt-get update
sudo apt-get install -y openjdk-21-jre-headless
sudo useradd petclinic || true
sudo mkdir -p /opt/petclinic
sudo chown petclinic:petclinic /opt/petclinic

# Allow only SSH, disables password login
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh

