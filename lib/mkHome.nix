{ inputs, getPackages, ... }:

{
  system,
  user,
  wsl ? false,
  hardwareSpecific,
  problematicPrograms
}:
let
  isWsl = wsl;

  userConfig = ../users/${user}/home-manager.nix;
  packages = getPackages { system = system; };

  createHome = inputs.home-manager.lib.homeManagerConfiguration;
in createHome rec {
  pkgs = packages.pkgs-unstable;
  extraSpecialArgs = {
    inherit inputs isWsl packages;
    hardwareSpecific = hardwareSpecific;
  };
  modules = [
    userConfig
    (if !isWsl then inputs.flatpaks.homeManagerModules.nix-flatpak else {})
    (if !isWsl then inputs.vscode-server.homeModules.default else {})

  ] ++ (inputs.nixpkgs.lib.optionals (problematicPrograms.useCiscoPacketTracer) [
    ../modules/problematic/packettracer.nix
  ]);
}