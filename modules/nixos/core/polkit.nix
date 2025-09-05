{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.core.polkit;
in
with lib;
{
  options.nixosModules.core.polkit.enable = mkEnableOption "Polkit authentication agent";

  config = mkIf cfg.enable {
    security.polkit.enable = true;
  };
}
