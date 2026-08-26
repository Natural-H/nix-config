{
  getPackages,
  inputs,
}: hostname: {
  nixpkgs ? inputs.nixpkgs,
  system,
  users,
  wsl ? false,
  stateVersion,
  ...
}: let
  isWsl = wsl;
  name = hostname;

  machineConfig = ../machines/${name}/configuration.nix;
  usersConfig = nixpkgs.lib.forEach users (user: ../users/${user}/${user}.nix);
  createSystem = nixpkgs.lib.nixosSystem;
in
  createSystem rec {
    inherit system;

    specialArgs = {
      inherit isWsl system inputs name;
      allPackages = getPackages {inherit system;};
    };

    modules =
      [
        ./../modules/nixos/default.nix
        machineConfig
        inputs.flatpaks.nixosModules.nix-flatpak
        {
          networking.hostName = name;
          nixpkgs.config.allowUnfree = true;
          users.groups.nix-admins = {};
          system.stateVersion = stateVersion;
        }
      ]
      ++ (
        if isWsl
        then [
          inputs.nixos-wsl.nixosModules.default
        ]
        else []
      )
      ++ usersConfig;
  }
