{ pkgs, outputs, ... }:
{
  imports = [
    ./core
    ./hardware-configuration.nix
    ./nvidia.nix
    ./user.nix

    outputs.nixosModules.base
    outputs.nixosModules.core
    outputs.nixosModules.desktop
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
  };
  nixosModules.core.secureboot.enable = true;

  nixosModules.desktop = {
    sddm = {
      enable = true;
      theme.enable = true;
    };

    kde.enable = true;

    hyprland.enable = true;

    _1password = {
      enable = true;
      gui.enable = true;
    };

    remoteDesktop.sunshine = {
      enable = true;
      openFirewall = true;
      nvenc.enable = true;
    };
  };

  system.stateVersion = "25.05";
}
