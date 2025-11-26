#!/usr/bin/env bash
set -euo pipefail

docker compose down -v # Stop & remove containers/volumes

vagrant destroy -f # Destroy Vagrant VM
rm -rf .vagrant # Remove local state of Vagrant

vagrant box remove hashicorp-education/ubuntu-24-04 # Remove boxes
