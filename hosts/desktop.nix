{
  outputs,
  pkgs,
  vars,
  ...
}:
{
  imports = [
    ./desktop/hardware-configuration.nix
    outputs.nixosModules.core
  ];

  nixosModules.core = {
    bootloader.systemd-boot.enable = true;

    disks = {
      inherit (vars.disks) device;
      enable = true;
      config = "btrfs";
    };

    user = {
      preconfigure = true;
      shell = "fish";
    };
  };

  system.stateVersion = "25.11";
}
