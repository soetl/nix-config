{
  outputs,
  vars,
  ...
}:
{
  imports = [
    ./desktop/hardware-configuration.nix
    outputs.nixosModules.core
  ];

  nixosModules.core = {
    nix = {
      allowUnfree = true;
      gc.enable = true;
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

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
