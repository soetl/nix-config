{ pkgs, ... }:
{
  imports = [
    ./core
    ./hardware-configuration.nix
    ./nvidia.nix
    ./user.nix

    ../../modules/nixos/secureboot.nix

    ../../modules/nixos/sddm

    ../../modules/nixos/kde
    ../../modules/nixos/hyprland

    ../../modules/nixos/1password.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    hostName = "nixos";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  system.stateVersion = "25.05";
}
