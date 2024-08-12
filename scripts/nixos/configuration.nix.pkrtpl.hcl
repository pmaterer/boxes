{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./disks.nix ];

  nix.settings.experimental-features = [ "nix-command flakes" ];
  nix.settings.trusted-users = [ "root" "packer" ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev"; # for efi only
  boot.loader.grub.efiSupport = true;

  networking.hostName = "packer";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.packer = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword =
      "$y$j9T$psQTDkKII7lznsNmyDeI30$9Bt2x4TDTd3X.8qF1U7xWY/XsZPLO9spROnpUXlKV9A"; # using passwd
    openssh.authorizedKeys.keys = [
      "${packer_user_ssh_public_key}"
    ];
  };

  environment.systemPackages = with pkgs; [ vim nettools netcat iputils jq ];

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    dbus.enable = true;
    timesyncd.enable = true;
  };

  system.stateVersion = "24.05";
}
