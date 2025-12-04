{
  inputs,
  getPackages,
  ...
}: {
  system,
  user,
  wsl ? false,
  hardwareSpecific,
  ...
}: let
  isWsl = wsl;

  userConfig = ../users/${user}/home-manager.nix;
  packages = getPackages {system = system;};

  createHome = inputs.home-manager.lib.homeManagerConfiguration;
in
  createHome {
    pkgs = packages.pkgs-unstable;
    modules = [
      (import userConfig {
        inherit isWsl packages inputs hardwareSpecific;
      })
      inputs.flatpaks.homeManagerModules.nix-flatpak
      inputs.vscode-server.homeModules.default

      ../modules/home-manager/default.nix
    ];
  }
