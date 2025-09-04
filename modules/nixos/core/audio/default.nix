{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.core.audio;
in
with lib;
{
  options.nixosModules.core.audio = {
    enable = mkEnableOption "Audio via Pipewire";

    alsa = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable ALSA";
      };

      support32Bit = mkOption {
        type = types.bool;
        default = true;
        description = "Enable ALSA 32-bit Support";
      };
    };

    jack = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable JACK";
      };
    };

    pulseaudio = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable PulseAudio";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      mkIf cfg.pulseaudio.enable [
        pulseaudio
      ];

    services = {
      pipewire = {
        enable = true;

        alsa = mkIf cfg.alsa.enable {
          enable = true;
          support32Bit = true;
        };

        pulse.enable = mkIf cfg.pulseaudio.enable true;
        jack.enable = mkIf cfg.jack.enable true;
        wireplumber.enable = mkIf cfg.wireplumber.enable mkDefault true;
      };

      pulseaudio.enable = mkDefault false;
    };

    security.rtkit.enable = true;
  };
}
