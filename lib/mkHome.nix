{
  inputs,
  getPackages,
  ...
}: {
  system,
  user,
  wsl ? false,
  hardwareSpecific,
  problematicPrograms,
}: let
  isWsl = wsl;

  userConfig = ../users/${user}/home-manager.nix;
  packages = getPackages {system = system;};

  createHome = inputs.home-manager.lib.homeManagerConfiguration;
in
  createHome rec {
    pkgs = packages.pkgs-unstable;
    modules =
      [
        (import userConfig {
          inherit isWsl packages inputs hardwareSpecific;
        })
        inputs.flatpaks.homeManagerModules.nix-flatpak
        inputs.vscode-server.homeModules.default
      ]
      ++ (inputs.nixpkgs.lib.optionals (problematicPrograms.useCiscoPacketTracer) [
        ../modules/problematic/packettracer.nix
      ]);
  }
