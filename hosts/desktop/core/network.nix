{
  pkgs,
  lib,
  vars,
  ...
}:
{
  # TODO: Break out into a modules
  networking.useDHCP = lib.mkDefault true;

  networking = {
    hostName = vars.hostname;

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    wireless = {
      enable = false;
      iwd.enable = true;
    };

    firewall = {
      enable = true;
    };
  };

  environment.systemPackages = [ pkgs.iwd ];
}
