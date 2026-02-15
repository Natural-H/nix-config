{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-graalvm21.url = "github:nixos/nixpkgs/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3";
    flatpaks.url = "github:gmodena/nix-flatpak/?ref=latest";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    # Home manager
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
        config = {allowUnfree = true;};
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {allowUnfree = true;};
      };

      # pinned package versions
      graalvm21 = inputs.nixpkgs-graalvm21.legacyPackages.${system}.graalvm-ce;
    };

    machines = {
      nix-thinkbook16 = {
        system = "x86_64-linux";
        users = ["naturalh"];
        stateVersion = "25.05";
      };

      nixos-desktop = {
        system = "x86_64-linux";
        users = ["naturalh" "mikeus"];
        stateVersion = "25.11";
      };

      nixos-wsl = {
        system = "x86_64-linux";
        users = ["naturalh"];
        wsl = true;
        stateVersion = "25.05";
      };
    };

    # for each user in machines, create a home configuration
    homes = import ./lib/utils/getHomes.nix {
      inherit nixpkgs machines;
    };

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
