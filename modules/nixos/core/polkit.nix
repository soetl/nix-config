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

    security.polkit.extraConfig = ''
      polkit.addRule(function (action, subject) {
        if (
          subject.isInGroup("users") &&
          [
            "org.freedesktop.login1.reboot",
            "org.freedesktop.login1.reboot-multiple-sessions",
            "org.freedesktop.login1.power-off",
            "org.freedesktop.login1.power-off-multiple-sessions",
          ].indexOf(action.id) !== -1
        ) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
