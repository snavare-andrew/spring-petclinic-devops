#!/usr/bin/env bash
set -euo pipefail

echo "NOTE: This script requires the curl and jq packages to be installed on the host machine."
echo "NOTE: This is to allow automatic SonarQube token creation and insertion into Jenkins."

echo "WARNING: It is expected that the default values provided in the script will NOT TO BE USED and is present only as a base and to allow ease of use."
echo "WARNING: To replace with new values, set the respective variable names as ENV variables locally as the script will try to read them before defaulting."
echo "WARNING: Example to set a new value - export JENKINS_ADMIN_PASSWORD=your_password"
echo

JENKINS_ADMIN_PASSWORD="${JENKINS_ADMIN_PASSWORD:-"devops@2025"}"
ZAP_API_KEY="${ZAP_API_KEY:-"75de1195e318543b38c48682180e3480698a3973ad0488ee0e23d92f6061dae5"}"

export JENKINS_ADMIN_PASSWORD ZAP_API_KEY

echo "Building and starting containers."
cd spring-petclinic/infra
docker compose build
docker compose up -d

# Checking if SonarQube container is up and requesting for new token via API endpoint
until curl -sf "http://localhost:9000/api/system/status" | grep -q '"status":"UP"'; do
  echo "WARNING: SonarQube is not ready."
  sleep 5
done

SONAR_TOKEN=$(curl -s -u "admin:admin" -X POST "http://localhost:9000/api/user_tokens/generate?name=jenkins" | jq -r '.token')

if [ -z "${SONAR_TOKEN}" ] || [ "${SONAR_TOKEN}" = "null" ]; then
  echo "ERROR: Failed to generate SonarQube token"
  exit 1
fi

echo "Token generation successful."

# Checking if Jenkins container is up
until curl -sf "http://localhost:8080/login"; do
  echo "WARNING: Jenkins not ready yet."
  sleep 5
done

# Getting CSRF Token to send modification requests to Jenkins
CRUMB_JSON=$(curl -s -u "jenkins_admin:${JENKINS_ADMIN_PASSWORD}" "http://localhost:8080/crumbIssuer/api/json")
CRUMB_FIELD=$(echo "${CRUMB_JSON}" | jq -r '.crumbRequestField')
CRUMB=$(echo "${CRUMB_JSON}" | jq -r '.crumb')

# Inserting new SonarQube credentials into Jenkins via API endpoint
curl -s -X POST "http://localhost:8080/credentials/store/system/domain/_/createCredentials" \
  -u "jenkins_admin:${JENKINS_ADMIN_PASSWORD}" \
  -H "${CRUMB_FIELD}: ${CRUMB}" \
  --data-urlencode "json={
    \"\": \"0\",
    \"credentials\": {
      \"scope\": \"GLOBAL\",
      \"id\": \"sonar-token\",
      \"description\": \"SonarQube token\",
      \"secret\": \"${SONAR_TOKEN}\",
      \"\$class\": \"org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl\"
    }
  }"

echo "Sonar credential 'sonar-token' created and added to Jenkins."
echo

echo "Up staging and production VMs with Vagrant."
vagrant up

echo
echo "===============================================================++"
echo "Environment is starting up."
echo
echo " Jenkins:    http://localhost:8080 (User Id: jenkins_admin)"
echo " SonarQube:  http://localhost:9000"
echo " Grafana:    http://localhost:3000"
echo " Prometheus: http://localhost:9090"
echo " ZAP API:    http://localhost:8090"
echo " VM (prod):  http://192.168.56.200:8081"
