{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.desktop.hyprland;
in
with lib;
{
  # TODO: Implement Hyprland configuration
  options.nixosModules.desktop.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    nixosModules.desktop.common.wayland.enable = true;

    programs.hyprland.enable = true;

    security.polkit.enable = true;
    security.pam.services.hyprlock = { };

    services.dbus.enable = true;
  };
}
