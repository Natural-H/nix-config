{ config, lib, pkgs, packages, isWsl, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mikeus";
  home.homeDirectory = "/home/mikeus";
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    lazygit
    lazydocker
    gitkraken
    tree
    btop
    xclip
    lazysql
  ] ++ (lib.optionals (!isWsl) [
    (prismlauncher.override {
      jdks = [
        graalvm-ce
        zulu8
        zulu17
        zulu
      ];
    })

    brave
    nix-index
    vscode
    libreoffice-qt6
    vesktop
    mission-center
    blender-hip

    obs-studio
    imagemagick
    ffmpeg
    mangohud
    mangojuice
    nvtopPackages.amd

    jdk24
    dotnetCorePackages.dotnet_9.sdk

    wineWowPackages.waylandFull
  ] ++ (with packages.pkgs; [ osu-lazer-bin ]));

  programs.git = {
    enable = true;
    userName = "mikeus";
    userEmail = "mikeleche1232@outlook.com";
    extraConfig = {
      safe.directory = [ "/etc/nixos" ];
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    # Enable completion, syntax highlighting, and autosuggestions
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = false;
    history = {
      size = 10000; # Set history size
      share = false; # Share history across sessions
    };
    historySubstringSearch = {
      enable = true; # Enable substring search in history
      searchDownKey = "^[OB"; # Key to search down
      searchUpKey = "^[OA"; # Key to search up
    };
    # initExtra = if isWsl then ''
    # bindkey '^[[1;3D' backward-word
    # bindkey '^[[1;3C' forward-word
    # bindkey '^[[1;5D' beginning-of-line
    # bindkey '^[[1;5C' end-of-line
    # eval `ssh-agent -s | grep -v 'echo'`
    # '' else ""; # this will be added later for non-wsl systems

    shellAliases = {
      pbcopy = "xclip -selection clipboard";
      pbpaste = "xclip -selection clipboard -o";
      # plasma needs first a user update then a system update to link correctly
      amogos = "sudo chmod g+w /etc/nixos -R; home-manager switch --flake ~/nixos; sudo nixos-rebuild switch";
    };
  };

  programs.firefox = {
    policies = {
      Homepage.StartPage = "previous-session";
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/naturalh/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "EMACS";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
