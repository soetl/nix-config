{ inputs, pkgs, ... }:
{
  imports = [
    inputs.illogical-impulse.homeManagerModules.default
  ];

  # Configure illogical-impulse
  illogical-impulse = {
    enable = true;

    hyprland = {
      package = pkgs.hyprland;
      xdgPortalPackage = pkgs.xdg-desktop-portal-hyprland;
      ozoneWayland.enable = true;
    };

    dotfiles = {
      fish.enable = true;
      kitty.enable = true;
    };
  };

  # Security for Hyprland
  security.polkit.enable = true;

  # Required services for Wayland
  services.dbus.enable = true;
}
