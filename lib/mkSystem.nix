{ nixpkgs, inputs, ... }:

name:
{
  system,
  users,
  wsl ? false
}:
let
  isWsl = wsl;

  machineConfig = ../machines/${name}.nix;
  usersConfig = nixpkgs.lib.forEach users (user: ../users/${user}/${user}.nix);

  # createSystem = if isWsl then inputs.nixpkgs-wsl.lib.nixosSystem else inputs.nixpkgs-stable.lib.nixosSystem;
  createSystem = inputs.nixpkgs.lib.nixosSystem;
in createSystem rec {
  inherit system;
  modules = [
    { networking.hostName = name; }
    { nixpkgs.config.allowUnfree = true; }
    (if isWsl then inputs.nixos-wsl.nixosModules.default else {})
    machineConfig

    {
      config._module.args = {
        inherit isWsl inputs;
        currentSystem = system;
      };
    }
  ] ++ usersConfig;
}