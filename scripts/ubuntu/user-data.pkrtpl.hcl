#cloud-config
# https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html
autoinstall:
  version: 1
  locale: en_US
  keyboard:
    layout: us
  identity:
    hostname: ${hostname}
    username: ${username}
    password: ${encrypted_password}
  network:
    version: 2
    ethernets:
      default:
        match:
          name: "e*"
          macaddress: "52:54:00:12:34:56" # default mac assigned by qemu
        dhcp4: true
  storage:
    layout:
      name: direct
  ssh:
    install-server: true
    authorized-keys:
      - ${ssh_public_key}
  packages:
    - qemu-guest-agent
  user-data:
    disable_root: false
  late-commands:
    - echo "${hostname} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${hostname}"
