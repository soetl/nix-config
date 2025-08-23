{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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

    git
  ];

  environment.variables.EDITOR = "nvim";
}
