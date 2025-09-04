{ outputs, ... }:
{
  imports = [
    outputs.nixosModules.core
  ];

  nixosModules.core = {
    bootloader.systemd-boot.enable = true;
  };

  system.stateVersion = "25.11";
}
