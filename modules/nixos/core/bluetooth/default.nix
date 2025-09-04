{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.core.bluetooth;
in
with lib;
{
  options.nixosModules.core.bluetooth = {
    enable = mkEnableOption "Bluetooth";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
  };
}
