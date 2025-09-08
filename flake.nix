{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-wsl,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    mkSystem = import ./lib/mkSystem.nix {
      inherit nixpkgs inputs;
    };

    mkHome = import ./lib/mkHome.nix {
      inherit inputs;
      nixpkgs = nixpkgs-unstable;
      nixpkgs-stable = inputs.nixpkgs;
    };

    machines = {
      nix-thinkbook16 = {
        system = "x86_64-linux";
        users = [ "naturalh" ];
      };

      nixos-laptop = {
        system = "x86_64-linux";
        users = [ "naturalh" ];
      };

      nix-hp-pavilion = {
        system = "x86_64-linux";
        users = [ "naturalh" "mikeus" ];
        enableNixLd = true;
        # problematicPrograms = {
        #   # needs to be added to nix store manually
        #   useCiscoPacketTracer = true;
        # };
      };

      nixos-desktop = {
        system = "x86_64-linux";
        users = [ "naturalh" "mikeus" ];
        hardwareSpecific = {
          amd = {
            rocmCapable = true;
            hipCapable = true;
          };
        };
        enableNixLd = true;
      };

      nixos-wsl = {
        system = "x86_64-linux";
        users = [ "naturalh" ];
        wsl = true;
      };
    };

    # for each user in machines, create a home configuration
    homes = nixpkgs.lib.foldlAttrs (acc: host: config:
        acc // nixpkgs.lib.listToAttrs(nixpkgs.lib.map (
            user: {
              name = "${user}@${host}";
              value = {
                inherit (config) system;
                inherit user;
                wsl = config.wsl or false;
                hardwareSpecific = nixpkgs.lib.recursiveUpdate {
                  amd = {
                    rocmCapable = false;
                    hipCapable = false;
                  };
                } (config.hardwareSpecific or {});
                problematicPrograms = nixpkgs.lib.recursiveUpdate {
                  useCiscoPacketTracer = false;
                } (config.problematicPrograms or {});
              };
            }
          ) config.users)
    ) ({}) machines;
  in {
    nixosConfigurations = nixpkgs.lib.mapAttrs (host: config: (
      mkSystem "${host}" {
        inherit (config) system users;
        wsl = config.wsl or false;
        enableNixLd = config.enableNixLd or false;
      }
    )) machines;

    homeConfigurations = nixpkgs.lib.mapAttrs (host: config: (
      mkHome { inherit (config) system user wsl hardwareSpecific problematicPrograms; }
    )) homes;
  };
}
