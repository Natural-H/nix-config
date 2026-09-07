{
  self,
  inputs,
  ...
}: let
  username = "naturalh";
in {
  flake.homeModules.${username} = {
    pkgs,
    config,
    isWsl,
    stateVersion,
    ...
  }: let
    dotnet = with pkgs.dotnetCorePackages;
      combinePackages (with pkgs; [
        dotnet-sdk
        dotnet-sdk_9
        dotnet-sdk_10
      ]);
  in {
    imports = [
      self.homeModules.naturalhNonwsl
      self.homeModules.perHostNaturalh
      self.homeModules.nix-gc
      inputs.flatpaks.homeManagerModules.nix-flatpak
      inputs.vscode-server.homeModules.default
      inputs.lazyvim.homeManagerModules.default
    ];

    wsl.useNonWsl = !isWsl;

    home.username = "${username}";
    home.homeDirectory = "/home/${username}";
    home.stateVersion = stateVersion;

    home.packages = with pkgs; [
      pangolin-cli

      alejandra
      nixd
      lazydocker
      gitkraken

      tree
      btop
      xclip
      lazysql
      poppler-utils
      insomnia
      bruno
      nil
      desktop-file-utils
      eza

      python313
      python313Packages.numpy
      python313Packages.pip

      cmake
      gnumake
      ninja
      gcc
      gdb

      nodejs
      pnpm
      prisma-engines

      jdk

      go
      dotnet
      cloudflared
      opencode
      lmstudio
    ];

    programs = {
      git = {
        enable = true;
        package = pkgs.gitFull;

        settings = {
          user.name = "naturalh";
          user.email = "marco.mmtz@proton.me";

          init.defaultBranch = "main";
        };
      };

      gh = {
        enable = true;
      };

      zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = false;
        dotDir = "${config.xdg.configHome}/zsh";
        history = {
          size = 10000;
          share = false;
        };

        historySubstringSearch = {
          enable = true;
          searchDownKey = "^[OB";
          searchUpKey = "^[OA";
        };

        initContent = ''
          bindkey '^[[1;5D' backward-word
          bindkey '^[[1;5C' forward-word
          bindkey '^[[H' beginning-of-line
          bindkey '^[[F' end-of-line
          bindkey '^[[3~' delete-char
        '';

        shellAliases = {
          pbcopy = "xclip -selection clipboard";
          pbpaste = "xclip -selection clipboard -o";

          ls = "eza";
          cat = "bat";

          nix-update-machine =
            if isWsl
            then "sudo nixos-rebuild switch"
            else "sudo nixos-rebuild switch; update-desktop-database";
          nix-test-machine =
            if isWsl
            then "sudo nixos-rebuild test"
            else "sudo nixos-rebuild test; update-desktop-database";
        };
      };

      lazygit = {
        enable = true;
        enableZshIntegration = true;
      };

      fzf = {
        enable = true;
        enableZshIntegration = false; # avoid conflicts with atuin
      };

      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          prettybat
        ];
      };

      atuin = {
        enable = true;
        daemon.enable = true;
        enableZshIntegration = true;
      };

      eza = {
        enable = true;
        enableZshIntegration = true;
        git = true;
        icons = "auto";
        colors = "auto";
      };

      starship = {
        enable = true;
        enableZshIntegration = true;
      };

      lazyvim = {
        enable = true;

        extras = {
          lang.nix.enable = true;
          lang.python = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
          lang.go = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
        };

        extraPackages = with pkgs; [
          nixd
          alejandra
          statix
        ];

        treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
          wgsl
          templ
        ];
      };

      firefox = {
        policies = {
          Homepage.StartPage = "previous-session";
        };
      };
    };

    services = {
      ssh-agent = {
        enable = true;
      };
    };

    home.sessionVariables = {
      DOTNET_ROOT = "${dotnet}/share/dotnet";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
