{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.homeManagerModules.desktop.hyprland;
in
with lib;
{
  options.homeManagerModules.desktop.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Hyprland as the default window manager.";
    };

    package = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "The Hyprland package to use.";
    };

    portalPackage = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "The Hyprland portal package to use.";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = cfg.enable;
      package = cfg.package;
      portalPackage = cfg.portalPackage;
      systemd.variables = [ "--all" ];

      plugins = [ pkgs.hyprlandPlugins.hyprexpo ];

      extraConfig = ''
        source=~/.config/hypr/main.conf

        source=~/.config/hypr/hyprland/general.conf
        source=~/.config/hypr/hyprland/keybinds.conf
      '';

      # extraConfig = ''
      #   # Defaults
      #   source=~/.config/hypr/hyprland/execs.conf
      #   source=~/.config/hypr/hyprland/general.conf
      #   source=~/.config/hypr/hyprland/rules.conf
      #   source=~/.config/hypr/hyprland/colors.conf
      #   source=~/.config/hypr/hyprland/keybinds.conf

      #   # Custom
      #   source=~/.config/hypr/custom/env.conf
      #   source=~/.config/hypr/custom/execs.conf
      #   source=~/.config/hypr/custom/general.conf
      #   source=~/.config/hypr/custom/rules.conf
      #   source=~/.config/hypr/custom/keybinds.conf
      # '';
    };

    xdg.configFile."hypr/hyprland/general.conf".source = ./hyprland/config/general.conf;
    xdg.configFile."hypr/hyprland/keybinds.conf".source = ./hyprland/config/keybinds.conf;
    xdg.configFile."hypr/test.conf".source = ./hyprland/config/test.conf;
    xdg.configFile."hypr/main.conf".source = ./hyprland/config/main.conf;
  };
}
