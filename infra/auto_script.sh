#!/usr/bin/env bash
set -euo pipefail

JENKINS_ADMIN_PASSWORD="${JENKINS_ADMIN_PASSWORD:-""}"
SONAR_TOKEN="${SONAR_TOKEN:-""}"
ZAP_API_KEY="${ZAP_API_KEY:-""}"

export JENKINS_ADMIN_PASSWORD SONAR_TOKEN ZAP_API_KEY

echo "Building and starting containers."
cd spring-petclinic/infra
docker compose build
docker compose up -d

echo "Up staging and production VMs with Vagrant."
vagrant up

echo
echo "===============================================================++"
echo "Environment is starting up."
echo
echo " Jenkins:    http://localhost:8080"
echo " SonarQube:  http://localhost:9000"
echo " Grafana:    http://localhost:3000"
echo " Prometheus: http://localhost:9090"
echo " ZAP API:    http://localhost:8090"
echo " VM (prod):  http://192.168.56.200:8081"
