{
  config,
  lib,
  ...
}:
let
  cfg = config.homeManagerModules.desktop.bluetooth;
in
with lib;
{
  options.homeManagerModules.desktop.bluetooth = {
    blueman.enable = mkEnableOption "Blueman";
    bluedevil.enable = mkEnableOption "Bluedevil";
  };

  config = {
    services = {
      blueman.enable = mkIf cfg.blueman.enable true;
      bluedevil.enable = mkIf cfg.bluedevil.enable true;
    };
  };
}
