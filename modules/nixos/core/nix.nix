{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.core.nix;
in
with lib;
{
  options.nixosModules.core.nix = {
    gc = {
      enable = mkEnableOption "Nix Garbage Collection";

      runs = mkOption {
        type = types.str;
        default = "weekly";
        description = "Frequency of Garbage Collection runs";
      };

      options = mkOption {
        type = types.str;
        default = "--delete-older-than 7d";
        description = "Options for Nix Garbage Collection";
      };
    };

    substituters = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of substituters for Nix";
    };

    trusted-public-keys = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of trusted public keys for Nix";
    };
  };

  config = {
    nix.settings.experimental-features = mkDefault [
      "nix-command"
      "flakes"
    ];
    nix.channel.enable = false;
    nix.optimise.automatic = true;

    nix.gc = {
      inherit (cfg.gc) options;
      automatic = cfg.gc.enable;
      dates = cfg.gc.runs;
    };

    nix.settings = {
      inherit (cfg) substituters trusted-public-keys;
      trusted-substituters = cfg.substituters;
    };
  };
}
