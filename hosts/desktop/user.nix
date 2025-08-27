{ pkgs, vars, ... }:
{
  users.users."${vars.user.name}" = {
    shell = pkgs.fish;
  };

  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };
  };
}
