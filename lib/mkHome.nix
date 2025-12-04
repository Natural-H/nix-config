{
  inputs,
  getPackages,
  ...
}: {
  system,
  user,
  wsl ? false,
}: let
  isWsl = wsl;

  userConfig = ../users/${user}/home-manager.nix;
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
      inputs.vscode-server.homeModules.default
      inputs.flatpaks.homeManagerModules.nix-flatpak
    ];
  }
