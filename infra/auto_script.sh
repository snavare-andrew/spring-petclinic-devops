#!/usr/bin/env bash
set -euo pipefail

ADMIN_PASSWORD="${ADMIN_PASSWORD:-""}"
SONAR_TOKEN="${SONAR_TOKEN:-""}"
GIT_REPO_URL="${GIT_REPO_URL:-https://github.com/snavare-andrew/spring-petclinic-devops.git}"
ZAP_API_KEY="${ZAP_API_KEY:-""}"

export ADMIN_PASSWORD SONAR_TOKEN GIT_REPO_URL ZAP_API_KEY

echo "Building and starting containers."
cd spring-petclinic/infra
docker compose build
docker compose up -d

echo "Up production VM with Vagrant."
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
echo " VM (prod):  http://192.168.56.10:8081"
