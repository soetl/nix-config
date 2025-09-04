{
  config,
  lib,
  ...
}:
let
  cfg = config.nixosModules.desktop.apps._1password;
in
with lib;
{
  options.nixosModules.desktop.apps._1password = {
    enable = mkEnableOption "1Password CLI";
    gui = {
      enable = mkEnableOption "1Password GUI";
      polkitPolicyOwners = mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = lib.literalExpression ''["user1" "user2" "user3"]'';
        description = ''
          A list of users who should be able to integrate 1Password with polkit-based authentication mechanisms.
        '';
      };
    };
  };

  config = {
    programs._1password.enable = cfg.enable;
    programs._1password-gui.enable = cfg.gui.enable;
    programs._1password-gui.polkitPolicyOwners = cfg.gui.polkitPolicyOwners;
  };
}
