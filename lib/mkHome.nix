{ nixpkgs, inputs, ... }:

name:
{
  system,
  user,
  wsl ? false
}:
let
  isWsl = wsl;

  userConfig = ../users/${user}/home-manager.nix;

  createHome = inputs.home-manager.lib.homeManagerConfiguration;
in createHome rec {
  pkgs = nixpkgs.legacyPackages.${system};
  extraSpecialArgs = {
    inherit inputs; 
    # isWsl = isWsl;
  };
  modules = [
    userConfig
    
    {
      config._module.args = {
        inputs = inputs;
        currentSystem = system;
        isWsl = isWsl;
      };
    }
  ];
}