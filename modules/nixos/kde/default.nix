{ pkgs, ... }:
{
  imports = [ ../core/wayland.nix ];

  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = [ pkgs.kdePackages.sddm ];
}
