{
  description = "Nixos config flake";

  inputs = {
    # Nixpkgs, I'll try to update the wsl config to the latest stable later
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-wsl.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager-wsl = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-wsl";
    };
  };

  outputs = {
    self,
    nixpkgs-stable,
    nixpkgs-wsl,
    nixos-wsl,
    home-manager,
    home-manager-wsl,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-laptop = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/laptop/nixos/configuration.nix
        ];
      };

      nixos-wsl = nixpkgs-wsl.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { inherit inputs outputs; };
        modules = [
          { networking.hostName = "nixos-wsl"; }
          nixos-wsl.nixosModules.default
          ./hosts/wsl/nixos/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      # "naturalh@nixos-laptop" = home-manager.lib.homeManagerConfiguration {
      #   pkgs = nixpkgs.legacyPackages.x86_64-linux;
      #   extraSpecialArgs = { inherit inputs; };
      #   modules = [ ./hosts/laptop/home-manager/home.nix ];
      # };

      "naturalh@nixos-wsl" = home-manager-wsl.lib.homeManagerConfiguration  rec {
        pkgs = nixpkgs-wsl.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./hosts/wsl/home-manager/home.nix ];
      };
    };
  };
}
