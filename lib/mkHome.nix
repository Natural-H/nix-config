{
  inputs,
  getPackages,
  nixpkgs,
}: {
  system,
  user,
  wsl ? false,
  hostname,
  ...
}: let
  isWsl = wsl;

  userConfig = ../users/${user}/home-manager.nix;
  hostSpecificConfig = ../users/${user}/by-machine/${hostname}/default.nix;
  allPackages = getPackages {inherit system;};
  # createHome = inputs.home-manager.lib.homeManagerConfiguration;
in
  inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = allPackages.pkgs-unstable;

    extraSpecialArgs = {
      inherit isWsl allPackages;
    };

    modules = [
      ../modules/home-manager/default.nix
      userConfig
      (
        if nixpkgs.lib.pathExists hostSpecificConfig
        then hostSpecificConfig
        else {}
      )
      inputs.vscode-server.homeModules.default
      inputs.flatpaks.homeManagerModules.nix-flatpak
    ];
  }
