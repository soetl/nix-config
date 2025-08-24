{ config, pkgs, ... }:
let
  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.soetl = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ifGroupExist [
      "audio"
      "i2c"
      "networkmanager"
      "wheel"
    ];

    packages = [ pkgs.home-manager ];
  };
}
