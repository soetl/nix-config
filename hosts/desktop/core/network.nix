{ pkgs, lib, ... }:
{
  networking.useDHCP = lib.mkDefault true;

  networking = {
    hostName = "nixos";

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    wireless = {
      enable = false;
      iwd.enable = true;
    };
    firewall.enable = false;
  };

  environment.systemPackages = [ pkgs.iwd ];
}
