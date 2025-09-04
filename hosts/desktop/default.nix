{ outputs, vars, ... }:
{
  imports = [
    outputs.nixosModules.core
  ];

  nixosModules.core = {
    bootloader.systemd-boot.enable = true;

    disks = {
      inherit (vars.disks) device;
      enable = true;
      config = "btrfs";
    };
  };

  system.stateVersion = "25.11";
}
