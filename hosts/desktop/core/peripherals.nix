{ pkgs, ... }:
{
  # TODO: Break out into a modules
  environment.systemPackages = with pkgs; [
    pulseaudio
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };
  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
