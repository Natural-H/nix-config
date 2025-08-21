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
      nixos-laptop = {
        system = "x86_64-linux";
        users = [ "naturalh" ];
      };

      nix-hp-pavilion = {
        system = "x86_64-linux";
        users = [ "naturalh" ];
      };

      nixos-desktop = {
        system = "x86_64-linux";
        users = [ "naturalh" "mikeus" ];
      };

      nixos-wsl = {
        system = "x86_64-linux";
        users = [ "naturalh" ];
        wsl = true;
      };
    };

    # for each user in machines, create a home configuration
    homes = nixpkgs.lib.foldlAttrs (acc: name: config:
        acc // nixpkgs.lib.listToAttrs(nixpkgs.lib.map (
            user: {
              name = "${user}@${name}";
              value = {inherit (config) system; inherit user; wsl = config.wsl or false;};
            }
          ) config.users)
    ) ({}) machines;
  in {
    nixosConfigurations = nixpkgs.lib.mapAttrs (name: config: (
      mkSystem "${name}" { inherit (config) system users; wsl = config.wsl or false; }
    )) machines;

    homeConfigurations = nixpkgs.lib.mapAttrs (name: config: (
      mkHome { inherit (config) system user wsl; }
    )) homes;
  };
}
