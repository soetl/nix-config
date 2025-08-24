{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland-utils
  ];
}
