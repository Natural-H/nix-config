# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      #flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    # channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };
  nixpkgs.config.allowUnfree = true; # Allow unfree packages

  wsl = {
    enable = true; # Enable WSL support
    defaultUser = "naturalh"; # Set the default user for WSL
    startMenuLaunchers = true;
    docker-desktop.enable = true;
  };
  programs.nix-ld.enable = lib.mkForce true;
  users.groups.kubeadmin.members = ["naturalh"];
  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    # enableSyntaxHighlighting = true;
    # enableAutosuggestions = true;
    # shellAliases = {
    #   ll = "ls -l";
    #   la = "ls -la";
    #   l = "ls -CF";
    #   pbcopy = "xclip -selection clipboard";
    #   pbpaste = "xclip -selection clipboard -o";
    # };
  };
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # Add your system packages here
      git
      lazygit
      htop
      gitkraken
      home-manager
      wslu
      xclip
      xdg-utils
    ];
    variables = {
      BROWSER = "${pkgs.wslu}/bin/wslview";
    };
  };
  services.k3s = {
    enable = true;
    extraFlags = [
      "--write-kubeconfig-group=kubeadmin"
      "--write-kubeconfig-mode=640"
      "--disable=traefik"
      #"--disable=servicelb"
      #"--disable=metrics-server"
      #"--disable=local-storage"
    ];
    # extraArgs = {
    #   "kubelet" = [
    #     "--node-ip=$(ip -4 addr show dev eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"
    #     "--cgroup-driver=systemd"
    #   ];
    #   "kube-proxy" = [
    #     "--proxy-mode=ipvs"
    #     "--ipvs-scheduler=rr"
    #   ];
    # };
    # extraK3sConfig = {
    #   "kubelet" = {
    #     "cgroup-driver" = "systemd";
    #     "node-ip" = "${pkgs.writeShellScript "get-node-ip" ''
    #       ip -4 addr show dev eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
    #     ''}";
    #   };
    #   "kube-proxy" = {
    #     "proxy-mode" = "ipvs";
    #     "ipvs-scheduler" = "rr";
    #   };
    # };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
