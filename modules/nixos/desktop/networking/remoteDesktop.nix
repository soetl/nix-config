{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.desktop.networking.remoteDesktop;
in
with lib;
{
  options.nixosModules.desktop.networking.remoteDesktop = {
    sunshine = {
      enable = mkEnableOption "Enable Sunshine";

      name = mkOption {
        type = types.str;
        default = "NixOS";
        description = "Name of the Sunshine instance";
        example = "MyNixOS";
      };

      max_bitrate = mkOption {
        type = types.int;
        default = 20000;
        description = "Maximum bitrate for Sunshine";
        example = 20000;
      };

      openFirewall = mkEnableOption "Open Firewall";

      nvenc = {
        enable = mkEnableOption "NVIDIA Encoder";

        preset = mkOption {
          type = types.int;
          default = 3;
          description = "NVENC preset (1-7, where 1 is fastest/worst quality and 7 is slowest/best quality)";
          example = 3;
        };

        twopass = mkOption {
          type = types.enum [
            "full_res"
            "quarter_res"
          ];

          default = "full_res";

          description = "NVENC two-pass mode";

          example = "full_res";
        };
      };
    };
  };

  # boot.kernelParams = [ "video=HDMI-A-1:2880:1920@120D" ];
  config = {
    services.sunshine = mkIf cfg.sunshine.enable {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = cfg.sunshine.openFirewall;

      package = mkIf cfg.sunshine.nvenc.enable (
        pkgs.sunshine.override {
          cudaSupport = true;
        }
      );

      settings = {
        sunshine_name = cfg.sunshine.name;
        max_bitrate = cfg.sunshine.max_bitrate;
        encoder = mkIf cfg.sunshine.nvenc.enable "nvenc";
        nvenc_preset = cfg.sunshine.nvenc.preset;
        nvenc_twopass = cfg.sunshine.nvenc.twopass;
      };
    };

    networking.firewall = mkIf cfg.sunshine.openFirewall {
      allowedTCPPorts = [
        47984
        47989
        47990
        48010
      ];
      allowedUDPPortRanges = [
        {
          from = 47998;
          to = 48000;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
    };
  };
}
