{
  outputs,
  pkgs,
  vars,
  ...
}:
{
  imports = [
    outputs.homeManagerModules.core
    outputs.homeManagerModules.desktop
  ];

  homeManagerModules.core.shell = {
    tools = {
      enable = true;
      eza.enable = true;
      bat.enable = true;
      ripgrep.enable = true;
      fd.enable = true;
      fzf.enable = true;
      monitoring = {
        htop.enable = true;
        btop.enable = true;
        bottom.enable = true;
      };
      archives.enable = true;
      network.enable = true;
      misc.enable = true;
    };

    fish = {
      enable = true;
      enableIntegrations = true;
      enablePlugins = true;
      plugins = [
        "tide"
        "fzf-fish"
      ];
      aliases = {
        vi = "nvim";
        vim = "nvim";
        ".." = "cd ..";
        "..." = "cd ../..";
      };
    };

    starship = {
      enable = true;
    };
  };

  homeManagerModules.core.audio.noiseReduction = {
    enable = true;
    rnnoise = {
      vadThreshold = 50.0;
      vadGracePeriod = 200;
    };
    autostart = true;
  };

  homeManagerModules.core.font.jetbrainsMono.enable = true;

  home = {
    username = vars.user.name;
    homeDirectory = "/home/${vars.user.name}";

    packages = with pkgs; [
      # Browsers
      firefox
      chromium

      # Development
      zed-editor
      vscode
      git-crypt
      pre-commit

      # Communication
      telegram-desktop
      discord

      # Media & Graphics
      vlc
      davinci-resolve
    ];

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
      TERMINAL_FONT = "JetBrainsMono Nerd Font";
    };

    stateVersion = "25.11";
  };

  programs = {
    git = {
      enable = true;
      userName = vars.user.name;
      userEmail = vars.user.email;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
        push.autoSetupRemote = true;
      };
      delta.enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
