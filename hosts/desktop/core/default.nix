{ ... }:
{
  imports = [
    ./essentials.nix
    ./fish.nix
    ./network.nix
    ./nix.nix
    ./peripherals.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
