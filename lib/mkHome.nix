{ inputs, nixpkgs, nixpkgs-stable, ... }:

{
  system,
  user,
  wsl ? false,
  hardwareSpecific
}:
let
  isWsl = wsl;

  userConfig = ../users/${user}/home-manager.nix;

  createHome = inputs.home-manager.lib.homeManagerConfiguration;
in createHome rec {
  pkgs = nixpkgs.legacyPackages.${system};
  extraSpecialArgs = {
    inherit inputs;
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  };
  modules = [
    userConfig
    
    {
      config._module.args = {
        inputs = inputs;
        currentSystem = system;
        isWsl = isWsl;
        hardwareSpecific = hardwareSpecific;
      };
    }
  ];
}