{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.nixosModules.core.disks;
  btrfs = import ./disks/btrfs.nix { device = cfg.device; };
in
with lib;
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  options.nixosModules.core.disks = {
    enable = mkEnableOption "Disks management via Disko";

    device = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Device to manage";
    };

    config = mkOption {
      type = types.enum [
        "custom"
        "btrfs"
      ];
      default = "btrfs";
      description = "Configuration for Disko";
    };

    customConfig = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = "Configuration for Disko";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.config == "custom" && cfg.customConfig == null);
        message = "nixosModules.core.disks.customConfig must be set when config is 'custom'";
      }
      {
        assertion = !(cfg.config != "custom" && cfg.device == null);
        message = "nixosModules.core.disks.device must be specified when not using custom config";
      }
    ];

    disko =
      {
        "btrfs" = btrfs.disko;
        "custom" = cfg.customConfig.disko or { };
      }
      ."${cfg.config}" or { };
  };
}
