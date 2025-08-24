{ ... }:
{
  imports = [ ../core/wayland.nix ];

  programs.hyprland.enable = true;

  security.polkit.enable = true;
  security.pam.services.hyprlock = { };

  services.dbus.enable = true;
}
