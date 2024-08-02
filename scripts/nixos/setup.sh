#!/bin/sh

export ROOT_DIR="/mnt"
export NIXOS_CONFIG_DIR="${ROOT_DIR}/etc/nixos"
export ARCH=$(uname -m)
export SYSTEM="${ARCH}-linux"

# Setup disk partitions
curl -sf "${PACKER_HTTP_ADDR}/nixos/disks.nix" > disks.nix
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disks.nix

nixos-generate-config --no-filesystems --root "${ROOT_DIR}"

# Install NixOS
mv disks.nix "${NIXOS_CONFIG_DIR}/"
curl -sf "${PACKER_HTTP_ADDR}/nixos/flake.nix" > "${NIXOS_CONFIG_DIR}/flake.nix"
curl -sf "${PACKER_HTTP_ADDR}/nixos/configuration.nix" > "${NIXOS_CONFIG_DIR}/configuration.nix"
curl -sf "${PACKER_HTTP_ADDR}/nixos/hardware-configuration.nix" > "${NIXOS_CONFIG_DIR}/hardware-configuration.nix"
curl -sf "${PACKER_HTTP_ADDR}/nixos/systems/${SYSTEM}.nix" > "${NIXOS_CONFIG_DIR}/system.nix"

nixos-install --root "${ROOT_DIR}" --flake "${NIXOS_CONFIG_DIR}#packer"