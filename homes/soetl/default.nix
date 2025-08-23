{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  imports = [
    inputs.illogical-impulse.homeManagerModules.default
  ];

  home = {
    username = "soetl";
    homeDirectory = lib.mkForce "/home/soetl";

    packages = with pkgs-unstable; [
      firefox
      chromium

      zed-editor

      telegram-desktop
      element-desktop
      discord
    ];
  };

  programs.git = {
    enable = true;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
