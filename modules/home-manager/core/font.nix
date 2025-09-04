{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.homeManagerModules.core.font;
in
{
  options.homeManagerModules.core.font = {
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

  config = {
    fonts.fontconfig.enable = true;

    home.packages =
      with pkgs;
      (optionals cfg.jetbrainsMono.enable [
        nerd-fonts.jetbrains-mono
      ])
      ++ cfg.extraFonts;
  };
}
