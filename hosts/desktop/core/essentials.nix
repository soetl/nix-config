{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    neovim

    zip
    unzip
    xz
    p7zip

    ripgrep
    eza
    fzf
    wget
    curl
    coreutils

    sbctl
  ];

  environment.variables.EDITOR = "nvim";
}
