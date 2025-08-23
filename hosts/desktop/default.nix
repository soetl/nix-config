{ pkgs, inputs, ... }:
{
  imports = [
    ./core
    ./hardware-configuration.nix
    ./nvidia.nix
    ./user.nix

    ../../modules/nixos/sddm
    ../../modules/nixos/hyprland
  ];

  networking = {
    hostName = "nixos";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages;

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  system.stateVersion = "25.05";
}
