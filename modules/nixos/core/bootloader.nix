{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.core.bootloader;
in
with lib;
{
  options.nixosModules.core.bootloader = {
    systemd-boot = {
      enable = mkEnableOption "Enable systemd-boot bootloader";
      configurationLimit = mkOption {
        type = types.int;
        default = 10;
        description = "Maximum number of configuration files to load";
      };
    };

    timeout = mkOption {
      type = types.int;
      default = 8;
      description = "Timeout in seconds before booting the default entry";
    };
  };

  config = {
    boot.loader = {
      inherit (cfg) timeout;

      systemd-boot = mkIf cfg.systemd-boot.enable {
        inherit (cfg.systemd-boot) configurationLimit;
        enable = mkDefault true;
        consoleMode = mkDefault "max";
      };

      efi.canTouchEfiVariables = true;
    };
  };
}
