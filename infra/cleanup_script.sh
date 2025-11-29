#!/usr/bin/env bash
set -euo pipefail

# This script will release the resources used in the project without affecting other services.
# Hopefully it helps =D.

docker compose down -v || true # Stop & remove containers/volumes

vagrant destroy || true # Destroy Vagrant VMs
rm -rf .vagrant # Remove local state of Vagrant

vagrant box remove hashicorp-education/ubuntu-24-04 # Remove Vagrant boxes
