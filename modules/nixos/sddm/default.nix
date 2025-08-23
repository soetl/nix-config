{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sddm-sugar-dark
    libsForQt5.qt5.qtgraphicaleffects
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    enableHidpi = true;
    theme = "${pkgs.sddm-sugar-dark}/share/sddm/themes/sugar-dark";
  };
}
