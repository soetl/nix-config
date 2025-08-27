{ lib, ... }:
with lib;
{
  boot.loader = {
    systemd-boot = {
      enable = mkDefault true;
      # configurationLimit = 10; // TODO: Enable after configuration is established
      consoleMode = mkDefault "max";
    };
    efi.canTouchEfiVariables = mkDefault true;

    timeout = mkDefault 8;
  };
}
