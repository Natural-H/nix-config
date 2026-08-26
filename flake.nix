{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flatpaks.url = "github:gmodena/nix-flatpak/?ref=latest";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    getPackages = {system}: {
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    };

    machines = {
      nix-thinkbook16 = {
        system = "x86_64-linux";
        nixpkgs = nixpkgs-unstable;
        users = [
          "naturalh"
        ];
        stateVersion = "26.05";
      };

      nixos-desktop = {
        system = "x86_64-linux";
        nixpkgs = nixpkgs-unstable;
        users = [
          "naturalh"
          "mikeus"
        ];
        stateVersion = "26.05";
      };

      nixos-wsl = {
        system = "x86_64-linux";
        nixpkgs = nixpkgs-unstable;
        users = [
          "naturalh"
        ];
        wsl = true;
        stateVersion = "26.05";
      };
    };

    # for each user in machines, create a home configuration
    homes =
      import ./lib/utils/getHomes.nix {
        inherit nixpkgs;
      }
      machines;

    createMachines = import ./lib/utils/createMachines.nix {
      inherit inputs getPackages;
    };

    createHomes = import ./lib/utils/createHomes.nix {
      inherit inputs getPackages;
    };
  in {
    nixosConfigurations = createMachines machines;
    homeConfigurations = createHomes homes;
  };
}
