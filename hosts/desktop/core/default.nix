{ ... }:
{
  imports = [
    ./essentials.nix
    ./fish.nix
    ./i18n.nix
    ./network.nix
    ./nix.nix
    ./peripherals.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
