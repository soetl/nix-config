{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.homeManagerModules.core.shell.starship;
in
{
  options.homeManagerModules.core.shell.starship = {
    enable = mkEnableOption "Starship prompt configuration";

    configFile = mkOption {
      type = types.path;
      default = ./starship/defaultConfig.toml;
      description = "Path to starship configuration file";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional TOML configuration to append";
    };
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    # Use the TOML file directly
    xdg.configFile."starship.toml" = {
      text = builtins.readFile cfg.configFile + cfg.extraConfig;
    };

    # Ensure starship is available
    home.packages = [ pkgs.starship ];
  };
}
