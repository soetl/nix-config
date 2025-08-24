{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  home = {
    username = "soetl";
    homeDirectory = "/home/soetl";

    packages = with pkgs; [
      firefox
      chromium

      zed-editor
      vscode

      telegram-desktop
      discord
    ];

    stateVersion = "25.05";
  };

  programs.git = {
    enable = true;
    userName = "soetl";
    userEmail = "soetl@proton.me";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
