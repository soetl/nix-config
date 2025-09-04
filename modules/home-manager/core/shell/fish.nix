{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeManagerModules.core.shell.fish;
  toolsCfg = config.homeManagerModules.core.shell.tools or { };
  aliases = config.homeManagerModules.core.shell._aliases or { };
in
with lib;
{
  options.homeManagerModules.core.shell = {
    _aliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      internal = true;
      description = "Internal option for sharing aliases between shell modules";
    };
  };

  options.homeManagerModules.core.shell.fish = {
    enable = mkEnableOption "Fish shell configuration";

    defaultShell = mkOption {
      type = types.bool;
      default = false;
      description = "Set Fish as the default shell";
    };

    enableIntegrations = mkOption {
      type = types.bool;
      default = true;
      description = "Enable integrations with shell tools (if available)";
    };

    enablePlugins = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Fish plugins";
    };

    plugins = mkOption {
      type = types.listOf types.str;
      default = [
        "tide"
        "fzf-fish"
      ];
      description = "List of Fish plugins to install";
    };

    aliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Additional Fish shell aliases (merged with tool aliases)";
    };

    functions = mkOption {
      type = types.attrsOf (
        types.oneOf [
          types.str
          types.attrs
        ]
      );
      default = { };
      description = "Fish shell functions";
    };

    shellInit = mkOption {
      type = types.lines;
      default = "";
      description = "Shell initialization commands";
    };

    interactiveShellInit = mkOption {
      type = types.lines;
      default = "";
      description = "Interactive shell initialization commands";
    };

    abbreviations = mkOption {
      type = types.attrsOf types.str;
      default = {
        gst = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gl = "git pull";
        gd = "git diff";
        gco = "git checkout";
        gb = "git branch";
      };
      description = "Fish abbreviations (expandable shortcuts)";
    };
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;

      # Merge aliases from tools module and user-defined aliases
      shellAliases = aliases // cfg.aliases;

      # Shell abbreviations (fish-specific feature)
      shellAbbrs = cfg.abbreviations;

      functions = cfg.functions // {
        # Custom function for creating and entering directory
        mkcd = {
          description = "Create directory and cd into it";
          body = ''
            mkdir -p $argv[1]
            cd $argv[1]
          '';
        };

        # Function to extract various archive types
        extract = mkIf (toolsCfg.archives.enable or false) {
          description = "Extract various archive formats";
          body = ''
            switch (string lower (path extension $argv[1]))
              case '*.tar.bz2'
                tar xjf $argv[1]  # gnutar
              case '*.tar.gz'
                tar xzf $argv[1]  # gnutar
              case '*.bz2'
                bunzip2 $argv[1]  # bzip2
              case '*.rar'
                7z x $argv[1]  # p7zip
              case '*.gz'
                gunzip $argv[1]  # gzip
              case '*.tar'
                tar xf $argv[1]  # gnutar
              case '*.tbz2'
                tar xjf $argv[1]  # gnutar
              case '*.tgz'
                tar xzf $argv[1]  # gnutar
              case '*.zip'
                unzip $argv[1]  # unzip
              case '*.Z'
                uncompress $argv[1]  # gzip
              case '*.7z'
                7z x $argv[1]  # p7zip
              case '*'
                echo "'$argv[1]' cannot be extracted via extract()"
            end
          '';
        };

        # Function for quick project navigation (if fzf is available)
        proj = mkIf (toolsCfg.fzf.enable or false) {
          description = "Quick navigation to project directories";
          body = ''
            set project_dirs ~/Projects ~/Development ~/.config
            if command -v fd >/dev/null
              set selected (fd --type d --max-depth 2 --hidden --follow --exclude .git . $project_dirs | fzf --preview "eza --tree --level=2 {}" 2>/dev/null)
            else
              set selected (find $project_dirs -maxdepth 2 -type d 2>/dev/null | fzf)
            end
            if test -n "$selected"
              cd "$selected"
            end
          '';
        };

        # Function for finding and editing files with fzf
        vf = mkIf (toolsCfg.fzf.enable or false) {
          description = "Find and edit file with fzf";
          body = ''
            if command -v fd >/dev/null
              set selected (fd --type f --hidden --follow --exclude .git | fzf --preview "bat --color=always --style=header,grid --line-range :300 {}" 2>/dev/null)
            else
              set selected (find . -type f | fzf --preview "cat {}" 2>/dev/null)
            end
            if test -n "$selected"
              $EDITOR "$selected"
            end
          '';
        };

        # Function for git branch switching with fzf
        gco = mkIf (toolsCfg.fzf.enable or false) {
          description = "Git checkout branch with fzf";
          body = ''
            set branch (git branch --all | grep -v HEAD | string trim | fzf --preview "git log --oneline --graph --date=short --color=always --pretty='format:%C(auto)%cd %h%d %s' {}" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
            if test -n "$branch"
              git checkout "$branch"
            end
          '';
        };
      };

      plugins = mkIf cfg.enablePlugins (
        map (plugin: {
          name = plugin;
          src = pkgs.fishPlugins.${plugin}.src or (throw "Fish plugin '${plugin}' not found in nixpkgs");
        }) cfg.plugins
      );

      shellInit = ''
        # Disable greeting
        set -g fish_greeting

        # Set default editor
        set -gx EDITOR ${config.home.sessionVariables.EDITOR or "nvim"}

        ${cfg.shellInit}
      '';

      interactiveShellInit = ''
        # Enable vi mode
        fish_vi_key_bindings

        # Set up colors for tools integration
        ${optionalString cfg.enableIntegrations ''
          # Set up colors for eza
          ${optionalString (toolsCfg.eza.enable or false) ''
            set -gx EZA_COLORS "da=1;34:gm=1;34"
          ''}

          # fzf configuration (enhanced if fd is available)
          ${optionalString (toolsCfg.fzf.enable or false) ''
            # Use fd for fzf if available and enabled
            ${optionalString (toolsCfg.fd.enable or false) ''
              set -gx FZF_DEFAULT_COMMAND '${
                toolsCfg.fzf.fileCommand or "fd --type f --hidden --follow --exclude .git"
              }'
              set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
              set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"
            ''}
          ''}

          # Set up bat as manpager if bat is enabled
          ${optionalString (toolsCfg.bat.enable or false) ''
            set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
          ''}
        ''}

        # Custom key bindings
        bind \cf 'vf'  # Ctrl+F to find and edit files
        bind \cg 'proj'  # Ctrl+G to navigate to projects

        ${cfg.interactiveShellInit}
      '';
    };

    # Set as default shell if requested
    programs.fish.loginShellInit = mkIf cfg.defaultShell ''
      # Fish is now the default shell
    '';

    # Add Fish to valid login shells if it's the default
    home.sessionPath = mkIf cfg.defaultShell [ "${pkgs.fish}/bin" ];
  };
}
