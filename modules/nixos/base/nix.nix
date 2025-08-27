{ lib, ... }:
with lib;
{
  nixpkgs.config.allowUnfree = mkForce true;

  nix.settings.experimental-features = mkDefault [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = mkDefault true;
    dates = mkDefault "weekly";
    options = mkDefault "--delete-older-than 7d";
  };

  nix.optimise.automatic = true;

  nix.settings = {
    substituters = mkDefault [
      "https://cache.nixos.org/"
      "https://hyprland.cachix.org"
    ];
    trusted-substituters = mkDefault [
      "https://cache.nixos.org/"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = mkDefault [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  nix.channel.enable = false;
}
