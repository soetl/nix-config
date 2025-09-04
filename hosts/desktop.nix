{
  outputs,
  pkgs,
  config,
  lib,
  vars,
  ...
}:
{
  imports = [
    ./desktop/hardwareConfiguration.nix
    ./desktop/i18n.nix

    outputs.nixosModules.core
    outputs.nixosModules.desktop
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
  };

  nixosModules.core = {
    nix = {
      allowUnfree = true;
      gc.enable = true;
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    bootloader.systemd-boot.enable = true;
    secureboot.enable = true;

    disks = {
      inherit (vars.disks) device;
      enable = true;
      config = "btrfs";
    };

    networking = {
      networkmanager.enable = true;
      wifi.enable = true;
      firewall.enable = true;
    };

    bluetooth.enable = true;

    nvidia = {
      enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "580.82.07";
        sha256_64bit = "sha256-Bh5I4R/lUiMglYEdCxzqm3GLolQNYFB0/yJ/zgYoeYw==";
        sha256_aarch64 = lib.fakeSha256;
        openSha256 = "sha256-8/7ZrcwBMgrBtxebYtCcH5A51u3lAxXTCY00LElZz08=";
        settingsSha256 = "sha256-lx1WZHsW7eKFXvi03dAML6BoC5glEn63Tuiz3T867nY=";
        persistencedSha256 = lib.fakeSha256;
      };
    };

    audio.enable = true;

    user = {
      preconfigure = true;
      shell = "fish";
    };
  };

  nixosModules.desktop = {
    desktopManager.sddm = {
      enable = true;
      theme.enable = true;
    };

    windowManager = {
      hyprland.enable = true;
      kde.enable = true;
    };

    networking.remoteDesktop.sunshine = {
      enable = true;
      openFirewall = true;
      nvenc.enable = true;
    };

    apps = {
      _1password = {
        enable = true;
        gui.enable = true;
      };
    };
  };

  system.stateVersion = "25.11";
}
