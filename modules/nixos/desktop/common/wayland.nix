{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.desktop.common.wayland;
in
with lib;
{
  options.nixosModules.desktop.common.wayland.enable = mkEnableOption "Wayland libs";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wl-clipboard
      wayland-utils
    ];
  };
}
