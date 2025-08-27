{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.desktop.sddm;
in
with lib;
{
  options.nixosModules.desktop.sddm = {
    enable = mkEnableOption "SDDM";
    theme = {
      enable = mkEnableOption "SDDM Theme";

      package = mkOption {
        type = types.package;
        default = pkgs.sddm-astronaut;
        description = "Package containing the SDDM theme";
      };

      path = mkOption {
        type = types.str;
        default = "${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme";
        description = "Path to the SDDM theme";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        sddm-astronaut
        kdePackages.qtsvg
        kdePackages.qtmultimedia
        kdePackages.qtvirtualkeyboard
      ]
      ++ optionals cfg.theme.enable [ cfg.theme.package ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      theme = mkIf cfg.theme.enable cfg.theme.path;
    };
  };
}
