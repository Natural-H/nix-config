{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.nixosWslConfig = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      self.nixosModules.naturalh
    ];

    nix = let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      };

      registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    };

    nixpkgs.config.allowUnfree = true; # Allow unfree packages
    nixpkgs.hostPlatform = {system = "x86_64-linux";};

    nix-linker.includeGuiLibraries = false;

    wsl = {
      enable = true;
      defaultUser = "naturalh";
      startMenuLaunchers = true;
      docker-desktop.enable = true;
    };

    users.groups.kubeadmin.members = ["naturalh"];

    programs.zsh.enable = true;

    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;

      daemon.settings = {
        ipv6 = true;
        fixed-cidr-v6 = "fd00::/80";
      };
    };

    networking.firewall.trustedInterfaces = ["br-+"];

    environment = {
      systemPackages = with pkgs; [
        # Add your system packages here
        git
        lazygit
        htop
        gitkraken
        home-manager
        xclip
        xdg-utils
        wsl-open
      ];
      variables = {
        BROWSER = "wsl-open";
      };
    };
    services = {
      passSecretService.enable = true;

      k3s = {
        enable = true;
        extraFlags = [
          "--write-kubeconfig-group=kubeadmin"
          "--write-kubeconfig-mode=640"
        ];
      };
    };
  };
}
