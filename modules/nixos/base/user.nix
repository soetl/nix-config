{
  pkgs,
  lib,
  vars,
  config,
  ...
}:
let
  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
with lib;
{
  users.users."${vars.user.name}" = {
    isNormalUser = mkDefault true;
    initialHashedPassword = mkDefault vars.user.initialHashedPassword;

    extraGroups = mkDefault (ifGroupExist [
      "audio"
      "docker"
      "i2c"
      "libvirtd"
      "networkmanager"
      "plugdev"
      "video"
      "wheel"
    ]);

    packages = mkDefault [ pkgs.home-manager ];
  };
}
