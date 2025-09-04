{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.desktop.windowManager.kde;
in
with lib;
{
  options.nixosModules.desktop.windowManager.kde.enable =
    mkEnableOption "KDE Plasma Desktop Environment";

  config = mkIf cfg.enable {
    nixosModules.desktop.common.wayland.enable = mkForce true;

    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = [ pkgs.kdePackages.sddm ];
  };
}
