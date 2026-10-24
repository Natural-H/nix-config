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

      # daemon.settings = {
      #   ipv6 = true;
      #   fixed-cidr-v6 = "fd00::/80";
      # };
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

    sops = {
      age = {
        keyFile = "/home/naturalh/.config/sops/age/keys.txt";
        generateKey = true;
      };

      secrets = {
        forgejo-naturalh-token = {
          format = "dotenv";
          sopsFile = ../../../secrets/forgejo-naturalh-token.env;
          key = "";
        };
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

      gitea-actions-runner = {
        package = pkgs.forgejo-runner;
        instances = {
          "naturalh@git-naturalh-dev" = {
            enable = true;
            url = "https://git.naturalh.dev";
            tokenFile = config.sops.secrets.forgejo-naturalh-token.path;
            name = config.networking.hostName;
            labels = [
              "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-24.04"
            ];

            settings = {
              runner = {
                capacity = 4;
              };

              container = {
                docker_host = "automount";
                # enable_ipv6 = true;
              };
            };
          };
        };
      };
    };
  };
}
