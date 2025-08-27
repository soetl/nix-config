{
  outputs,
  pkgs,
  vars,
  ...
}:
{
  imports = [
    outputs.homeManagerModules.desktop
  ];

  # Enable shell modules
  homeManagerModules.desktop.shell = {
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
        zed = "WAYLAND_DISPLAY='' zeditor";
      };
    };

    starship = {
      enable = true;
    };
  };

  # Audio configuration
  homeManagerModules.desktop.audio.noiseReduction = {
    enable = true;
    rnnoise = {
      vadThreshold = 50.0;
      vadGracePeriod = 200;
    };
    autostart = true;
  };

  # Fonts configuration
  homeManagerModules.desktop.fonts = {
    enable = true;
    jetbrainsMono.enable = true;
  };

  home = {
    username = vars.user.name;
    homeDirectory = "/home/${vars.user.name}";
    stateVersion = "25.05";

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
    };
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
