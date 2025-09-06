{
  pkgs,
  config,
  lib,
  vars,
  ...
}:
let
  cfg = config.nixosModules.core.user;
  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
with lib;
{
  options.nixosModules.core.user = {
    preconfigure = mkEnableOption "User preconfiguration";
    shell = mkOption {
      type = types.enum [
        "bash"
        "fish"
      ];
      default = "bash";
      description = "The default shell for the user";
    };
  };

  config = mkIf cfg.preconfigure {
    users.users."${vars.user.name}" = {
      isNormalUser = true;
      initialHashedPassword = vars.user.initialHashedPassword;
      extraGroups = ifGroupExist vars.user.extraGroups;
      shell =
        {
          "bash" = pkgs.bashInteractive;
          "fish" = pkgs.fish;
        }
        ."${cfg.shell}" or { };
      packages = [ pkgs.home-manager ];
    };

    users.mutableUsers = true;
    programs.fish.enable = mkIf (cfg.shell == "fish") true;
  };
}
