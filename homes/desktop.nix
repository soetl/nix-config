{
  inputs,
  outputs,
  pkgs,
  vars,
  ...
}:
{
  imports = [
    outputs.homeManagerModules.core
    outputs.homeManagerModules.desktop
    inputs.illogicalImpulse.homeManagerModules.default
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
        zed = "zeditor";
      };
    };

    starship = {
      enable = true;
    };
  };

  homeManagerModules.core.audio.noiseReduction = {
    enable = true;
    rnnoise = {
      vadThreshold = 60.0;
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
      chromium

      # Development
      zed-editor
      vscode
      git-crypt
      pre-commit
      git-credential-manager

      # Communication
      telegram-desktop
      discord

      # Media & Graphics
      vlc
      davinci-resolve

      rofi-wayland
      dunst
      kdePackages.polkit-kde-agent-1
    ];

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
      TERMINAL_FONT = "JetBrainsMono Nerd Font";
    };

    stateVersion = "25.11";
  };

  homeManagerModules.desktop = {
    hyprland.enable = false;
    waybar.enable = false;
    illogical-impulse.enable = false;
  };

  programs.illogical-impulse.enable = true;

  systemd.user.services.polkit-kde-authentication-agent-1 = {
    Unit = {
      Description = "polkit-kde-authentication-agent-1";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  programs.kitty.enable = true;

  programs = {
    firefox = {
      enable = true;
    };

    git = {
      enable = true;
      userName = vars.user.name;
      userEmail = vars.user.email;
      extraConfig = {
        init.defaultBranch = "main";

        pull.rebase = false;
        push.autoSetupRemote = true;

        credential = {
          helper = "manager";
          credentialStore = "cache";
          "https://github.com".username = "soetl";
        };
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
