{ config, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;

    nvidiaSettings = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
