{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.desktop.windowManager.hyprland;
in
with lib;
{
  options.nixosModules.desktop.windowManager.hyprland = {
    enable = mkEnableOption "Hyprland";
  };

  config = mkIf cfg.enable {
    nixosModules.desktop.common.wayland.enable = mkForce true;

    programs.hyprland.enable = true;
  };
}
