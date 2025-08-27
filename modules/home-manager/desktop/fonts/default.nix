{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.homeManagerModules.desktop.fonts;
in
{
  options.homeManagerModules.desktop.fonts = {
    enable = mkEnableOption "Font configuration";

    jetbrainsMono = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable JetBrains Mono Nerd Font";
      };
    };

    extraFonts = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional fonts to install";
    };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages =
      with pkgs;
      (optionals cfg.jetbrainsMono.enable [
        nerd-fonts.jetbrains-mono
      ])
      ++ cfg.extraFonts;

    # Set JetBrains Mono as default monospace font if enabled
    home.sessionVariables = mkIf cfg.jetbrainsMono.enable {
      TERMINAL_FONT = "JetBrainsMono Nerd Font";
    };
  };
}
