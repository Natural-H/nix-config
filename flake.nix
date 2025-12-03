{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-graalvm21.url = "github:nixos/nixpkgs/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3";
    flatpaks.url = "github:gmodena/nix-flatpak/?ref=latest";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
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
    flatpaks,
    vscode-server,
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
        problematicPrograms = {
          # distrobox is complaining about libcrypto for some reason
          useCiscoPacketTracer = true;
        };
        enableNixLd = true;
      };

      nixos-laptop = {
        system = "x86_64-linux";
        users = ["naturalh"];
      };

      nix-hp-pavilion = {
        system = "x86_64-linux";
        users = ["naturalh" "mikeus"];
        enableNixLd = true;
        # problematicPrograms = {
        #   # needs to be added to nix store manually
        #   useCiscoPacketTracer = true;
        # };
      };

      nixos-desktop = {
        system = "x86_64-linux";
        users = ["naturalh" "mikeus"];
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
        users = ["naturalh"];
        wsl = true;
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
    nixosConfigurations = createMachines {
      inherit machines;
    };

    homeConfigurations = createHomes {
      inherit homes;
    };
  };
}
