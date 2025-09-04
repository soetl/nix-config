{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeManagerModules.core.shell.tools;
in
with lib;
{
  options.homeManagerModules.core.shell.tools = {
    enable = mkEnableOption "Enhanced shell tools and utilities";

    eza = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable eza (modern ls replacement)";
      };

      enableFishIntegration = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Fish shell integration for eza";
      };

      git = mkOption {
        type = types.bool;
        default = true;
        description = "Show git status in eza output";
      };

      icons = mkOption {
        type = types.enum [
          "auto"
          "always"
          "never"
        ];
        default = "auto";
        description = "When to show icons in eza output";
      };

      aliases = mkOption {
        type = types.attrsOf types.str;
        default = {
          ls = "eza";
          ll = "eza -la";
          la = "eza -a";
          lt = "eza --tree";
          l = "eza -l";
        };
        description = "Aliases for eza commands";
      };
    };

    bat = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable bat (syntax highlighting cat)";
      };

      theme = mkOption {
        type = types.str;
        default = "TwoDark";
        description = "Bat color theme";
      };

      aliases = mkOption {
        type = types.attrsOf types.str;
        default = {
          cat = "bat";
        };
        description = "Aliases for bat commands";
      };
    };

    ripgrep = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable ripgrep (fast grep alternative)";
      };

      arguments = mkOption {
        type = types.listOf types.str;
        default = [
          "--max-columns=150"
          "--max-columns-preview"
          "--smart-case"
        ];
        description = "Default arguments for ripgrep";
      };

      aliases = mkOption {
        type = types.attrsOf types.str;
        default = {
          grep = "rg";
        };
        description = "Aliases for ripgrep commands";
      };
    };

    fd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable fd (fast find alternative)";
      };

      hidden = mkOption {
        type = types.bool;
        default = true;
        description = "Search hidden files by default";
      };

      ignores = mkOption {
        type = types.listOf types.str;
        default = [
          ".git/"
          "*.bak"
          "node_modules/"
          ".cache/"
        ];
        description = "Patterns to ignore when searching";
      };

      aliases = mkOption {
        type = types.attrsOf types.str;
        default = {
          find = "fd";
        };
        description = "Aliases for fd commands";
      };
    };

    fzf = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable fzf (fuzzy finder)";
      };

      enableFishIntegration = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Fish shell integration for fzf";
      };

      defaultOptions = mkOption {
        type = types.listOf types.str;
        default = [
          "--height=40%"
          "--layout=reverse"
          "--border"
          "--preview-window=right:60%"
        ];
        description = "Default options for fzf";
      };

      fileCommand = mkOption {
        type = types.str;
        default = "fd --type f --hidden --follow --exclude .git";
        description = "Command to generate file list for fzf";
      };
    };

    monitoring = {
      htop = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable htop (interactive process viewer)";
        };

        vimMode = mkOption {
          type = types.bool;
          default = true;
          description = "Enable vim-style navigation in htop";
        };

        showProgramPath = mkOption {
          type = types.bool;
          default = false;
          description = "Show full program paths in htop";
        };
      };

      btop = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable btop (resource monitor)";
        };

        theme = mkOption {
          type = types.str;
          default = "Default";
          description = "btop color theme";
        };

        vimKeys = mkOption {
          type = types.bool;
          default = true;
          description = "Enable vim-style navigation in btop";
        };
      };

      bottom = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable bottom (btm) - A cross-platform graphical process/system monitor";
        };
      };
    };

    archives = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable archive utilities (zip, unzip, etc.)";
      };

      packages = mkOption {
        type = types.listOf types.str;
        default = [
          "zip"
          "unzip"
          "xz"
          "p7zip"
          "gnutar"
          "bzip2"
          "gzip"
        ];
        description = "Archive utility packages to install";
      };
    };

    network = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable network utilities";
      };

      packages = mkOption {
        type = types.listOf types.str;
        default = [
          "wget"
          "curl"
        ];
        description = "Network utility packages to install";
      };
    };

    misc = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable miscellaneous utilities";
      };

      packages = mkOption {
        type = types.listOf types.str;
        default = [
          "tree"
          "jq"
          "yq"
          "delta"
        ];
        description = "Miscellaneous utility packages to install";
      };
    };
  };

  config = mkIf cfg.enable {
    # Install packages
    home.packages =
      with pkgs;
      (optionals cfg.eza.enable [ eza ])
      ++ (optionals cfg.bat.enable [ bat ])
      ++ (optionals cfg.ripgrep.enable [ ripgrep ])
      ++ (optionals cfg.fd.enable [ fd ])
      ++ (optionals cfg.fzf.enable [ fzf ])
      ++ (optionals cfg.monitoring.htop.enable [ htop ])
      ++ (optionals cfg.monitoring.btop.enable [ btop ])
      ++ (optionals cfg.monitoring.bottom.enable [ bottom ])
      ++ (optionals cfg.archives.enable (map (pkg: pkgs.${pkg}) cfg.archives.packages))
      ++ (optionals cfg.network.enable (map (pkg: pkgs.${pkg}) cfg.network.packages))
      ++ (optionals cfg.misc.enable (map (pkg: pkgs.${pkg}) cfg.misc.packages));

    # Configure programs
    programs = {
      eza = mkIf cfg.eza.enable {
        enable = true;
        enableFishIntegration = cfg.eza.enableFishIntegration && config.programs.fish.enable;
        git = cfg.eza.git;
        icons = cfg.eza.icons;
      };

      bat = mkIf cfg.bat.enable {
        enable = true;
        config = {
          theme = cfg.bat.theme;
        };
      };

      ripgrep = mkIf cfg.ripgrep.enable {
        enable = true;
        arguments = cfg.ripgrep.arguments;
      };

      fd = mkIf cfg.fd.enable {
        enable = true;
        hidden = cfg.fd.hidden;
        ignores = cfg.fd.ignores;
      };

      fzf = mkIf cfg.fzf.enable {
        enable = true;
        enableFishIntegration = cfg.fzf.enableFishIntegration && config.programs.fish.enable;
        defaultOptions = cfg.fzf.defaultOptions;
        fileWidgetCommand = cfg.fzf.fileCommand;
        changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
      };

      htop = mkIf cfg.monitoring.htop.enable {
        enable = true;
        settings = {
          vim_mode = cfg.monitoring.htop.vimMode;
          show_program_path = cfg.monitoring.htop.showProgramPath;
        };
      };

      btop = mkIf cfg.monitoring.btop.enable {
        enable = true;
        settings = {
          color_theme = cfg.monitoring.btop.theme;
          vim_keys = cfg.monitoring.btop.vimKeys;
        };
      };
    };

    # Set up shell aliases (these will be picked up by the fish module if enabled)
    homeManagerModules.core.shell._aliases = mkMerge [
      (mkIf cfg.eza.enable cfg.eza.aliases)
      (mkIf cfg.bat.enable cfg.bat.aliases)
      (mkIf cfg.ripgrep.enable cfg.ripgrep.aliases)
      (mkIf cfg.fd.enable cfg.fd.aliases)
    ];

    # Set up environment variables for fzf integration
    home.sessionVariables = mkIf cfg.fzf.enable {
      FZF_DEFAULT_OPTS = concatStringsSep " " cfg.fzf.defaultOptions;
      FZF_DEFAULT_COMMAND = cfg.fzf.fileCommand;
      FZF_CTRL_T_COMMAND = cfg.fzf.fileCommand;
    };
  };
}
