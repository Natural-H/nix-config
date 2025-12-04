{
  nixpkgs,
  getPackages,
  inputs,
  ...
}: name: {
  system,
  users,
  wsl ? false,
  ...
}: let
  isWsl = wsl;

  machineConfig = ../machines/${name}/configuration.nix;
  usersConfig = nixpkgs.lib.forEach users (user: ../users/${user}/${user}.nix);
  # createSystem = if isWsl then inputs.nixpkgs-wsl.lib.nixosSystem else inputs.nixpkgs-stable.lib.nixosSystem;
  # createSystem = nixpkgs.lib.nixosSystem;
in
  nixpkgs.lib.nixosSystem rec {
    inherit system;

    specialArgs = {
      inherit isWsl system inputs name;
      allPackages = getPackages {inherit system;};
    };

    modules =
      [
        ./../modules/nixos/default.nix
        machineConfig
      ]
      ++ (
        if isWsl
        then [
          inputs.nixos-wsl.nixosModules.default
        ]
        else [
          inputs.flatpaks.nixosModules.nix-flatpak
        ]
      )
      ++ usersConfig;
  }
