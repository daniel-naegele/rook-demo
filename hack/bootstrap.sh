#!/usr/bin/env bash

set -Eeuo pipefail

echo "Please define the target host (e.g. root@1.1.1.1)"
read -p "" target_host

# Install NixOS to the host system with our secrets
nix run github:nix-community/nixos-anywhere -- \
  --flake ".#demo" \
  --target-host "$target_host" \
  --debug
