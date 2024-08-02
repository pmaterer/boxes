{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./disks.nix
    ];

  nix.settings.experimental-features = [ "nix-command flakes" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev"; # for efi only
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  networking.hostName = "packer";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.packer = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    nettools
    netcat
    iputils
    jq
  ];

  services = {
    openssh.enable = true;
    dbus.enable = true;
    timesyncd.enable = true;
  };

  system.stateVersion = "24.05";
}
