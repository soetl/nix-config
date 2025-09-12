{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.homeManagerModules.desktop.illogical-impulse;
in
with lib;
{
  imports = [
    inputs.illogical-impulse.homeManagerModules.default
  ];

  options.homeManagerModules.desktop.illogical-impulse = {
    enable = mkEnableOption "Illogical Impulse shell configuration";
    hyprland = {
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
  };

  config = mkIf cfg.enable {
    illogical-impulse = {
      enable = true;

      hyprland = {
        package = cfg.hyprland.package;
        xdgPortalPackage = cfg.hyprland.portalPackage;

        ozoneWayland.enable = true;
      };
    };
  };
}
