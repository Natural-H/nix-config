{ nixpkgs, inputs, ... }:

name:
{
  system,
  user,
  wsl ? false
}:
let
  isWsl = wsl;

  machineConfig = ../machines/${name}.nix;
  userConfig = ../users/${user}/${user}.nix;

  # createSystem = if isWsl then inputs.nixpkgs-wsl.lib.nixosSystem else inputs.nixpkgs-stable.lib.nixosSystem;
  createSystem = inputs.nixpkgs.lib.nixosSystem;
in createSystem rec {
  inherit system;
  modules = [
    { networking.hostName = name; }
    { nixpkgs.config.allowUnfree = true; }
    (if isWsl then inputs.nixos-wsl.nixosModules.default else {})
    machineConfig
    userConfig
    
    {
      config._module.args = {
        inherit isWsl inputs;
        currentSystem = system;
      };
    }
  ];
}