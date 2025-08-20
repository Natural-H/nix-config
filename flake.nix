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
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-laptop = mkSystem "nixos-laptop" {
        system = "x86_64-linux";
        users = [ "naturalh" ];
      };

      nixos-desktop = mkSystem "nixos-desktop" {
        system = "x86_64-linux";
        users = [ "naturalh" "mikeus" ];
      };

      nixos-wsl = mkSystem "nixos-wsl" {
        system = "x86_64-linux";
        users = [ "naturalh" ];
        wsl = true;
      };
    };

    homeConfigurations = {
      "naturalh@nixos-laptop" = mkHome {
        system = "x86_64-linux";
        user = "naturalh";
      };

      "naturalh@nixos-desktop" = mkHome {
        system = "x86_64-linux";
        user = "naturalh";
      };

      "mikeus@nixos-desktop" = mkHome {
        system = "x86_64-linux";
        user = "mikeus";
      };

      "naturalh@nixos-wsl" = mkHome {
        system = "x86_64-linux";
        user = "naturalh";
        wsl = true;
      };
    };
  };
}
