{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sddm-astronaut
    kdePackages.qtsvg
    kdePackages.qtmultimedia
    kdePackages.qtvirtualkeyboard
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    enableHidpi = true;
    #package = pkgs.kdePackages.sddm;
    theme = "${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme";
  };
}
