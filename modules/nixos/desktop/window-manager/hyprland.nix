{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.desktop.window-manager.hyprland;
in
with lib;
{
  options.nixosModules.desktop.window-manager.hyprland = {
    enable = mkEnableOption "Hyprland";
  };

  config = mkIf cfg.enable {
    nixosModules.desktop.common.wayland.enable = mkForce true;

    programs.hyprland.enable = true;
  };
}
