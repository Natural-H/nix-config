# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "naturalh";
    homeDirectory = "/home/naturalh";
    
    packages = with pkgs; [
        # Add your home packages here
        wget
        curl
        vim
        git
        htop
        neofetch
        tree
        openssh
        btop
        zellij
        k9s
        kubernetes-helm
        superfile
    ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.git.userName = "naturalh";
  programs.git.userEmail = "marco.mmtz@proton.me";
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
    initExtra = ''
    bindkey '^[[1;3D' backward-word
    bindkey '^[[1;3C' forward-word
    bindkey '^[[1;5D' beginning-of-line
    bindkey '^[[1;5C' end-of-line
    eval `ssh-agent -s | grep -v 'echo'`
    '';

    shellAliases = {
      pbcopy = "xclip -selection clipboard";
      pbpaste = "xclip -selection clipboard -o";
      nix-update-machine = "sudo nixos-rebuild switch; home-manager switch";
    };
  };
  # programs.zellij.enable = true;
  programs.zellij.enableZshIntegration = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
